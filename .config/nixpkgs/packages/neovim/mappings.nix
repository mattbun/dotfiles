{ ... }: {
  programs.neovim.extraLuaConfig = builtins.readFile ./lua/mappings.lua;
}
