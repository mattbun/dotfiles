{ config, lib, pkgs, ... }:
{
  options.wayland.customWindowManager.niri = {
    enable = lib.mkEnableOption "niri";

    idleTimeoutSeconds = lib.mkOption {
      type = lib.types.ints.positive;
      description = "How long to wait before turning off displays if there's no activity";
      default = 15 * 60;
    };

    background = lib.mkOption {
      type = lib.types.str;
      description = "A path to a file to an image to use as background or a color in '#RRGGBB' format";
      default = builtins.fetchurl "https://raw.githubusercontent.com/DenverCoder1/minimalistic-wallpaper-collection/main/images/voyager-bequem-almost-spring-prev-2.jpg";
    };

    backgroundMode = lib.mkOption {
      type = lib.types.str;
      description = "Scaling mode for the background if using an image, either 'stretch', 'fill', 'fit', 'center', or 'tile'";
      default = "fill";
    };

    browser = lib.mkOption {
      type = lib.types.str;
      description = "Default terminal";
      default = "${pkgs.firefox}/bin/firefox";
    };

    terminal = lib.mkOption {
      type = lib.types.str;
      description = "Default terminal";
      default = "${pkgs.foot}/bin/foot";
    };

    config = lib.mkOption {
      type = lib.types.lines;
      description = "Config to put in config.kdl";
    };
  };

  config =
    let
      cfg = config.wayland.customWindowManager.niri;
      colorScheme = config.colorScheme;
    in
    lib.mkIf cfg.enable {
      # TODO niri-switcher?
      # TODO turn waybar into a systemd service?
      # TODO show the same exit rofi as sway

      home.packages = with pkgs; [
        swaybg
        brightnessctl
      ];

      programs = {
        rofi = {
          enable = true;
          terminal = cfg.terminal;
        };

        waybar = {
          enable = true;

          settings.mainBar = {
            modules-left = [ "niri/workspaces" "niri/window" ];

            "niri/window" = {
              separate-outputs = true;
            };
          };

          bunu.exit = "niri msg action quit --skip-confirmation || true";
        };
      };

      services = {
        mako.enable = true;

        swayidle = {
          enable = true;
          timeouts = [
            {
              timeout = config.packageSets.sway.idleTimeoutSeconds;
              command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
              resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors'";
            }
          ];
        };
      };

      xdg.configFile."niri/config.kdl".text = cfg.config;

      wayland.customWindowManager.niri.config = /* kdl */ ''
        // https://github.com/YaLTeR/niri/wiki/Configuration:-Overview
        layout {
            gaps 0
            center-focused-column "never"

            default-column-width { proportion 0.5; }
            preset-column-widths {
                proportion 0.3
                proportion 0.5
                proportion 0.7
            }

            focus-ring {
                off 
            }

            border {
                width 2
                active-color "#${colorScheme.accentColor}"
                inactive-color "#${colorScheme.palette.base00}"
            }

            background-color "transparent"
        }

        layer-rule {
            match namespace="waybar"
            place-within-backdrop true
        }

        // Make the wallpaper stationary, rather than moving with workspaces.
        layer-rule {
            match namespace="^wallpaper$"
            place-within-backdrop true
        }

        overview {
          backdrop-color "#${colorScheme.palette.base00}"
          workspace-shadow {
              off
          }
        }

        spawn-at-startup "${pkgs.swaybg}/bin/swaybg" "-i" "${cfg.background}" "-m" "${cfg.backgroundMode}"
        spawn-at-startup "waybar"

        // Uncomment this line to ask the clients to omit their client-side decorations if possible.
        // If the client will specifically ask for CSD, the request will be honored.
        // Additionally, clients will be informed that they are tiled, removing some rounded corners.
        prefer-no-csd

        screenshot-path "~/screenshots/%Y-%m-%dT%H-%M-%S%z.png"

        hotkey-overlay {
          skip-at-startup
        }

        // Rounded corners on windows
        // window-rule {
        //   geometry-corner-radius 4
        //   clip-to-geometry true
        // }

        // Work around WezTerm's initial configure bug
        // by setting an empty default-column-width.
        window-rule {
            match app-id=r#"^org\.wezfurlong\.wezterm$"#
            default-column-width {}
        }

        input {
            focus-follows-mouse

            touchpad {
                tap
                natural-scroll
            }
        }

        cursor {
          hide-when-typing
        }

        gestures {
          hot-corners {
            off
          }
        }

        binds {
            Mod+Shift+Slash { show-hotkey-overlay; }

            Mod+Return { spawn "${cfg.terminal}"; }
            Mod+Escape { spawn "${cfg.browser}"; } // TODO change from escape to something else?
            Mod+Space { spawn "${pkgs.rofi}/bin/rofi" "-show" "combi" "-show-icons" "-combi-modes" "drun,run,ssh"; }
            // Mod+Comma  { consume-window-into-column; }
            // Mod+Period { expel-window-from-column; }
            Mod+Comma { set-column-width "-10%"; }
            Mod+Shift+Comma { set-window-height "-10%"; }
            Mod+Period { set-column-width "+10%"; }
            Mod+Shift+Period { set-window-height "+10%"; }
            Mod+Minus { set-column-width "-10%"; }
            Mod+Shift+Minus { set-window-height "-10%"; }
            Mod+Equal { set-column-width "+10%"; }
            Mod+Shift+Equal { set-window-height "+10%"; }
            Mod+Apostrophe { spawn "${pkgs.rofi}/bin/rofi" "-show" "ssh"; } // Next to return

            Mod+B  { consume-window-into-column; }     // TODO is this a good place for this?
            Mod+Shift+B { expel-window-from-column; }  // TODO is this a good place for this?
            Mod+C { center-column; }
            Mod+Shift+E { quit; }
            Mod+F { maximize-column; }
            Mod+Shift+F { fullscreen-window; }
            Mod+M { switch-preset-column-width; }
            Mod+Shift+M { reset-window-height; }
            Mod+N { focus-workspace 99; } // focus the bottom-most (empty) workspace
            Mod+Shift+P { power-off-monitors; }
            Mod+Q { close-window; }
            Mod+R { switch-preset-column-width; } // TODO remove in favor of M?
            Mod+Shift+R { reset-window-height; }  // TODO remove in favor of M?
            Mod+S { screenshot; }
            Mod+Shift+S { screenshot-window; }
            Mod+Ctrl+S { screenshot-screen; }
            Mod+T { spawn "${cfg.terminal}"; }
            Mod+Z { maximize-column; }
            Mod+Shift+Z { fullscreen-window; }

            Mod+Grave { focus-workspace-previous; }
            Mod+Tab { focus-window-previous; }

            Mod+Left  { focus-column-or-monitor-left; }
            Mod+Down  { focus-window-or-workspace-down; }
            Mod+Up    { focus-window-or-workspace-up; }
            Mod+Right { focus-column-or-monitor-right; }
            Mod+H     { focus-column-or-monitor-left; }
            Mod+J     { focus-window-or-workspace-down; }
            Mod+K     { focus-window-or-workspace-up; }
            Mod+L     { focus-column-or-monitor-right; }

            Mod+Shift+Left  { move-column-left-or-to-monitor-left; }
            Mod+Shift+Down  { move-window-down-or-to-workspace-down; }
            Mod+Shift+Up    { move-window-up-or-to-workspace-up; }
            Mod+Shift+Right { move-column-right-or-to-monitor-right; }
            Mod+Shift+H     { move-column-left-or-to-monitor-left; }
            Mod+Shift+J     { move-window-down-or-to-workspace-down; }
            Mod+Shift+K     { move-window-up-or-to-workspace-up; }
            Mod+Shift+L     { move-column-right-or-to-monitor-right; }

            Mod+Home { focus-column-first; }
            Mod+End  { focus-column-last; }
            Mod+Ctrl+Home { move-column-to-first; }
            Mod+Ctrl+End  { move-column-to-last; }

            // TODO monitor bindings
            // Mod+Shift+Left  { focus-monitor-left; }
            // Mod+Shift+Down  { focus-monitor-down; }
            // Mod+Shift+Up    { focus-monitor-up; }
            // Mod+Shift+Right { focus-monitor-right; }
            // Mod+Shift+H     { focus-monitor-left; }
            // Mod+Shift+J     { focus-monitor-down; }
            // Mod+Shift+K     { focus-monitor-up; }
            // Mod+Shift+L     { focus-monitor-right; }

            // Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
            // Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
            // Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
            // Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
            // Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
            // Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
            // Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
            // Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

            // TODO workspace bindings
            Mod+Page_Down      { focus-workspace-down; }
            Mod+Page_Up        { focus-workspace-up; }
            Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
            Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }

            Mod+Shift+Page_Down { move-workspace-down; }
            Mod+Shift+Page_Up   { move-workspace-up; }
            Mod+Shift+U         { move-workspace-down; }
            Mod+Shift+I         { move-workspace-up; }

            // TODO keep?
            Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
            Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
            Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
            Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

            Mod+WheelScrollRight      { focus-column-right; }
            Mod+WheelScrollLeft       { focus-column-left; }
            Mod+Ctrl+WheelScrollRight { move-column-right; }
            Mod+Ctrl+WheelScrollLeft  { move-column-left; }

            // Usually scrolling up and down with Shift in applications results in
            // horizontal scrolling; these binds replicate that.
            Mod+Shift+WheelScrollDown      { focus-column-right; }
            Mod+Shift+WheelScrollUp        { focus-column-left; }
            Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
            Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

            // Similarly, you can bind touchpad scroll "ticks".
            // Touchpad scrolling is continuous, so for these binds it is split into
            // discrete intervals.
            // These binds are also affected by touchpad's natural-scroll, so these
            // example binds are "inverted", since we have natural-scroll enabled for
            // touchpads by default.
            // Mod+TouchpadScrollDown { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+"; }
            // Mod+TouchpadScrollUp   { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-"; }

            // You can refer to workspaces by index. However, keep in mind that
            // niri is a dynamic workspace system, so these commands are kind of
            // "best effort". Trying to refer to a workspace index bigger than
            // the current workspace count will instead refer to the bottommost
            // (empty) workspace.
            //
            // For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
            // will all refer to the 3rd workspace.
            Mod+1 { focus-workspace 1; }
            Mod+2 { focus-workspace 2; }
            Mod+3 { focus-workspace 3; }
            Mod+4 { focus-workspace 4; }
            Mod+5 { focus-workspace 5; }
            Mod+6 { focus-workspace 6; }
            Mod+7 { focus-workspace 7; }
            Mod+8 { focus-workspace 8; }
            Mod+9 { focus-workspace 9; }
            Mod+Shift+1 { move-column-to-workspace 1; }
            Mod+Shift+2 { move-column-to-workspace 2; }
            Mod+Shift+3 { move-column-to-workspace 3; }
            Mod+Shift+4 { move-column-to-workspace 4; }
            Mod+Shift+5 { move-column-to-workspace 5; }
            Mod+Shift+6 { move-column-to-workspace 6; }
            Mod+Shift+7 { move-column-to-workspace 7; }
            Mod+Shift+8 { move-column-to-workspace 8; }
            Mod+Shift+9 { move-column-to-workspace 9; }

            // Example volume keys mappings for PipeWire & WirePlumber.
            // The allow-when-locked=true property makes them work even when the session is locked.
            XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
            XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
            XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
            XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

            XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "set" "-c" "backlight" "10%+"; }
            XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "-c" "backlight" "10%-"; }
            XF86KbdBrightnessUp allow-when-locked=true { spawn "brightnessctl" "set" "-d" "*::kbd_backlight" "10%+"; }
            XF86KbdBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "-d" "*::kbd_backlight" "10%-"; }
        }
      '';
    };
}
