{ ... }: {
  programs.neovim.extraLuaConfig = builtins.readFile ./lua/statusline.lua;
}
