{ config
, lib
, ...
}:
{
  options.programs.aichat = {
    modelSettings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
    };

    clients = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          settings = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
          };

          models = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            default = { };
          };
        };
      });
      default = { };
    };
  };

  config = let cfg = config.programs.aichat; in lib.mkIf cfg.enable
    {
      programs.aichat.settings = {
        clients = lib.attrValues (
          lib.mapAttrs
            (clientName: client: (client.settings // {
              name = clientName;
              models = lib.attrValues (lib.mapAttrs
                (modelName: model: ({
                  name = modelName;
                } // model))
                client.models
              );
            }))
            cfg.clients
        );

        document_loaders = {
          "man" = "man $1";
        };
      };

      programs.fish = {
        interactiveShellInit = ''
          bind \ec _aichat_fish
        '';

        functions = {
          # https://github.com/sigoden/aichat/blob/main/scripts/shell-integration/integration.fish
          "_aichat_fish" = {
            body = /* fish */''
              set -l _old (commandline)
              if test -n $_old
                  echo -n "..."
                  commandline -f repaint
                  commandline (aichat -e $_old)
              end
            '';
          };
        };
      };
    };
}
