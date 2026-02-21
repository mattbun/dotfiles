{ ... }: {
  programs.neovim.initLua = builtins.readFile ./lua/mappings.lua;
}
