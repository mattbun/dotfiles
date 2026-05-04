{ config
, lib
, pkgs
, ...
}:
{
  options.programs.neovim.blink = {
    enable = lib.mkEnableOption "neovim blink completion";

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
    };

    sources = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = let cfg = config.programs.neovim.blink; in lib.mkIf cfg.enable {
    programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        {
          plugin = blink-cmp;
          type = "lua";
          config =
            let
              settingsFile = pkgs.writeText "neovim-blink-settings.json" (builtins.toJSON cfg.settings);
            in
              /* lua */ ''
              local settings = vim.json.decode(vim.fn.readblob('${settingsFile}'))
              require('blink.cmp').setup(settings)
            '';
        }
      ];

      blink = {
        sources = [
          "lsp"
          "path"
          "buffer"
          "snippets"
        ];

        settings = {
          cmdline = {
            enabled = true;
            completion.list.selection = {
              preselect = false;
              auto_insert = true;
            };
            keymap = {
              # preset = "inherit"; # TODO disables cmdline completion?
              "<CR>" = [ "accept" "fallback" ];
              "<Up>" = [ "select_prev" "fallback" ];
              "<Down>" = [ "select_next" "fallback" ];
              "<Left>" = [ "cancel" "fallback" ];
              "<Right>" = [ "accept" "fallback" ];
            };
          };

          completion = {
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 0;
            };
            list = {
              selection = {
                preselect = false;
              };
            };
            menu = {
              draw = {
                columns = [ [ "label" "label_description" ] [ "kind" ] ];
              };
            };
          };

          keymap = {
            preset = "enter";
            "<C-e>" = [ "cancel" "fallback" ];
            "<A-c>" = [ "show" "show_documentation" "hide_documentation" ];
          };

          signature = {
            enabled = true;
          };

          sources.default = cfg.sources;
        };
      };
    };
  };
}
