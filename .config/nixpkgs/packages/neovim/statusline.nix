{ ... }: {
  programs.neovim.initLua = builtins.readFile ./lua/statusline.lua;
}
