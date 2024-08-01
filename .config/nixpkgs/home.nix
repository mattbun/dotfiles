{ config
, pkgs
, nix-colors
, username
, homeDirectory
, lib
, ...
}:
let
  gitName = "Matt Rathbun";
  gitEmail = "5514636+mattbun@users.noreply.github.com";
in
{
  imports = [
    nix-colors.homeManagerModule
    ./system.nix
    ./colors/fzf.nix
    ./colors/k9s.nix
    ./colors/tmux.nix
    ./colors/waybar.nix
    ./lib
    ./packages
  ];

  options = with lib; {
    colorScheme.accentColor = mkOption {
      type = types.str;
      description = "Accent color to use in a few places";
      default = config.colorScheme.palette.base0E;
    };
  };

  config = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = username;
    home.homeDirectory = homeDirectory;

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "22.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      # base
      bat
      curl
      delta
      fd
      git
      git-open
      glow
      gnused
      gnutar
      gzip
      jq
      ripgrep
      tmux
      unzip
    ];

    colorScheme = nix-colors.colorSchemes.helios;
    # colorScheme = {
    #   slug = "...";
    #   name = "...";
    #   colors = {
    #     base00 = "000000"; # ----
    #     base01 = "000000"; # ---
    #     base02 = "000000"; # --
    #     base03 = "000000"; # -
    #     base04 = "000000"; # +
    #     base05 = "000000"; # ++
    #     base06 = "000000"; # +++
    #     base07 = "000000"; # ++++
    #     base08 = "000000"; # red
    #     base09 = "000000"; # orange
    #     base0A = "000000"; # yellow
    #     base0B = "000000"; # green
    #     base0C = "000000"; # aqua/cyan
    #     base0D = "000000"; # blue
    #     base0E = "000000"; # purple
    #     base0F = "000000"; # brown
    #   };
    # };

    nix = {
      enable = true;
      package = pkgs.nix;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

    # These options apply to ripgrep and fd (which are used in fzf and neovim)
    # Implemented in ./lib/search.nix
    bun.search = {
      includeHidden = true;
      includeGitignored = false;
      ignoredPaths = [
        ".git"
      ];
      includedPaths = [
        ".env"
      ];
    };

    programs.ripgrep = {
      enable = true;
      arguments = [
        # "Searches case insensitively if the pattern is all lowercase. Search case sensitively otherwise."
        "--smart-case"
      ];
    };

    programs.git = {
      enable = true;

      userName = gitName;
      userEmail = gitEmail;

      aliases = {
        s = "status";
        o = "open";
        last = "log -1 HEAD";
        main-branch = "!git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4";
        com = "!f(){ git checkout $(git main-branch) $@;}; f";
      };

      delta = {
        enable = true;
        options = {
          navigate = true; # use n and N to move between diff sections
          line-numbers = true;
          features = "line-numbers";
          dark = true;
          syntax-theme = "none"; # disabled because it can be hard to read colors on colors
          file-style = "white";
          file-decoration-style = "none";
          file-added-label = "[+]";
          file-copied-label = "[<>]";
          file-modified-label = "[~]";
          file-removed-label = "[-]";
          file-renamed-label = "[->]";
          hunk-header-decoration-style = ''blue box ul'';
          plus-style = "green black";
          plus-emph-style = "black green";
          minus-style = "red black";
          minus-emph-style = "black red";
          line-numbers-minus-style = "red";
          line-numbers-plus-style = "green";
          whitespace-error-style = "orange bold";
          blame-palette = ''#${config.colorScheme.palette.base00} #${config.colorScheme.palette.base01} #${config.colorScheme.palette.base02}'';
          merge-conflict-begin-symbol = "~";
          merge-conflict-end-symbol = "~";
          merge-conflict-ours-diff-header-style = "yellow bold";
          merge-conflict-ours-diff-header-decoration-style = ''"#${config.colorScheme.palette.base01}" box'';
          merge-conflict-theirs-diff-header-style = "yellow bold";
          merge-conflict-theirs-diff-header-decoration-style = ''"#${config.colorScheme.palette.base01}" box'';
        };
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

    programs.tmux = {
      enable = true;
      escapeTime = 0;
      historyLimit = 50000;

      plugins = with pkgs; [
        tmuxPlugins.logging
      ];

      extraConfig = ''
        # No status bar!
        set -g status off

        # Mouse mode!
        set -g mouse on

        # True Color!
        # https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6
        set -g default-terminal "screen-256color"
        set -ag terminal-overrides ",$TERM:RGB"

        # Use fish!
        set -g default-command "${pkgs.fish}/bin/fish"

        # Name windows after the current directory!
        set-option -g status-interval 5
        set-option -g automatic-rename on
        set-option -g automatic-rename-format '#{b:pane_current_path}'

        # Set terminal title!
        set-option -g set-titles on
        set-option -g set-titles-string "#{user}@#{host_short}[#{session_name},#I] #{?#{==:$HOME,#{pane_current_path}},~,#{b:pane_current_path}} #{pane_current_command}"

        # i3-style bindings!
        set -g base-index 1
        bind-key -n M-1 select-window -t :1
        bind-key -n M-2 select-window -t :2
        bind-key -n M-3 select-window -t :3
        bind-key -n M-4 select-window -t :4
        bind-key -n M-5 select-window -t :5
        bind-key -n M-6 select-window -t :6
        bind-key -n M-7 select-window -t :7
        bind-key -n M-8 select-window -t :8
        bind-key -n M-9 select-window -t :9
        bind-key -n M-0 select-window -t :10
        bind-key -n M-` choose-tree -Zw

        bind-key -n M-! join-pane -t :1
        bind-key -n M-@ join-pane -t :2
        bind-key -n M-# join-pane -t :3
        bind-key -n M-$ join-pane -t :4
        bind-key -n M-% join-pane -t :5
        bind-key -n M-^ join-pane -t :6
        bind-key -n M-& join-pane -t :7
        bind-key -n M-* join-pane -t :8
        bind-key -n M-( join-pane -t :9
        bind-key -n M-) join-pane -t :10

        bind-key -n M-Up select-pane -U
        bind-key -n M-Down select-pane -D
        bind-key -n M-Left select-pane -L
        bind-key -n M-Right select-pane -R

        bind-key -n M-S-Up swap-pane -s "{up-of}"
        bind-key -n M-S-Down swap-pane -s "{down-of}"
        bind-key -n M-S-Left swap-pane -s "{left-of}"
        bind-key -n M-S-Right swap-pane -s "{right-of}"

        bind-key -n M-z resize-pane -Z
        bind-key -n M-f resize-pane -Z

        bind-key -n M-c new-window

        bind-key -n M-Enter split-window -h -c "#{pane_current_path}"
        bind-key -n M-v split-window -h -c "#{pane_current_path}"
        bind-key -n M-x split-window -v -c "#{pane_current_path}"

        bind-key -n M-V split-window -h -l 33% -c "#{pane_current_path}"
        bind-key -n M-X split-window -v -l 33% -c "#{pane_current_path}"

        bind-key -n M-: command-prompt
      '';
    };

    home.shellAliases = {
      # Make aliases work with sudo
      sudo = "sudo ";

      # neovim > vim
      vim = "nvim";
      vimdiff = "nvim -d";

      # misspellings
      gti = "git";
      tit = "echo 😱 && git";

      # git aliases, inspired by oh-my-zsh/git
      gcm = "git checkout $(git main-branch)";
      gdca = "git diff --cached";
      gpsup = "git push --set-upstream origin $(git branch --show-current)";

      # easier to remember commands that search everything
      fda = "fd --no-ignore --hidden";
      rga = "rg --no-ignore --hidden";
    };

    # Implemented in ./lib/scripts.nix
    bun.shellScripts = {
      nxx = ''
        # Creates a nix-shell with the first argument as package and command to run.
        # Example: `nxx htop`
        nix-shell -p $1 --command "$1 ''${@:2}"
      '';

      nfx = ''
        # Creates a nix shell with the first argument as package and command to run.
        # Example: `nfx htop`
        nix shell nixpkgs#$1 --command $1 ''${@:2}
      '';

      git-pr = ''
        ${if pkgs.stdenv.isDarwin then "open" else "xdg-open"} "$(git-open --print | sed -e 's|/tree/|/pull/new/|')"
      '';
    };

    # This works around some logic that tries to prevent reloading env vars
    home.sessionVariablesExtra = ''
      unset __HM_SESS_VARS_SOURCED
    '';
  };
}
