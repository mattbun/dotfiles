{ lib
, ...
}: {
  programs.neovim.extraLuaConfig = lib.mkAfter (builtins.readFile ./lua/statusline.lua);
}
