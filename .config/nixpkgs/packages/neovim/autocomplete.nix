{ ... }: {
  programs.neovim.extraLuaConfig = builtins.readFile ./lua/autocomplete.lua;
}
