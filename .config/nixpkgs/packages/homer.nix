{ config
, lib
, ...
}:
let
  colorScheme = config.colorScheme;
in
{
  # This module creates a homer theme based on the dotfiles theme and accent color.
  # To use it, configure homer to use the resulting css file as a stylesheet:
  #
  #   ```yaml
  #   stylesheet:
  #   - "assets/dotfiles.css"
  #   ```

  options.programs.homer.theme = {
    enable = lib.mkEnableOption "homer dotfiles theme";

    path = lib.mkOption {
      type = lib.types.str;
      default = ".config/homer/assets/dotfiles.css";
      description = "Path to output CSS file to, relative to home directory";
    };
  };

  config =
    let
      cfg = config.programs.homer.theme;
    in
    lib.mkIf cfg.enable {
      home.file."${cfg.path}".text = /* css */ ''
        .light {
          --highlight-primary: #${colorScheme.accentColor};
          --highlight-secondary: #${colorScheme.accentBrightColor};
          --highlight-hover: #${colorScheme.accentColor};
          --background: #${colorScheme.palette.base07};
          --card-background: #${colorScheme.palette.base06};
          --text: #${colorScheme.palette.base00};
          --text-header: #${colorScheme.palette.base00};
          --text-title: #${colorScheme.palette.base01};
          --text-subtitle: #${colorScheme.palette.base02};
          --card-shadow: rgba(0, 0, 0, 0.1);
          --link: #3273dc;
          --link-hover: #363636;
          --background-image: none;

          --highlight-variant-inverted: #363636;
        }

        .dark {
          --highlight-primary: #${colorScheme.accentColor};
          --highlight-secondary: #${colorScheme.accentBrightColor};
          --highlight-hover: #${colorScheme.accentColor};
          --background: #${colorScheme.palette.base00};
          --card-background: #${colorScheme.palette.base01};
          --text: #${colorScheme.palette.base07};
          --text-header: #${colorScheme.palette.base00};
          --text-title: #${colorScheme.palette.base06};
          --text-subtitle: #${colorScheme.palette.base05};
          --card-shadow: rgba(0, 0, 0, 0.4);
          --link: #3273dc;
          --link-hover: #144aa2;
          --background-image: none;

          --highlight-variant-inverted: #f5f5f5;
        }

        #app {
          --highlight-blue: #${colorScheme.palette.base0D};
          --highlight-red: #${colorScheme.palette.base08};
          --highlight-pink: #${colorScheme.palette.base0A};
          --highlight-orange: #${colorScheme.palette.base09};
          --highlight-green: #${colorScheme.palette.base0B};
          --highlight-purple: #${colorScheme.palette.base0E};
        }

        /* make search icon the same color as other header text */
        .search-label:before {
          color: var(--text-header);
        }
      '';
    };
}
