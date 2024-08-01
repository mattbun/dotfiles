{ pkgs, ... }: {
  programs.git = {
    userName = "Matt Rathbun";
    userEmail = "5514636+mattbun@users.noreply.github.com";

    aliases = {
      s = "status";
      o = "open";
      last = "log -1 HEAD";
      main-branch = "!git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4";
      com = "!f(){ git checkout $(git main-branch) $@;}; f";
    };

    extraConfig = {
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
