{ lib
, config
, pkgs
, ...
}: {
  options.programs.neovim.copilot = with lib; {
    enable = lib.mkEnableOption "copilot";
  };

  config = let cfg = config.programs.neovim.copilot; in lib.mkIf cfg.enable {
    programs.neovim = {
      codecompanion.defaultAdapter = lib.mkDefault "copilot";

      cmp.sources.auto = lib.mkBefore [
        { name = "copilot"; }
      ];

      plugins = with pkgs.vimPlugins; [
        {
          plugin = copilot-cmp;
          type = "lua";
          config = /* lua */ ''
            require("copilot_cmp").setup()
          '';
        }

        {
          plugin = copilot-lua;
          type = "lua";
          config = /* lua */ ''
            require("copilot").setup({
              panel = {
                enabled = false,
              },
              suggestion = {
                enabled = false,
              },
            })
          '';
        }
      ];
    };
  };
}
