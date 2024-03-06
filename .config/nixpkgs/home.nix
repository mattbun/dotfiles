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

  nix-colors-lib = nix-colors.lib-contrib { inherit pkgs; };
in
{
  imports = [
    nix-colors.homeManagerModule
    ./system.nix
    ./colors/alacritty.nix
    ./colors/fzf.nix
    ./colors/k9s.nix
    ./colors/rofi.nix
    ./colors/tmux.nix
    ./colors/vim.nix
    ./colors/waybar.nix
    ./lib/path.nix
    ./lib/scripts.nix
    ./lib/search.nix
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
      nil
      nixpkgs-fmt
      ripgrep
      stylua
      sumneko-lua-language-server
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

    programs.bat = {
      enable = true;
      config = {
        theme = "base16";
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
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

    programs.fzf.enable = true;

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
          features = "line-numbers decorations";
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

    programs.neovim = {
      enable = true;

      # The colorscheme needs to be loaded before lualine is started
      extraLuaConfig = ''
        vim.cmd('runtime colorscheme.vim')
        vim.cmd('source ~/.vimrc')

        require("lsp")
        require("mappings")

        -- show substitutions
        vim.o.inccommand = "nosplit"
      '';

      plugins = with pkgs.vimPlugins; [
        cmp-buffer
        cmp-calc
        cmp-emoji
        cmp-nvim-lsp
        cmp-path
        cmp-vsnip
        friendly-snippets
        mason-lspconfig-nvim
        mkdir-nvim
        nvim-lspconfig
        plenary-nvim
        telescope-fzf-native-nvim
        vim-eunuch
        vim-graphql
        vim-nix
        vim-terraform
        vim-vsnip
        vim-vsnip-integ

        {
          plugin = gitlinker-nvim;
          type = "lua";
          config = builtins.readFile ./nvim/gitlinker.lua;
        }
        {
          plugin = glow-nvim;
          type = "lua";
          config = "require('glow').setup()";
        }
        {
          plugin = gitsigns-nvim;
          type = "lua";
          config = builtins.readFile ./nvim/gitsigns.lua;
        }
        {
          plugin = indent-blankline-nvim;
          type = "lua";
          config = builtins.readFile ./nvim/indent-blankline.lua;
        }
        {
          plugin = kommentary;
          type = "lua";
          config = builtins.readFile ./nvim/kommentary.lua;
        }
        {
          plugin = lualine-nvim;
          type = "lua";
          config = builtins.readFile ./nvim/lualine.lua;
        }
        {
          plugin = mason-nvim;
          type = "lua";
          config = builtins.readFile ./nvim/mason.lua;
        }
        {
          plugin = null-ls-nvim;
          type = "lua";
          config = builtins.readFile ./nvim/null-ls.lua;
        }
        {
          plugin = nvim-cmp;
          type = "lua";
          config = builtins.readFile ./nvim/cmp.lua;
        }
        {
          plugin = nvim-tree-lua;
          type = "lua";
          config = builtins.readFile ./nvim/nvim-tree.lua;
        }
        {
          plugin = switch-vim;
          type = "lua";
          config = builtins.readFile ./nvim/switch.lua;
        }
        {
          plugin = telescope-nvim;
          type = "lua";
          config = builtins.readFile ./nvim/telescope.lua;
        }
      ];
    };

    programs.tealdeer = {
      enable = true;
      settings = {
        updates = {
          auto_update = true;
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

      nixify = ''
        if [ ! -e ./.envrc ]; then
          echo "use nix" > .envrc
          direnv allow
        fi

        if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
          cat > shell.nix <<'EOF'
        with import <nixpkgs> {};
        mkShell {
          nativeBuildInputs = [
            bashInteractive
          ];
        }
        EOF
          ''${EDITOR:-vim} shell.nix
        fi
      '';

      flakify = ''
        if [ ! -d .git ]; then
          git init
        fi

        if [ ! -e flake.nix ]; then
          nix flake new -t github:nix-community/nix-direnv .
          direnv allow
        elif [ ! -e .envrc ]; then
          echo "use flake" > .envrc
          direnv allow
        fi

        ''${EDITOR:-vim} flake.nix
      '';

      git-pr = ''
        ${if pkgs.stdenv.isDarwin then "open" else "xdg-open"} "$(git-open --print | sed -e 's|/tree/|/pull/new/|')"
      '';
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      DIRENV_LOG_FORMAT = ""; # shh direnv
      _ZL_HYPHEN = 1; # Tell z.lua to treat hyphens like normal characters and not part of a regex
    };

    # This works around some logic that tries to prevent reloading env vars
    home.sessionVariablesExtra = ''
      unset __HM_SESS_VARS_SOURCED
    '';

    # z
    programs.z-lua = {
      enable = true;
    };

    # asdf clone
    programs.mise = {
      enable = true;
    };

    programs.bash = {
      enable = true;
    };

    programs.fish = {
      enable = true;
      shellAbbrs = { };

      interactiveShellInit = ''
        sh ${nix-colors-lib.shellThemeFromScheme { scheme = config.colorScheme; }}
      '';

      functions = {
        fish_greeting = "";
      };

      plugins = [ ];
    };

    programs.starship = {
      enable = true;
      enableBashIntegration = false;
      settings = {
        add_newline = false;
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_state"
          "$git_status"
          "$cmd_duration"
          "$status"
          "$character"
        ];
        username = {
          format = "[$user]($style)";
          style_user = "bright-black";
          style_root = "red";
        };
        hostname = {
          format = "[@$hostname]($style) ";
          style = "bright-black";
        };
        directory = {
          style = "blue";
          read_only = " [RO]";
        };
        git_branch = {
          format = "[$branch]($style) ";
          style = "bright-black";
        };
        git_status = {
          format = "[$modified$untracked](bright-black)[$deleted](dimmed green)[$staged$renamed](green)[$conflicted](yellow)[$ahead_behind](cyan)";

          staged = "+$count ";
          deleted = "×$count ";
          renamed = "~$count ";

          conflicted = "=$count ";
          modified = "!$count ";
          untracked = "?$count ";

          ahead = "⇡$count ";
          behind = "⇣$count ";
          diverged = "$ahead_count⇕$behind_count ";
        };
        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };
        status = {
          format = "[$common_meaning$signal_name\\($status\\)]($style) ";
          pipestatus_format = "$pipestatus|$common_meaning$signal_name\\($status\\)]($style) ";
          disabled = false;
        };
        character = {
          success_symbol = "\\$";
          error_symbol = "[\\$](red)";
        };
      };
    };
  };
}
