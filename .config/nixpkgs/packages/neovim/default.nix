{ pkgs, ... }:
{
  imports = [
    ./autoformat.nix
    ./colors.nix
    ./statusline.nix
  ];

  programs.neovim = {
    enable = true;

    extraLuaConfig = ''
      vim.cmd('runtime colorscheme.vim')
      vim.cmd('source ~/.vimrc')

      -- set a global border style variable
      vim.g.border_style = "rounded"

      require("lsp")
      require("mappings")

      -- show substitutions
      vim.o.inccommand = "nosplit"
    '';

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

      {
        plugin = gitlinker-nvim;
        type = "lua";
        config = builtins.readFile ./lua/gitlinker.lua;
      }
      {
        plugin = glow-nvim;
        type = "lua";
        config = "require('glow').setup()";
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
        plugin = null-ls-nvim;
        type = "lua";
        config = builtins.readFile ./lua/null-ls.lua;
      }
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = "require('nvim-autopairs').setup{}";
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
