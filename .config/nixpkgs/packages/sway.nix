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

  config = lib.mkIf config.packageSets.sway.enable (
    let powerMenu = pkgs.writeShellScript "power-menu" ''
      swaynag \
        --background "${colorScheme.colors.base00}" \
        --border-bottom "${config.packageSets.sway.accentColor}" \
        --border-bottom-size "0" \
        --border "${config.packageSets.sway.accentColor}" \
        --text "${colorScheme.colors.base07}" \
        --button-text "${colorScheme.colors.base07}" \
        --button-background "${colorScheme.colors.base00}" \
        --button-border-size "1" \
        --font "Hack Nerd Font 12" \
        -y top \
        -t warning \
        -m "> > > > >" \
        -b " 󰗼 exit " "swaymsg exit" \
        -b " 󰜉 restart " "reboot" \
        -b " 󰐥 shutdown " "shutdown now" \
        --dismiss-button "  cancel "
    ''; in
    {
      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "Hack" ]; })
        grim
        libnotify
        mc
        ranger
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
              "${modifier}+Return" = "exec alacritty";
              "${modifier}+Right" = "focus right";
              "${modifier}+Shift+1" = "move container to workspace number 1";
              "${modifier}+Shift+2" = "move container to workspace number 2";
              "${modifier}+Shift+3" = "move container to workspace number 3";
              # "${modifier}+Shift+4" = "exec grim -g $(slurp) ~/$(date -Iseconds).png"; # TODO already mapped
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
              "${modifier}+Shift+e" = "exec ${powerMenu}";
              "${modifier}+Shift+h" = "move left";
              "${modifier}+Shift+j" = "move down";
              "${modifier}+Shift+k" = "move up";
              "${modifier}+Shift+l" = "move right";
              "${modifier}+Shift+minus" = "move scratchpad";
              "${modifier}+Shift+q" = "kill";
              "${modifier}+Shift+space" = "floating toggle";
              "${modifier}+Up" = "focus up";
              "${modifier}+a" = "focus parent";
              "${modifier}+b" = "splith";
              "${modifier}+d" = "exec /nix/store/6jp4lncxh5c9cwkrdr0vy049fzp885gm-rofi-1.7.5+wayland1/bin/rofi -show combi -show-icons -combi-modes 'drun,run,ssh'";
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
              "Alt+F2" = "${pkgs.rofi-wayland}/bin/rofi -show run"; # TODO doesn't work
              "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
              "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
              "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
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
              on-click = powerMenu;
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
        ];
        extraConfig = {
          modi = "drun,run,ssh,combi";
        };
      };
    }
  );
}