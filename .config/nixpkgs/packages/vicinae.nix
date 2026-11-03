{ config, ... }: {
  programs.vicinae = {
    enable = true;

    themes.dotfiles = {
      meta = {
        name = "dotfiles";
        description = "theme that matches dotfiles";
        variant = "dark";
      };
      colors = {
        core = {
          background = "#${config.colorScheme.palette.base00}";
          foreground = "#${config.colorScheme.palette.base06}";
          secondary_background = "#${config.colorScheme.palette.base01}";
          accent = "#${config.colorScheme.accentColor}";
          border = "#${config.colorScheme.accentColor}";
        };

        main_window.border = "#${config.colorScheme.accentColor}";

        accents = let palette = config.colorScheme.palette; in {
          red = "#${palette.red}";
          orange = "#${palette.orange}";
          yellow = "#${palette.yellow}";
          green = "#${palette.green}";
          cyan = "#${palette.cyan}";
          blue = "#${palette.blue}";
          magenta = "#${palette.magenta}";
          purple = "#${palette.magenta}"; # No purple in color scheme
        };
      };
    };
  };
}
