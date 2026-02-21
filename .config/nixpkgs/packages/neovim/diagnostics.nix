{ ... }: {
  programs.neovim.initLua = builtins.readFile ./lua/diagnostics.lua;
}
