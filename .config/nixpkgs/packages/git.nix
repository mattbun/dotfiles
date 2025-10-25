{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    git-open
  ];

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
