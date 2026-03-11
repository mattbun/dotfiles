{ pkgs
, config
, lib
, ...
}:
let
  colors = config.colorScheme.palette;
in
{
  fonts.fontconfig.enable = lib.mkIf config.programs.alacritty.enable true;

  programs.alacritty = {
    settings = {
      env = {
        TERM = "xterm-256color";
      };

      font = {
        normal = {
          family = lib.head config.fonts.fontconfig.defaultFonts.monospace;
        };
        size = 13.0;
      };

      selection = {
        save_to_clipboard = true;
      };

      terminal = {
        shell = {
          program = "${pkgs.tmux}/bin/tmux";
        };
      };

      window = {
        option_as_alt = "Both"; # Allows option to be used as a modifier in mappings
      };

      colors = {
        # Default color;
        primary = {
          background = "0x${colors.base00}";
          foreground = "0x${colors.base05}";
        };

        # Colors the cursor will use if `custom_cursor_colors` is tru";
        cursor = {
          text = "0x${colors.base00}";
          cursor = "0x${colors.base05}";
        };

        # Normal color";
        normal = {
          black = "0x${colors.ansi00}";
          red = "0x${colors.ansi01}";
          green = "0x${colors.ansi02}";
          yellow = "0x${colors.ansi03}";
          blue = "0x${colors.ansi04}";
          magenta = "0x${colors.ansi05}";
          cyan = "0x${colors.ansi06}";
          white = "0x${colors.ansi07}";
        };

        # Bright color";
        bright = {
          black = "0x${colors.ansi08}";
          red = "0x${colors.ansi09}";
          green = "0x${colors.ansi10}";
          yellow = "0x${colors.ansi11}";
          blue = "0x${colors.ansi12}";
          magenta = "0x${colors.ansi13}";
          cyan = "0x${colors.ansi14}";
          white = "0x${colors.ansi15}";
        };

        draw_bold_text_with_bright_colors = false;
      };
    };
  };
}
