{ pkgs
, config
, lib
, ...
}:
let
  colorScheme = config.colorScheme;
  colors = config.colorScheme.palette;
  accentColor = config.colorScheme.accentColor;
in
{
  options = with lib; {
    packageSets.sway = {
      enable = mkOption {
        type = types.bool;
        description = "Whether or not to install and configure sway";
        default = false;
      };

      terminal = mkOption {
        type = types.path;
        description = "Terminal to use in hotkeys and other shortcuts";
        default = "${pkgs.foot}/bin/foot";
      };

      browser = mkOption {
        type = types.path;
        description = "Default web browser";
        default = "${pkgs.firefox}/bin/firefox";
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

      idleTimeoutSeconds = mkOption {
        type = types.ints.positive;
        description = "How long to wait before turning off displays if there's no activity";
        default = 15 * 60;
      };
    };
  };

  config = lib.mkIf config.packageSets.sway.enable (
    let
      lockScreen = pkgs.writeShellScript "lock-screen" ''
        # Wait a second for input to finish
        sleep 1

        # swayidle immediately enters idle state when sent a USR1 signal
        pkill --signal USR1 swayidle
      '';

      powerMenuRofi = pkgs.writeShellScript "power-menu-rofi" ''
        location=''${1:-0}
        entries="󰌾 lock;󰗼 exit;󰤄 sleep;󰜉 restart;󰐥 shutdown;󱎘 cancel"

        chosen=$(echo -n "$entries" | rofi -p "power" -dmenu -sep ";" -location $location -theme-str 'window {width:256;}')

        case "$chosen" in
          "󰌾 lock") ${lockScreen} ;;
          "󰗼 exit") swaymsg exit ;;
          "󰤄 sleep") systemctl suspend ;;
          "󰜉 restart") reboot ;;
          "󰐥 shutdown") shutdown now ;;
          *) exit 1 ;;
        esac
      '';

      powerMenuCenter = "${powerMenuRofi} 0";
      powerMenuUpperRight = "${powerMenuRofi} 3";
    in
    {
      packageSets.fonts.enable = true;
      packageSets.firefox.enable = true;
      services.mako.enable = true; # notifications
      programs.bottom.enable = true;
      programs.rofi.enable = true;

      home.packages = with pkgs; [
        grim
        libnotify
        mc
        playerctl
        ranger
        slurp
        wl-clipboard
        xdg-utils
      ];

      wayland.windowManager.sway = {
        enable = true;
        config = {
          modifier = "Mod4";
          terminal = config.packageSets.sway.terminal;
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
          fonts = {
            names = [ config.packageSets.fonts.propo ];
            size = 12.0;
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
              alt = "Mod1";
              # super = "Mod4";
            in
            lib.mkOptionDefault {
              "${modifier}+1" = "workspace number 1";
              "${modifier}+2" = "workspace number 2";
              "${modifier}+3" = "workspace number 3";
              "${modifier}+4" = "workspace number 4";
              "${modifier}+5" = "workspace number 5";
              "${modifier}+6" = "workspace number 6";
              "${modifier}+7" = "workspace number 7";
              "${modifier}+8" = "workspace number 8";
              "${modifier}+9" = "workspace number 9";
              "${modifier}+Down" = "focus down";
              "${modifier}+Left" = "focus left";
              "${modifier}+Return" = "exec ${config.packageSets.sway.terminal}";
              "${modifier}+Right" = "focus right";
              "${modifier}+Shift+1" = "move container to workspace number 1";
              "${modifier}+Shift+2" = "move container to workspace number 2";
              "${modifier}+Shift+3" = "move container to workspace number 3";
              "${modifier}+Shift+4" = "move container to workspace number 4";
              "${modifier}+Shift+5" = "move container to workspace number 5";
              "${modifier}+Shift+6" = "move container to workspace number 6";
              "${modifier}+Shift+7" = "move container to workspace number 7";
              "${modifier}+Shift+8" = "move container to workspace number 8";
              "${modifier}+Shift+9" = "move container to workspace number 9";
              "${modifier}+Shift+Ctrl+4" = "exec ${pkgs.grim}/bin/grim -g $(${pkgs.slurp}/bin/slurp) | ${pkgs.wl-clipboard}/bin/wl-copy";
              "${modifier}+Shift+Down" = "move down";
              "${modifier}+Shift+Left" = "move left";
              "${modifier}+Shift+Right" = "move right";
              "${modifier}+Shift+Up" = "move up";
              "${modifier}+Shift+c" = "reload";
              "${modifier}+Shift+e" = "exec ${powerMenuCenter}";
              "${modifier}+Shift+h" = "move left";
              "${modifier}+Shift+j" = "move down";
              "${modifier}+Shift+k" = "move up";
              "${modifier}+Shift+l" = "move right";
              "${modifier}+Shift+minus" = "move scratchpad";
              "${modifier}+Shift+q" = "kill";
              "${modifier}+Shift+s" = "exec ${pkgs.rofi-wayland}/bin/rofi -show ssh";
              "${modifier}+Shift+space" = "floating toggle";
              "${modifier}+Tab" = "exec ${pkgs.rofi-wayland}/bin/rofi -show window -show-icons";
              "${modifier}+Up" = "focus up";
              "${modifier}+a" = "focus parent";
              "${modifier}+b" = "splith";
              "${modifier}+d" = "exec ${pkgs.rofi-wayland}/bin/rofi -show combi -show-icons -combi-modes 'drun,run,ssh'";
              "${modifier}+e" = "layout toggle split";
              "${modifier}+f" = "fullscreen toggle";
              "${modifier}+h" = "focus left";
              "${modifier}+j" = "focus down";
              "${modifier}+k" = "focus up";
              "${modifier}+l" = "focus right";
              "${modifier}+minus" = "scratchpad show";
              "${modifier}+r" = "mode resize";
              "${modifier}+s" = "layout stacking";
              "${modifier}+space" = "focus mode_toggle";
              "${modifier}+v" = "splitv";
              "${modifier}+w" = "layout tabbed";
              "${modifier}+escape" = "exec ${config.packageSets.sway.browser}";
              "${alt}+F2" = "exec ${pkgs.rofi-wayland}/bin/rofi -show run"; # TODO doesn't work
              "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
              "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
              "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
              "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
              "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
              "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
            };
        };

        extraConfig = ''
          # Property Name         Border            BG                Text              Indicator         Child Border
          client.focused          #${accentColor}   #${colors.base02} #${colors.base05} #${accentColor}   #${accentColor}
          client.focused_inactive #${colors.base01} #${colors.base01} #${colors.base05} #${colors.base03} #${colors.base01}
          client.unfocused        #${colors.base01} #${colors.base00} #${colors.base05} #${colors.base01} #${colors.base01}
          client.urgent           #${colors.base08} #${colors.base08} #${colors.base00} #${colors.base08} #${colors.base08}
          client.placeholder      #${colors.base00} #${colors.base00} #${colors.base05} #${colors.base00} #${colors.base00}
          client.background       #${colors.base07}
        '';
      };

      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = config.packageSets.sway.idleTimeoutSeconds;
            command = "${pkgs.sway}/bin/swaymsg 'output * power off'";
            resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
          }
        ];
      };

      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            height = 24;
            layer = "top";
            position = "top";
            modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
            modules-right = [ "tray" "bluetooth" "network" "pulseaudio" "memory" "cpu" "clock#date" "clock#time" "custom/userhostname" ];

            "wlr/taskbar" = {
              on-click = "activate";
              on-click-middle = "close";
              on-click-right = "close";
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
              on-click = "${config.packageSets.sway.terminal} -T alsamixer -e alsamixer";
            };

            network = {
              format-ethernet = "󰈀 {ipaddr}";
              format-wifi = "󰖩 {ipaddr}";
              format-linked = "󰈀";
              format-disconnected = "󰌙";
              tooltip-format = "{ifname} - {ipaddr}\nGateway: {gwaddr}\nUp: {bandwidthUpBits}\nDown: {bandwidthDownBits}";
              on-click = "${config.packageSets.sway.terminal} -T nmtui -e nmtui";
            };

            bluetooth = {
              format-disabled = "";
              format-off = "󰂲";
              format-on = "󰂯";
              format-connected = "󰂱";
              on-click = "${config.packageSets.sway.terminal} -T bluetoothctl -e bluetoothctl";
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
              on-click = "${config.packageSets.sway.terminal} -T btm-cpu -e btm-cpu";
            };

            memory = {
              interval = 10;
              format = " {percentage:2}%"; # some other icon ideas: 󱊖 󰠷
              on-click = "${config.packageSets.sway.terminal} -T btm-mem -e btm-mem";
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

            "custom/userhostname" = {
              interval = "once";
              exec = pkgs.writeShellScript "userhostname" ''
                echo -e "$(whoami)@$(hostname)\n$(uname -smrn)"
              '';
              on-click = powerMenuUpperRight;
            };
          };
        };
      };
    }
  );
}
