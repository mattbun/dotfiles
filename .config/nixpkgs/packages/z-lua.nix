{ config
, lib
, ...
}:
lib.mkIf config.programs.z-lua.enable {
  home.sessionVariables = {
    _ZL_HYPHEN = 1; # Tell z.lua to treat hyphens like normal characters and not part of a regex
  };
}
