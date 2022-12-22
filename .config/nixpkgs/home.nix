{ config, pkgs, nix-colors, ... }:
let
  nix-colors-lib = nix-colors.lib-contrib { inherit pkgs; };
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "matt";
  # home.homeDirectory = "/home/matt";

  home.packages = import ./packages.nix {
    pkgs = pkgs;
    packageSets = [
      # "docker"
      # "kubernetes"
    ];
    additionalPackages = with pkgs; [ ];
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

  xdg.configFile."nvim/init.lua".text = ''
    vim.cmd([[
      source ~/.vimrc
    ]])

    require("lsp")
    require("plugins")
    require("mappings")

    -- show substitutions
    vim.o.inccommand = "nosplit"

    vim.cmd([[
      highlight SignColumn guibg=#00000000
      highlight LineNr guibg=#00000000
    ]])
  '';

  programs.neovim = {
    enable = true;
    plugins = [
      {
        plugin = nix-colors-lib.vimThemeFromScheme { scheme = config.colorScheme; };
        config = "colorscheme nix-${config.colorScheme.slug}";
      }
    ];
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
    enable = true;
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
      program = "${pkgs.tmux}/bin/tmux";
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
}
