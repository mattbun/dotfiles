{ lib
, config
, ...
}: {
  options.programs.llama-swap = with lib; {
    connections = lib.mkOption {
      type = types.attrsOf
        (types.submodule {
          options = {
            url = lib.mkOption {
              type = types.str;
              default = "http://localhost:9292";
            };

            models = {
              chat = lib.mkOption {
                type = types.listOf types.str;
                default = [ ];
              };

              embedding = lib.mkOption {
                type = types.listOf types.str;
                default = [ ];
              };

              reranker = lib.mkOption {
                type = types.listOf types.str;
                default = [ ];
              };
            };
          };
        });
      default = { };
    };
  };

  config =
    let
      cfg = config.programs.llama-swap;
    in
    {
      programs = {
        aichat = {
          clients = lib.mapAttrs
            (name: connection: {
              settings = {
                type = "openai-compatible";
                name = name;
                api_base = "${connection.url}/v1";
              };

              models = lib.listToAttrs (
                (map
                  (model: {
                    name = model;
                    value = { name = model; };
                  })
                  connection.models.chat
                ) ++
                (map
                  (model: {
                    name = model;
                    value = {
                      name = model;
                      type = "embedding";
                    };
                  })
                  connection.models.embedding
                ) ++
                (map
                  (model: {
                    name = model;
                    value = {
                      name = model;
                      type = "reranker";
                    };
                  })
                  connection.models.reranker
                )
              );
            })
            cfg.connections;
        };

        neovim.codecompanion = {
          adapters = lib.mergeAttrsList (
            lib.flatten (
              lib.attrValues (
                builtins.mapAttrs
                  (name: connection:
                    (map
                      (model:
                        let modelName = "${name}:${model}"; in {
                          "${modelName}" = {
                            adapter = "openai";
                            model = model;
                            settings = {
                              name = "${modelName}";
                              formatted_name = "${modelName}";
                              url = "${connection.url}/v1/chat/completions";
                              schema = {
                                model = {
                                  default = model;
                                };
                              };
                              stream = true;
                            };
                          };
                        })
                      connection.models.chat
                    )
                  )
                  cfg.connections
              )
            )
          );
        };
      };
    };
}
