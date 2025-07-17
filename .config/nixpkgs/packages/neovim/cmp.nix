{ config
, lib
, pkgs
, ...
}:
{
  options.programs.neovim.cmp = {
    enable = lib.mkEnableOption "cmp";

    sources = {
      auto = lib.mkOption {
        type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
        default = [ ];
      };

      manual = lib.mkOption {
        type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
      };
    };
  };

  config = let cfg = config.programs.neovim.cmp; in lib.mkIf cfg.enable {
    programs.neovim = {
      cmp = {
        sources = {
          auto = [
            { name = "nvim_lsp"; }
            { name = "nvim_lsp_signature_help"; }
            { name = "vsnip"; }
            { name = "calc"; }
            { name = "path"; }
            { name = "emoji"; insert = true; }
            { name = "buffer"; }
          ];

          manual = [ ];
        };
      };

      plugins = with pkgs.vimPlugins; [
        cmp-buffer
        cmp-calc
        cmp-emoji
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
        cmp-path
        cmp-vsnip

        {
          plugin = nvim-cmp;
          type = "lua";
          config = lib.concatLines [
            /* lua */
            ''
              local sources = {
                auto = vim.json.decode([[ ${builtins.toJSON cfg.sources.auto} ]]),
                manual = vim.json.decode([[ ${builtins.toJSON cfg.sources.manual} ]]),
                all = vim.json.decode([[ ${builtins.toJSON (cfg.sources.manual ++ cfg.sources.auto)} ]]),
              }
            ''
            (builtins.readFile ./lua/cmp.lua)
          ];
        }
      ];
    };
  };
}
