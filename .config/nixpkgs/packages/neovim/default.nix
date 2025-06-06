{ config
, lib
, pkgs
, ...
}:
{
  imports = [
    ./autoformat.nix
    ./colors.nix
    ./diagnostics.nix
    ./mappings.nix
    ./statusline.nix
  ];

  home.packages = lib.mkIf config.programs.neovim.enable (with pkgs; [
    nil
    nixpkgs-fmt
    sumneko-lua-language-server
  ]);

  programs.stylua.enable = true;

  programs.neovim = {
    extraLuaConfig = lib.mkBefore (builtins.readFile ./lua/init.lua);

    plugins = with pkgs.vimPlugins; [
      cmp-buffer
      cmp-calc
      cmp-emoji
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-path
      cmp-vsnip
      friendly-snippets
      mason-lspconfig-nvim
      mkdir-nvim
      nvim-treesitter.withAllGrammars
      plenary-nvim
      telescope-fzf-native-nvim
      vim-eunuch
      vim-graphql
      vim-nix
      vim-terraform
      vim-vsnip
      vim-vsnip-integ
      which-key-nvim # configured in mappings.lua

      {
        plugin = dressing-nvim;
        type = "lua";
        config = ''
          require('dressing').setup({
            input = {
              border = vim.g.border_style,
            },
          })
        '';
      }
      {
        plugin = gitlinker-nvim;
        type = "lua";
        config = builtins.readFile ./lua/gitlinker.lua;
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = builtins.readFile ./lua/gitsigns.lua;
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = builtins.readFile ./lua/indent-blankline.lua;
      }
      {
        plugin = kommentary;
        type = "lua";
        config = builtins.readFile ./lua/kommentary.lua;
      }
      {
        plugin = mason-nvim;
        type = "lua";
        config = builtins.readFile ./lua/mason.lua;
      }
      {
        plugin = none-ls-nvim;
        type = "lua";
        config = builtins.readFile ./lua/null-ls.lua;
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ./lua/cmp.lua;
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = "require('lspconfig.ui.windows').default_options.border = vim.g.border_style";
      }
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = builtins.readFile ./lua/nvim-tree.lua;
      }
      {
        plugin = switch-vim;
        type = "lua";
        config = builtins.readFile ./lua/switch.lua;
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./lua/telescope.lua;
      }
    ];
  };
}
