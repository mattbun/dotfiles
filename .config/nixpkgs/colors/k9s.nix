{ config
, ...
}:
let
  colorScheme = config.colorScheme; in
{
  programs.k9s.skin = {
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
}
