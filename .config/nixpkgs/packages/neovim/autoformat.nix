{ ... }: {
  programs.neovim.initLua = builtins.readFile ./lua/autoformat.lua;
}
