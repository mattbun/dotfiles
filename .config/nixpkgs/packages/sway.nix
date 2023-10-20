{ pkgs
, config
, lib
, ...
}: {
  options = with lib; {
    packageSets.sway = mkOption {
      type = types.bool;
      description = "Whether or not to install and configure sway";
      default = false;
    };
  };

  config = lib.mkIf config.packageSets.graphical {
    wayland.windowManager.sway = {
      enable = true;
      config = rec {
        modifier = "Mod4";
        terminal = "alacritty";
        startup = [ ];
        input = {
          "*" = {
            natural_scroll = "enabled";
          };
        };
        window = {
          border = 2;
          hideEdgeBorders = "both";
        };
      };
    };

    programs.i3status = {
      enable = true;
      enableDefault = false;
      modules = {
        "volume master" = {
          position = 1;
          settings = {
            format = "%volume";
            format_muted = "muted (%volume)";
            device = "pulse:1";
          };
        };

        "tztime local" = {
          position = 8;
          settings = { format = "%Y-%m-%d %H:%M:%S"; };
        };
      };
    };
  };
}
