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

    connections = lib.mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          url = lib.mkOption {
            type = types.str;
            default = "http://localhost:11434";
          };

          models = lib.mkOption {
            type = types.listOf types.str;
            default = [ ];
          };
        };
      });
    };
  };

  config = let cfg = config.programs.ollama; in lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        ollama
      ];

      shellAliases = (lib.concatMapAttrs
        (name: connection: {
          "ollama-${name}" = "OLLAMA_HOST=${connection.url} ollama";
        })
        cfg.connections);
    };

    programs = {
      aichat.settings = {
        model = lib.mkDefault config.programs.ollama.defaultModel;

        clients = lib.mapAttrsToList
          (name: connection: {
            type = "openai-compatible";
            name = name;
            api_base = "${connection.url}/v1";

            # TODO this doesn't give any options for configuring each model
            models = map (x: { name = x; }) connection.models;
          })
          cfg.connections;
      };

      neovim.codecompanion = {
        strategies = {
          chat = {
            adapter = lib.mkDefault cfg.defaultModel;
          };
          inline = {
            adapter = lib.mkDefault cfg.defaultModel;
          };
          cmd = {
            adapter = lib.mkDefault cfg.defaultModel;
          };
        };

        # TODO make this less awful lol
        adapters = lib.mergeAttrsList (
          lib.flatten (
            lib.attrValues (
              builtins.mapAttrs
                (name: connection:
                  (map
                    (model: {
                      "${name}:${model}" = {
                        adapter = "ollama";
                        model = model;
                        settings = {
                          name = "Ollama (${name}:${model})";
                          model = model;
                          env = {
                            url = connection.url;
                          };
                          parameters = {
                            sync = true;
                          };
                        };
                      };
                    })
                    connection.models
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
