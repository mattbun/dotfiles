{ config, ... }: {
  programs.wiremix.settings = {
    mouse = true;
    tab = "output";
    themes.default = {
      volume_filled.fg = "#${config.colorScheme.accentColor}";
      tab_selected.fg = "#${config.colorScheme.accentColor}";
      tab_marker.fg = "#${config.colorScheme.accentColor}";
      selector.fg = "#${config.colorScheme.accentColor}";

      dropdown_border.fg = "DarkGray";
      dropdown_selected = {
        fg = "#${config.colorScheme.accentColor}";
      };
    };
  };
}
