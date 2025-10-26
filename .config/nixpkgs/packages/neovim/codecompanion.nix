{ config
, lib
, pkgs
, ...
}:
{
  options = {
    programs.neovim.codecompanion = {
      enable = lib.mkEnableOption "codecompanion";

      defaultAdapter = lib.mkOption {
        type = lib.types.str;
        default = "copilot";
      };

      strategies = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = { };
      };

      adapters = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            adapter = lib.mkOption {
              type = lib.types.str;
            };

            model = lib.mkOption {
              type = lib.types.str;
            };

            settings = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
            };
          };
        });
        default = { };
      };
    };
  };

  config = let cfg = config.programs.neovim.codecompanion; in lib.mkIf cfg.enable {
    programs.neovim = {
      codecompanion = {
        strategies = {
          chat = {
            adapter = lib.mkDefault cfg.defaultAdapter;
            keymaps = {
              # remap clear from 'gx' to 'gc' so 'gx' can opens links in chats
              clear = {
                modes = {
                  n = "gc";
                };
              };
              codeblock = {
                # remap codeblock from 'gc' to 'gC' (since clear is now using 'gc')
                modes = {
                  n = "gC";
                };
              };
            };
          };
          inline = {
            adapter = lib.mkDefault cfg.defaultAdapter;
          };
          cmd = {
            adapter = lib.mkDefault cfg.defaultAdapter;
          };
        };
      };

      plugins = with pkgs.vimPlugins; [
        {
          plugin = codecompanion-nvim;
          type = "lua";
          config = /* lua */ ''
            local strategies = vim.json.decode([[${builtins.toJSON config.programs.neovim.codecompanion.strategies}]])
            local adapters = {
              acp = {
                opts = {
                  show_defaults = false,
                },
              },
              http = {
                opts = {
                  show_defaults = false,
                },
                ${lib.strings.concatLines (lib.mapAttrsToList (name: adapter: /* lua */ ''
                  ["${name}"] = function()
                    return require("codecompanion.adapters").extend("${adapter.adapter}", vim.json.decode([[${builtins.toJSON adapter.settings}]]))
                  end,
                '') config.programs.neovim.codecompanion.adapters)}
              }
            }

            require("codecompanion").setup({
              strategies = strategies,
              adapters = adapters,
              -- TODO might be nice to expose additional settings in nix
            })
          '';
        }
      ];
    };
  };
}
