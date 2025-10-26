{ lib, pkgs, ... }: {
  home = {
    packages = with pkgs; [
      git-open
    ];

    shellAliases = {
      # misspellings
      gti = "git";
      tit = "echo 😱 && git";

      # git aliases, inspired by oh-my-zsh/git
      gcm = "git checkout $(git main-branch)";
      gdca = "git diff --cached";
      gpsup = "git push --set-upstream origin $(git branch --show-current)";
    };
  };

  programs.git = {
    enable = lib.mkDefault true;
    settings = {
      alias = {
        s = "status";
        o = "open";
        last = "log -1 HEAD";
        main-branch = "!git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4";
        com = "!f(){ git checkout $(git main-branch) $@;}; f";
      };

      init = {
        defaultBranch = "main";
      };

      diff = {
        tool = "nvimdiff";
      };

      merge = {
        tool = "nvimdiff";
      };

      mergetool = {
        "vimdiff" = {
          path = "${pkgs.neovim}/bin/nvim";
        };
      };

      fetch = {
        prune = true;
      };

      push = {
        autoSetupRemote = true;
      };
    };
  };
}
