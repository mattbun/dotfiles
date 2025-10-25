{ config
, lib
, pkgs
, ...
}:
let
  accentColor = config.colorScheme.accentColor;
in
{
  imports = [
    ./style.nix
  ];

  options = with lib; {
    programs.waybar = {
      customSettings = {
        camera = mkOption {
          type = types.str;
          description = "The path to the camera device";
          example = "/dev/video0";
          default = "";
        };

        terminal = mkOption {
          type = types.str;
          description = "The path to the terminal to use when running things in the terminal";
          example = "\${pkgs.foot}/bin/foot";
          default = "${pkgs.foot}/bin/foot";
        };
      };

      bunu.title = mkOption {
        type = types.str;
        description = "The title of the menu";
        default = "󱄅";
      };

      bunu.exit = mkOption {
        type = types.lines;
        description = "Commands to run when 'exit' is selected";
        default = "";
      };

      bunu.entries =
        let
          entries = (with types; listOf (submodule {
            options = {
              icon = mkOption {
                type = str;
              };

              name = mkOption {
                type = str;
              };

              action = mkOption {
                type = str;
              };
            };
          }));
        in
        {
          shortcuts = mkOption {
            type = entries;
            default = [ ];
          };

          power = mkOption {
            type = entries;
            default = [ ];
          };
        };
    };
  };

  config = lib.mkIf config.programs.waybar.enable {
    home.packages = with pkgs; [
      alsa-utils
      libnotify
      wl-clipboard

      (lib.mkIf ((builtins.stringLength config.programs.waybar.customSettings.camera) > 0)
        mpv
      )
    ];

    programs = {
      bottom.enable = true; # for cpu/memory usage graphs

      waybar = {
        bunu.entries.shortcuts = lib.mkIf ((builtins.stringLength config.programs.waybar.customSettings.camera) > 0) [{
          icon = "󰄀";
          name = "mirror";
          action = toString (pkgs.writeShellScript "mirror" ''
            ${pkgs.mpv}/bin/mpv av://v4l2:${config.programs.waybar.customSettings.camera} --vf=hflip --profile=low-latency
          '');
        }];

        bunu.entries.power = [
          {
            icon = "󰌾";
            name = "lock";
            action = toString (pkgs.writeShellScript "lock-screen" /* bash */ ''
              # Wait a second for input to finish
              sleep 1

              # swayidle immediately enters idle state when sent a USR1 signal
              pkill --signal USR1 swayidle
            '');
          }
          {
            icon = "󰗼";
            name = "exit";
            action = config.programs.waybar.bunu.exit;
          }
          {
            icon = "󰤄";
            name = "sleep";
            action = "systemctl suspend";
          }
          {
            icon = "󰜉";
            name = "restart";
            action = "reboot";
          }
          {
            icon = "󰐥";
            name = "shutdown";
            action = "shutdown now";
          }
        ];

        settings = {
          mainBar = {
            height = 24;
            layer = "top";
            position = "top";
            modules-left = [ ];
            modules-right = [ "tray" "mpris" "pulseaudio" "bluetooth" "network" "memory" "cpu" "clock#date" "clock#time" "custom/userhostname" ];

            "sway/window" = {
              icon-size = 16;
              max-length = 64;
              icon = true;
            };

            tray = {
              icon-size = 16;
              spacing = 10;
            };

            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = "󰅶";
                deactivated = "󰾪";
              };
            };

            pulseaudio = {
              format-muted = "󰸈";
              format = "{icon} {volume:2}%";
              format-icons = {
                headphone = "󰋋";
                hdmi = "󰍹";
                speaker = "󰓃";
                default = [ "󰖀" "󰕾" ];
              };
              on-click = "${config.programs.waybar.customSettings.terminal} -T alsamixer -e alsamixer -V playback";
              on-click-right = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            };

            network = {
              format-ethernet = "󰈀";
              format-wifi = "󰖩";
              format-linked = "󰈀";
              format-disconnected = "󰌙";
              tooltip-format = "{ifname} - {ipaddr}\nGateway: {gwaddr}\nUp: {bandwidthUpBits}\nDown: {bandwidthDownBits}";
              on-click = "${config.programs.waybar.customSettings.terminal} -T nmtui -e nmtui";
            };

            bluetooth = {
              format-disabled = "";
              format-off = "󰂲";
              format-on = "󰂯";
              format-connected = "󰂱";
              on-click = "${config.programs.waybar.customSettings.terminal} -T bluetoothctl -e bluetoothctl";
              on-click-right = pkgs.writeShellScript "toggle-bluetooth" ''
                bluetoothctl show | grep "Powered: yes"
                if [[ "$?" = "0" ]]; then
                  bluetoothctl power off
                else
                  bluetoothctl power on
                fi
              '';
            };

            disk = {
              path = "/";
              interval = 10;
              format = "/ {percentage_used}%";
            };

            cpu = {
              interval = 10;
              format = " {usage:2}%";
              on-click = "${config.programs.waybar.customSettings.terminal} -T btm-cpu -e btm-cpu";
            };

            memory = {
              interval = 10;
              format = " {percentage:2}%"; # some other icon ideas: 󱊖 󰠷
              on-click = "${config.programs.waybar.customSettings.terminal} -T btm-mem -e btm-mem";
            };

            "clock#date" = {
              interval = 1;
              format = "{:%Y-%m-%d}";
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              calendar = {
                mode = "month";
                mode-mon-col = 3;
                format = {
                  today = "<span color='#${accentColor}'><b>{}</b></span>";
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

            "custom/userhostname" =
              let
                separator = {
                  icon = "---";
                  name = "";
                  action = "";
                };
                close = {
                  icon = "󱎘";
                  name = "close";
                  action = "";
                };
                shortcuts = config.programs.waybar.bunu.entries.shortcuts;
                power = config.programs.waybar.bunu.entries.power;

                entries = shortcuts ++ [ separator ] ++ power ++ [ separator close ];

                bunuRofi = with builtins; pkgs.writeShellScript "bunu-rofi" ''
                  entries="${concatStringsSep ";" (map (x: x.icon + " " + x.name) entries)}"

                  chosen=$(echo -n "$entries" | ${pkgs.rofi}/bin/rofi -p "${config.programs.waybar.bunu.title} " -dmenu -sep ";" -l ${toString (length entries)} -location 3 -theme-str 'window {width:256;}')

                  case "$chosen" in
                  ${concatStringsSep "\n" (map (x: "  \"" + x.icon + " " + x.name + "\")" + x.action + " ;;") entries )}
                    *) exit 1 ;;
                  esac
                '';
              in
              {
                interval = "once";
                exec = pkgs.writeShellScript "userhostname" ''
                  echo -e "$(whoami)@$(hostname)\n$(uname -smrn)"
                '';
                on-click = bunuRofi;
              };

            "group/actions" = {
              orientation = "inherit";
              modules = [
                # from left to right
                (lib.mkIf ((builtins.stringLength config.programs.waybar.customSettings.camera) > 0)
                  "custom/mirror"
                )
              ];
            };

            "mpris" = {
              "format" = "{status_icon}";
              "status-icons" = {
                "playing" = "";
                "paused" = "";
                "stopped" = "";
              };
            };
          };
        };
      };
    };
  };
}
