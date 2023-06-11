{ config
, ...
}:
let
  colorScheme = config.colorScheme; in
{
  programs.alacritty.settings = {
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
}
