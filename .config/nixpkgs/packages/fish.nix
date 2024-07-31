{ config
, pkgs
, nix-colors
, lib
, ...
}:
let
  nix-colors-lib = nix-colors.lib-contrib { inherit pkgs; };
in
lib.mkIf config.programs.fish.enable {
  programs = {
    fish = {
      interactiveShellInit = ''
        sh ${nix-colors-lib.shellThemeFromScheme { scheme = config.colorScheme; }}
      '';

      functions = {
        fish_greeting = "";
      };
    };

    starship.enable = true;
    z-lua.enable = true;
    direnv.enable = true;
  };
}
