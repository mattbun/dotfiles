{ pkgs
, config
, lib
, ...
}: {
  packageSets.fonts.enable = lib.mkIf config.programs.alacritty.enable true;

  programs.alacritty = {
    settings = {
      env = {
        TERM = "xterm-256color";
      };

      font = {
        normal = {
          family = config.packageSets.fonts.mono;
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
          background = "0x${config.colorScheme.palette.base00}";
          foreground = "0x${config.colorScheme.palette.base05}";
        };

        # Colors the cursor will use if `custom_cursor_colors` is tru";
        cursor = {
          text = "0x${config.colorScheme.palette.base00}";
          cursor = "0x${config.colorScheme.palette.base05}";
        };

        # Normal color";
        normal = {
          black = "0x${config.colorScheme.palette.base00}";
          red = "0x${config.colorScheme.palette.base08}";
          green = "0x${config.colorScheme.palette.base0B}";
          yellow = "0x${config.colorScheme.palette.base0A}";
          blue = "0x${config.colorScheme.palette.base0D}";
          magenta = "0x${config.colorScheme.palette.base0E}";
          cyan = "0x${config.colorScheme.palette.base0C}";
          white = "0x${config.colorScheme.palette.base05}";
        };

        # Bright color";
        bright = {
          black = "0x${config.colorScheme.palette.base03}";
          red = "0x${config.colorScheme.palette.base09}";
          green = "0x${config.colorScheme.palette.base01}";
          yellow = "0x${config.colorScheme.palette.base02}";
          blue = "0x${config.colorScheme.palette.base04}";
          magenta = "0x${config.colorScheme.palette.base06}";
          cyan = "0x${config.colorScheme.palette.base0F}";
          white = "0x${config.colorScheme.palette.base07}";
        };

        draw_bold_text_with_bright_colors = false;
      };
    };
  };
}
