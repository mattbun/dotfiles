{ lib
, config
, pkgs
, ...
}: {
  options.programs.ollama = with lib; {
    enable = lib.mkEnableOption "ollama";

    defaultModel = lib.mkOption {
      type = types.str;
    };

    defaultConnection = lib.mkOption {
      type = types.str;
      default =
        let
          connections = lib.attrNames config.programs.ollama.connections;
        in
        if ((builtins.length connections) > 0) then (builtins.head connections) else null;
    };

    connections = lib.mkOption {
      type = types.attrsOf
        (types.submodule {
          options = {
            url = lib.mkOption {
              type = types.str;
              default = "http://localhost:11434";
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
    };
  };

  config =
    let
      cfg = config.programs.ollama;
      defaultUrl = cfg.connections."${cfg.defaultConnection}".url;
      defaultConnModel = "${cfg.defaultConnection}:${cfg.defaultModel}";
    in
    lib.mkIf cfg.enable {
      home = {
        packages = with pkgs; [
          ollama
        ];

        shellAliases = lib.mkIf ((builtins.length (lib.attrNames cfg.connections)) > 1) (lib.concatMapAttrs
          (name: connection: {
            "ollama-${name}" = "OLLAMA_HOST=${connection.url} ollama";
          })
          cfg.connections);

        sessionVariables = {
          "OLLAMA_HOST" = defaultUrl;
          "OLLAMA_API_BASE" = lib.mkIf config.programs.aider.enable defaultUrl;
        };
      };

      programs = {
        aichat = {
          settings = {
            model = lib.mkDefault defaultConnModel;
          };
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

        aider.settings.model = lib.mkDefault "ollama_chat/${cfg.defaultModel}";

        neovim.codecompanion = {
          defaultAdapter = lib.mkDefault defaultConnModel;

          # TODO make this less awful lol
          adapters = lib.mergeAttrsList (
            lib.flatten (
              lib.attrValues (
                builtins.mapAttrs
                  (name: connection:
                    (map
                      (model:
                        let modelName = "${name}:${model}"; in {
                          "${modelName}" = {
                            adapter = "ollama";
                            model = model;
                            settings = {
                              name = "${modelName}";
                              formatted_name = "${modelName}";
                              schema = {
                                model = {
                                  default = model;
                                };
                              };
                              env = {
                                url = connection.url;
                              };
                              parameters = {
                                sync = true;
                              };
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
