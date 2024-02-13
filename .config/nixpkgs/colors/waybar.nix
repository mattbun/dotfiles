{ config
, lib
, ...
}:
let
  colorScheme = config.colorScheme;
in
{
  programs.waybar.style = lib.mkIf config.packageSets.sway.enable ''
    * {
        border: none;
        border-radius: 0;
        font-family: ${config.packageSets.fonts.default}, Roboto, Helvetica, Arial, sans-serif;
        font-size: 16px;
        min-height: 0;
        color: #${colorScheme.palette.base07};
    }

    window#waybar {
        background: #${colorScheme.palette.base00};
        opacity: 1;
        color: #${colorScheme.palette.base07};
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
        background: transparent;
        color: #${colorScheme.palette.base07};
    }

    #workspaces button.focused {
        background: #${colorScheme.accentColor};
    }

    #mode, #clock, #battery, #tray, #cpu, #memory, #disk, #pulseaudio, #custom-userhostname, #network, #bluetooth, #idle_inhibitor {
        padding: 0 10px;
    }

    #mode {
        background: #${colorScheme.palette.base01};
    }

    #idle_inhibitor {
        background-color: #${colorScheme.palette.base0F};
    }

    #pulseaudio {
        background-color: #${colorScheme.palette.base09};
    }

    #disk {
        background-color: #${colorScheme.palette.base0B};
    }

    #network {
        background-color: #${colorScheme.palette.base0E};
    }

    #bluetooth {
        background-color: #${colorScheme.palette.base0C};
    }

    #memory {
        background-color: #${colorScheme.palette.base0D};
    }

    #cpu {
        background-color: #${colorScheme.palette.base08};
    }

    #clock.date {
        background-color: #${colorScheme.palette.base02};
    }

    #clock.time {
        background-color: #${colorScheme.palette.base01};
    }

    #custom-userhostname {
        background-color: #${colorScheme.palette.base00};
    }

    #taskbar button {
        background-color: #${colorScheme.palette.base01};
    }

    #taskbar button.active {
        background-color: #${colorScheme.palette.base02};
    }
  '';
}
