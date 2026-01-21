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
      };

      # Minuet completion can only be triggered manually
      cmp.sources.manual = [
        { name = "minuet"; }
      ];

      plugins = with pkgs.vimPlugins; [
        {
          plugin = minuet-ai-nvim;
          type = "lua";
          config = /* lua */ ''
            local settings = vim.json.decode([[ ${builtins.toJSON cfg.settings} ]])

            ${cfg.extraLuaConfig}

            require("minuet").setup(settings)
          '';
        }
      ];
    };
  };
}
