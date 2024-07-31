{ config
, lib
, ...
}:
lib.mkIf config.programs.bash.enable {
  programs = {
    direnv.enable = true;
    z-lua.enable = true;
  };
}
