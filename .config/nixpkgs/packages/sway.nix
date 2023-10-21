{ pkgs
, config
, lib
, ...
}:
let
  colorScheme = config.colorScheme; in
{
  options = with lib; {
    packageSets.sway = {
      enable = mkOption {
        type = types.bool;
        description = "Whether or not to install and configure sway";
        default = false;
      };

      accentColor = mkOption {
        type = types.str;
        description = "Accent color to use in notifications and menus in '#RRGGBB' format";
        default = "#${colorScheme.colors.base0E}"; # some good options: 0E -> purple, 0C -> cyan, 09 -> orange
      };

      background = mkOption {
        type = types.str;
        description = "A path to a file to an image to use as background or a color in '#RRGGBB' format";
        default = builtins.fetchurl "https://raw.githubusercontent.com/DenverCoder1/minimalistic-wallpaper-collection/main/images/voyager-bequem-almost-spring-prev-2.jpg";
      };

      backgroundMode = mkOption {
        type = types.str;
        description = "Scaling mode for the background if using an image, either 'stretch', 'fill', 'fit', 'center', or 'tile'";
        default = "fill";
      };
    };
  };

  config = lib.mkIf config.packageSets.sway.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Hack" ]; })
      grim
      libnotify
      slurp
      wl-clipboard
      xdg-utils
    ];

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
        output = {
          "*" = {
            background = "${config.packageSets.sway.background} ${config.packageSets.sway.backgroundMode}";
          };
        };
        window = {
          border = 2;
          hideEdgeBorders = "both";
        };
        bars = [
          {
            command = "${pkgs.waybar}/bin/waybar";
          }
        ];
        menu = ''
          ${pkgs.rofi-wayland}/bin/rofi -show combi -show-icons -combi-modes "drun,run,ssh"
        '';
        keybindings =
          let
            modifier = config.wayland.windowManager.sway.config.modifier;
          in
          lib.mkOptionDefault {
            "Alt_L+F2" = "${pkgs.rofi-wayland}/bin/rofi -show run"; # TODO doesn't work
            "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "${modifier}+Shift+4" = "exec grim -g $(slurp) ~/$(date -Iseconds).png";
            "${modifier}+Shift+Ctrl+4" = "exec grim -g $(slurp) | wl-copy";
          };
      };
    };

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          height = 24;
          layer = "top";
          position = "top";
          modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
          modules-right = [ "tray" "pulseaudio" "memory" "cpu" "clock#date" "clock#time" "custom/userhostname" ];

          "wlr/taskbar" = {
            on-click = "activate";
            on-click-middle = "close";
          };

          tray = {
            icon-size = 16;
            spacing = 10;
          };

          pulseaudio = {
            format-muted = "󰸈";
            format = "{icon} {volume}%";
            format-icons = {
              headphone = "󰋋";
              hdmi = "󰍹";
              speaker = "󰓃";
              default = [ "󰖀" "󰕾" ];
            };
            on-click = "${pkgs.alacritty}/bin/alacritty -e alsamixer";
          };

          disk = {
            path = "/";
            interval = 10;
            format = "/ {percentage_used}%";
          };

          cpu = {
            interval = 10;
            format = "cpu: {usage}%";
            on-click = "alacritty -e htop";
          };

          memory = {
            interval = 10;
            format = "mem: {percentage}%";
            on-click = "alacritty -e htop";
          };

          "clock#date" = {
            interval = 1;
            format = "{:%Y-%m-%d}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "month";
              mode-mon-col = 3;
              format = {
                today = "<span color='${config.packageSets.sway.accentColor}'><b>{}</b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
            };
            on-click = pkgs.writeShellScript "copy-datestamp" ''
              datestamp="$(date -I)"
              echo $datestamp | ${pkgs.wl-clipboard}/bin/wl-copy
              ${pkgs.libnotify}/bin/notify-send "Copied to clipboard" "$datestamp" --expire-time 2500
            '';
          };

          "clock#time" = {
            interval = 1;
            format = "{:%H:%M:%S}";
            tooltip-format = "{:%Y-%m-%dT%H:%M:%S%Ez}";
            on-click = pkgs.writeShellScript "copy-timestamp" ''
              timestamp="$(date -Iseconds)"
              echo $timestamp | ${pkgs.wl-clipboard}/bin/wl-copy
              ${pkgs.libnotify}/bin/notify-send "Copied to clipboard " "$timestamp" --expire-time 2500
            '';
          };

          "custom/userhostname" = {
            interval = "once";
            exec = pkgs.writeShellScript "userhostname" ''
              echo -e "$(whoami)@$(hostname)\n$(uname -smrn)"
            '';
            on-click = pkgs.writeShellScript "power-menu" ''
              swaynag \
                --background "${colorScheme.colors.base0A}" \
                --font "Hack" \
                -y top \
                -t warning \
                -m "> > > > >" \
                -b "exit desktop" "swaymsg exit" \
                -b "restart" "reboot" \
                -b "shutdown" "shutdown now"
            '';
          };
        };
      };
    };

    services.mako = {
      enable = true;
      font = "monospace 12";
      backgroundColor = "#${colorScheme.colors.base00}FF";
      borderColor = "${config.packageSets.sway.accentColor}FF";
      progressColor = "#${colorScheme.colors.base07}FF"; # TODO not sure how to test this
    };

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      font = "Hack 12";
      plugins = with pkgs; [
        rofi-calc # TODO doesn't work with keybinding
        rofi-power-menu
      ];
      extraConfig = {
        modi = "drun,run,ssh,combi";
      };
    };
  };
}
