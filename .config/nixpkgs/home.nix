{ config
, pkgs
, nix-colors
, username
, homeDirectory
, ...
}:
let
  gitName = "Matt Rathbun";
  gitEmail = "5514636+mattbun@users.noreply.github.com";

  packageSets = [
    # "docker"
    # "graphical"
    # "kubernetes"
  ];

  additionalPackages = with pkgs; [
    # mosh
  ];

  additionalAliases = {
    # wow = "echo neat";
  };

  additionalEnvVars = {
    # COOL = "stuff";
  };

  # These will be added to the PATH environment variable
  additionalPaths = [
    # "${homeDirectory}/.bin"
  ];

  nix-colors-lib = nix-colors.lib-contrib { inherit pkgs; };
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  home.packages = import ./packages.nix {
    pkgs = pkgs;
    packageSets = packageSets;
    additionalPackages = additionalPackages;
  };

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

  imports = [
    nix-colors.homeManagerModule
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    defaultOptions = [
      "--color=bg+:#${config.colorScheme.colors.base01}"
      "--color=bg:#${config.colorScheme.colors.base00}"
      "--color=spinner:#${config.colorScheme.colors.base0C}"
      "--color=hl:#${config.colorScheme.colors.base0D}"
      "--color=fg:#${config.colorScheme.colors.base04}"
      "--color=header:#${config.colorScheme.colors.base0D}"
      "--color=info:#${config.colorScheme.colors.base0A}"
      "--color=pointer:#${config.colorScheme.colors.base0C}"
      "--color=marker:#${config.colorScheme.colors.base0C}"
      "--color=fg+:#${config.colorScheme.colors.base06}"
      "--color=prompt:#${config.colorScheme.colors.base0A}"
      "--color=hl+:#${config.colorScheme.colors.base0D}"
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
    };
  };

  xdg.configFile."nvim/init.lua".text = ''
    vim.cmd('source ~/.vimrc')
    vim.cmd('runtime colorscheme.vim')

    require("lsp")
    require("plugins")
    require("mappings")

    -- show substitutions
    vim.o.inccommand = "nosplit"
  '';

  xdg.configFile."nvim/colorscheme.vim".text = import ./colors/vim.nix {
    colorScheme = config.colorScheme;
  };

  programs.neovim = {
    enable = true;
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

    extraConfig = ''
      # No status bar!
      set -g status off

      # Mouse mode!
      set -g mouse on

      # True Color!
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",xterm-256color*:Tc"

      # Use zsh!
      set -g default-command "${pkgs.zsh}/bin/zsh"

      # Name windows after the current directory!
      set-option -g status-interval 5
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'

      # Colors!
      # default statusbar colors
      set-option -g status-style "fg=#${config.colorScheme.colors.base04},bg=#${config.colorScheme.colors.base01}"

      # default window title colors
      set-window-option -g window-status-style "fg=#${config.colorScheme.colors.base04},bg=default"

      # active window title colors
      set-window-option -g window-status-current-style "fg=#${config.colorScheme.colors.base0A},bg=default"

      # pane border
      set-option -g pane-border-style "fg=#${config.colorScheme.colors.base01}"
      set-option -g pane-active-border-style "fg=#${config.colorScheme.colors.base02}"

      # message text
      set-option -g message-style "fg=#${config.colorScheme.colors.base05},bg=#${config.colorScheme.colors.base01}"

      # pane number display
      set-option -g display-panes-active-colour "#${config.colorScheme.colors.base0B}"
      set-option -g display-panes-colour "#${config.colorScheme.colors.base0A}"

      # clock
      set-window-option -g clock-mode-colour "#${config.colorScheme.colors.base0B}"

      # copy mode highligh
      set-window-option -g mode-style "fg=#${config.colorScheme.colors.base04},bg=#${config.colorScheme.colors.base02}"

      # bell
      set-window-option -g window-status-bell-style "fg=#${config.colorScheme.colors.base01},bg=#${config.colorScheme.colors.base08}"
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

    # git aliases, some of these are in oh-my-zsh/git but good to get them in bash too
    gcm = "git checkout $(git main-branch)";
    gdca = "git diff --cached";
    gpsup = "git push --set-upstream origin $(git_current_branch)";
  } // additionalAliases;

  home.sessionVariables = {
    EDITOR = "nvim";
    DIRENV_LOG_FORMAT = ""; # shh direnv
    FZF_DEFAULT_COMMAND = "rg --files --hidden --smart-case";
    RIPGREP_CONFIG_PATH = "~/.ripgreprc";

    # Generally you don't want to reference env vars like this in home-manager
    PATH = "$PATH" + (if ((builtins.length additionalPaths) > 0) then ":" + (builtins.concatStringsSep ":" additionalPaths) else "");
  } // additionalEnvVars;

  # This works around some logic that tries to prevent reloading env vars
  home.sessionVariablesExtra = ''
    unset __HM_SESS_VARS_SOURCED
  '';

  programs.bash = {
    enable = true;
    initExtra = ''
      source ~/.shrc

      # Set up shell color scheme
      sh ${nix-colors-lib.shellThemeFromScheme { scheme = config.colorScheme; }}
    '';
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    dotDir = ".config/zsh";

    # TODO can `.shrc` be converted to this file?
    initExtra = ''
      # Common shell settings to share with bash
      source ~/.shrc

      # Set up shell color scheme
      sh ${nix-colors-lib.shellThemeFromScheme { scheme = config.colorScheme; }}

      # Set up powerlevel10k, this should always come last
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    zplug = {
      enable = true;
      plugins = [
        {
          name = "plugins/asdf";
          tags = [ "from:oh-my-zsh" ];
        }
        {
          name = "plugins/git";
          tags = [ "from:oh-my-zsh" ];
        }
        {
          name = "plugins/git-auto-fetch";
          tags = [ "from:oh-my-zsh" ];
        }
        {
          name = "paulirish/git-open";
          tags = [ "as:plugin" ];
        }
        {
          name = "romkatv/powerlevel10k";
          tags = [ "as:theme" "depth:1" ];
        }
        {
          name = "agkozak/zsh-z";
        }
      ];
    };
  };

  programs.alacritty = {
    enable = builtins.elem "graphical" packageSets;
    settings = {
      font = {
        normal = {
          family = "Hack";
        };
        size = 13.0;
      };
      selection = {
        save_to_clipboard = true;
      };
      shell = {
        program = "${pkgs.tmux}/bin/tmux";
      };
      colors = {
        # Default color;
        primary = {
          background = "0x${config.colorScheme.colors.base00}";
          foreground = "0x${config.colorScheme.colors.base05}";
        };

        # Colors the cursor will use if `custom_cursor_colors` is tru";
        cursor = {
          text = "0x${config.colorScheme.colors.base00}";
          cursor = "0x${config.colorScheme.colors.base05}";
        };

        # Normal color";
        normal = {
          black = "0x${config.colorScheme.colors.base00}";
          red = "0x${config.colorScheme.colors.base08}";
          green = "0x${config.colorScheme.colors.base0B}";
          yellow = "0x${config.colorScheme.colors.base0A}";
          blue = "0x${config.colorScheme.colors.base0D}";
          magenta = "0x${config.colorScheme.colors.base0E}";
          cyan = "0x${config.colorScheme.colors.base0C}";
          white = "0x${config.colorScheme.colors.base05}";
        };

        # Bright color";
        bright = {
          black = "0x${config.colorScheme.colors.base03}";
          red = "0x${config.colorScheme.colors.base09}";
          green = "0x${config.colorScheme.colors.base01}";
          yellow = "0x${config.colorScheme.colors.base02}";
          blue = "0x${config.colorScheme.colors.base04}";
          magenta = "0x${config.colorScheme.colors.base06}";
          cyan = "0x${config.colorScheme.colors.base0F}";
          white = "0x${config.colorScheme.colors.base07}";
        };
      };

      draw_bold_text_with_bright_colors = false;
    };
  };

  programs.k9s = {
    enable = builtins.elem "kubernetes" packageSets;
    skin = {
      k9s =
        let
          default = "default";
          foreground = "#${config.colorScheme.colors.base05}";
          background = "#${config.colorScheme.colors.base00}";
          comment = "#${config.colorScheme.colors.base03}";
          current_line = "#${config.colorScheme.colors.base01}";
          selection = "#${config.colorScheme.colors.base02}";

          red = "#${config.colorScheme.colors.base08}";
          orange = "#${config.colorScheme.colors.base09}";
          yellow = "#${config.colorScheme.colors.base0A}";
          green = "#${config.colorScheme.colors.base0B}";
          cyan = "#${config.colorScheme.colors.base0C}";
          blue = "#${config.colorScheme.colors.base0D}";
          magenta = "#${config.colorScheme.colors.base0E}";
        in
        {
          # General K9s styles
          body = {
            fgColor = foreground;
            bgColor = default;
            logoColor = magenta;
          };
          # Command prompt styles
          prompt = {
            fgColor = foreground;
            bgColor = background;
            suggestColor = orange;
          };
          # ClusterInfoView styles.
          info = {
            fgColor = blue;
            sectionColor = foreground;
          };
          # Dialog styles.
          dialog = {
            fgColor = foreground;
            bgColor = default;
            buttonFgColor = foreground;
            buttonBgColor = magenta;
            buttonFocusFgColor = yellow;
            buttonFocusBgColor = blue;
            labelFgColor = orange;
            fieldFgColor = foreground;
          };
          frame = {
            # Borders styles.
            border = {
              fgColor = selection;
              focusColor = current_line;
            };
            menu = {
              fgColor = foreground;
              keyColor = blue;
              # Used for favorite namespaces
              numKeyColor = blue;
              # CrumbView attributes for history navigation.
            };
            crumbs = {
              fgColor = foreground;
              bgColor = current_line;
              activeColor = current_line;
            };
            # Resource status and update styles
            status = {
              newColor = cyan; # RIGHT HERE!
              modifyColor = magenta;
              addColor = green;
              errorColor = red;
              highlightcolor = orange;
              killColor = comment;
              completedColor = comment;
            };
            # Border title styles.
            title = {
              fgColor = foreground;
              bgColor = current_line;
              highlightColor = orange;
              counterColor = magenta;
              filterColor = blue;
            };
          };
          views = {
            # Charts skins...
            charts = {
              bgColor = default;
              defaultDialColors = [ magenta red ];
              defaultChartColors = [ magenta red ];
            };
            # TableView attributes.
            table = {
              fgColor = foreground;
              bgColor = default;
              # Header row styles.
              header = {
                fgColor = foreground;
                bgColor = default;
                sorterColor = cyan;
              };
            };
            # Xray view attributes.
            xray = {
              fgColor = foreground;
              bgColor = default;
              cursorColor = current_line;
              graphicColor = magenta;
              showIcons = false;
            };
            # YAML info styles.
            yaml = {
              keyColor = blue;
              colonColor = magenta;
              valueColor = foreground;
            };
            # Logs styles.
            logs = {
              fgColor = foreground;
              bgColor = default;
              indicator = {
                fgColor = foreground;
                bgColor = magenta;
              };
              help = {
                fgColor = foreground;
                bgColor = background;
                indicator = {
                  fgColor = red;
                };
              };
            };
          };
        };
    };
  };
}
