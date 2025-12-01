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

    wayland.windowManager.sway.customSettings = {
      browser = mkOption {
        type = types.str;
        description = "Default web browser";
        default = "${pkgs.firefox}/bin/firefox";
      };

      camera = mkOption {
        type = types.str;
        description = "The path to the camera device";
        example = "/dev/video0";
        default = "";
      };
    };
  };

  config = lib.mkIf config.wayland.windowManager.sway.enable (
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

      screenshot = pkgs.writeShellScript "screenshot" ''
        set -e

        mkdir -p ~/screenshots
        timestamp=$(date -Iseconds)
        screenshot_path="''${HOME}/screenshots/''${timestamp}.png"

        case "$1" in
          selection)
            ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -c '#${accentColor}')" "''${screenshot_path}"
            ;;

          window)
            selection=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp -c '#${accentColor}')
            ${pkgs.grim}/bin/grim -g "''${selection}" "''${screenshot_path}"
            ;;

          display)
            # TODO skip selection if there's only one display
            display=$(slurp -o -f "%o" -c '#${accentColor}')
            ${pkgs.grim}/bin/grim -o "''${display}" "''${screenshot_path}"
        esac

        cat ''${screenshot_path} | ${pkgs.wl-clipboard}/bin/wl-copy

        result=$(${pkgs.libnotify}/bin/notify-send --action 'default=open' "Screenshot" "''${screenshot_path}" --expire-time 2500)

        if [ "''${result}" = "default" ]; then
          xdg-open "''${screenshot_path}"
        fi
      '';

      screenshotSelection = "${screenshot} selection";
      screenshotWindow = "${screenshot} window";
      screenshotDisplay = "${screenshot} display";
    in
    {
      fonts.fontconfig.enable = true;
      services.mako.enable = true; # notifications

      programs = {
        rofi = {
          enable = true;
          terminal = config.wayland.windowManager.sway.config.terminal;
        };
        lf.enable = true; # text-based file manager
      };

      home.packages = with pkgs; [
        grim
        jq # used in screenshot scripts
        playerctl
        slurp
        wdisplays
        xdg-utils
      ];

      wayland.windowManager.sway = {
        config = {
          defaultWorkspace = "workspace number 1";
          modifier = "Mod4"; # super
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
            names = config.fonts.fontconfig.defaultFonts.proportional;
            size = 12.0;
          };
          bars = [
            {
              command = "${pkgs.waybar}/bin/waybar";
            }
          ];
          menu = ''
            ${pkgs.rofi}/bin/rofi -show combi -show-icons -combi-modes "drun,run,ssh"
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
              "${modifier}+0" = "workspace number 10";
              "${modifier}+Down" = "focus down";
              "${modifier}+Left" = "focus left";
              "${modifier}+Return" = "exec ${config.wayland.windowManager.sway.config.terminal}";
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
              "${modifier}+Shift+0" = "move container to workspace number 10";
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
              "${modifier}+Shift+s" = "exec ${pkgs.rofi}/bin/rofi -show ssh";
              "${modifier}+Shift+space" = "floating toggle";
              "${modifier}+Tab" = "exec ${pkgs.rofi}/bin/rofi -show window -show-icons";
              "${modifier}+Up" = "focus up";
              "${modifier}+a" = "focus parent";
              "${modifier}+b" = "splith";
              "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show combi -show-icons -combi-modes 'drun,run,ssh'";
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
              "${modifier}+escape" = "exec ${config.wayland.windowManager.sway.customSettings.browser}";
              "${alt}+F2" = "exec ${pkgs.rofi}/bin/rofi -show run";
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

          bindgesture swipe:3:right workspace prev_on_output
          bindgesture swipe:3:left workspace next_on_output
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

      # Enable waybar and make some sway-specific modifications
      programs.waybar = {
        enable = true;

        settings.mainBar = {
          modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
        };

        customSettings = {
          camera = config.wayland.windowManager.sway.customSettings.camera;
          terminal = config.wayland.windowManager.sway.config.terminal;
        };

        bunu = {
          exit = "swaymsg exit || true";
          entries = {
            shortcuts = [
              {
                icon = "";
                name = "screenshot selection";
                action = screenshotSelection;
              }
              {
                icon = "";
                name = "screenshot window";
                action = screenshotWindow;
              }
              {
                icon = "󰍹";
                name = "screenshot display";
                action = screenshotDisplay;
              }
            ];
          };
        };
      };
    }
  );
}
