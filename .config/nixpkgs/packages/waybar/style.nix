{ config
, lib
, ...
}:
let
  colorScheme = config.colorScheme;
in
{
  programs.waybar.style = ''
    * {
        border: none;
        border-radius: 0;
        font-family: ${lib.head config.fonts.fontconfig.defaultFonts.proportional}, Roboto, Helvetica, Arial, sans-serif;
        font-size: 16px;
        min-height: 0;
        color: #${colorScheme.palette.base07};
    }

    window#waybar {
        background: #${colorScheme.palette.base00};
        opacity: 1;
    }

    tooltip {
      background: #${colorScheme.palette.base00};
      border: 1px solid #${colorScheme.accentColor};
    }

    tooltip label {
      color: #${colorScheme.palette.base07};
    }

    #workspaces button {
        padding: 0 5px;
        background: #${colorScheme.palette.base02};
    }

    #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
    }

    #workspaces button.visible {
        border: 2px solid #${colorScheme.accentColor};
    }

    #workspaces button.focused {
        background: #${colorScheme.accentColor};
    }

    #workspaces button.focused label {
        color: #${colorScheme.palette.base02};
    }

    #mode, #clock, #battery, #tray, #cpu, #memory, #disk, #pulseaudio, #custom-userhostname, #network, #bluetooth, #idle_inhibitor, #mpris {
        padding: 0 10px;
        background-color: #${colorScheme.palette.base01};
    }

    #mode {
        background: #${colorScheme.palette.base02};
    }

    #idle_inhibitor {
        background-color: #${colorScheme.palette.brown};
    }

    #tray {
        background-color: #${colorScheme.palette.base01};
    }

    #mpris.playing {
        color: #${colorScheme.palette.yellow};
    }

    #battery.critical {
      color: #${config.colorScheme.palette.red};
    }

    #battery.charging {
      color: #${config.colorScheme.palette.yellow};
    }

    #pulseaudio {
        color: #${colorScheme.palette.orange};
    }

    #disk {
        background-color: #${colorScheme.palette.green};
    }

    #network {
        color: #${colorScheme.palette.magenta};
    }

    #bluetooth {
        color: #${colorScheme.palette.cyan};
    }

    #pulseaudio.muted, #bluetooth.disabled, #bluetooth.off, #network.disabled, #network.disconnected {
        color: #${colorScheme.palette.base07};
    }

    #memory {
        color: #${colorScheme.palette.blue};
    }

    #cpu {
        color: #${colorScheme.palette.red};
    }

    #clock.date, #clock.time {
        background-color: #${colorScheme.palette.base02};
    }

    #custom-userhostname {
      background-color: #${colorScheme.accentColor};
      color: #${colorScheme.palette.base00};
    }

    #taskbar button {
        background-color: #${colorScheme.palette.base01};
    }

    #taskbar button.active {
        background-color: #${colorScheme.palette.base02};
    }

    #window {
        background-color: #${colorScheme.palette.base01};
        padding: 0 10px;
    }

    window#waybar.empty #window {
        background-color: #${colorScheme.palette.base00};
        padding: 0 0;
    }
  '';
}
