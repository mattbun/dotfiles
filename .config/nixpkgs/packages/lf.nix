{ pkgs, ... }: {
  home.packages = with pkgs; [
    chafa # image previews
    file # check mime types
  ];

  programs = {
    pistol.enable = true; # pistol is a previewer
    bat.enable = true; # ... but I like bat's syntax highlighting more
  };

  programs.lf = {
    settings = {
      sixel = true;
      mouse = true;
      hidecursorinactive = true;
    };

    keybindings = {
      U = "!du -sh $f";
    };

    commands = {
      q = "quit"; # makes `:q` work
      open = ''
        &{{
          case $(file --mime-type -Lb $f) in
            text/*) lf -remote "send $id \$$EDITOR \$fx";;
            *) for f in $fx; do $OPENER $f > /dev/null 2> /dev/null & done;;
          esac
        }}
      '';
    };

    # TODO tmux is having issues displaying sixels
    previewer = {
      source = pkgs.writeShellScript "pv.sh" ''
        #!/bin/sh

        case $(file --mime-type -Lb "$1") in
          text/*) bat --color always --pager never -n "$1";;
          image/*) chafa -s "$2x$3" --animate off --polite on "$1";;
          *) pistol "$1";;
        esac
      '';
    };
  };

  # https://github.com/gokcehan/lf/blob/master/etc/lfcd.fish
  programs.fish.functions = {
    lfcd = {
      wraps = "lf";
      description = "lf - Terminal file manager (changing directory on exit)";

      # `command` is needed in case `lfcd` is aliased to `lf`.
      # Quotes will cause `cd` to not change directory if `lf` prints nothing to stdout due to an error.
      body = "cd \"$(command lf -print-last-dir $argv)\"";
    };
  };
}
