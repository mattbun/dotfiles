{ ... }: {
  programs.neovim.extraLuaConfig = builtins.readFile ./lua/autoformat.lua;
}
