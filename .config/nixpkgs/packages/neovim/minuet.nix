{ config
, lib
, pkgs
, ...
}:
{
  options.programs.neovim.minuet = {
    enable = lib.mkEnableOption "minuet";

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
    };

    extraLuaConfig = lib.mkOption {
      type = lib.types.str;
      description = "Additional configuration in lua before running `require('minuet').setup(settings)`.";
      default = "";
    };
  };

  config = let cfg = config.programs.neovim.minuet; in lib.mkIf cfg.enable {
    programs.neovim = {
      minuet.settings = {
        n_completions = lib.mkDefault 1;
        context_window = lib.mkDefault 512;
        request_timeout = 3;
      };

      # Minuet completion can only be triggered manually
      cmp.sources.manual = [
        { name = "minuet"; }
      ];

      blink = {
        sources = [ "minuet" ];
        settings.sources.providers.minuet = {
          name = "minuet";
          module = "minuet.blink";
          async = true;
          timeout_ms = cfg.settings.request_timeout * 1000;
          score_offset = 50; # Gives minuet higher priority among suggestions
        };
      };

      plugins = with pkgs.vimPlugins; [
        {
          plugin = minuet-ai-nvim;
          type = "lua";

          # Needs to be configured after blink.cmp
          config = /* lua */ lib.mkAfter ''
            local settings = vim.json.decode([[ ${builtins.toJSON cfg.settings} ]])

            ${cfg.extraLuaConfig}

            require("minuet").setup(settings)
          '';
        }
      ];
    };
  };
}
