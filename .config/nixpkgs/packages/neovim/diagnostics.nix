{ ... }: {
  programs.neovim.extraLuaConfig = builtins.readFile ./lua/diagnostics.lua;
}
