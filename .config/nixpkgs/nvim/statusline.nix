{ lib
, ...
}: {
  programs.neovim.extraLuaConfig = lib.mkAfter (builtins.readFile ./statusline.lua);
}
