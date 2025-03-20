{ config
, pkgs
, lib
, ...
}:
lib.mkIf config.programs.fish.enable {
  programs = {
    fish = {
      interactiveShellInit = ''
        # This function needs to be run first for the onVariable to work
        git_auto_fetch
      '';

      shellAbbrs = {
        "\"**\"" = lib.mkIf config.programs.fzf.enable {
          function = "fzf_picker";
          position = "anywhere";
        };
      };

      functions = {
        fish_greeting = "";

        # Run `git fetch` in the background when entering git repository directories.
        git_auto_fetch = {
          onVariable = "PWD";
          body = ''
            if test -d ./.git
              git fetch &> /dev/null &
            end
          '';
        };

        fzf_picker = lib.mkIf config.programs.fzf.enable "${pkgs.fzf}/bin/fzf";
      };
    };

    starship.enable = true;
    z-lua.enable = true;
    direnv.enable = true;
  };
}
