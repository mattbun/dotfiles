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
        font-family: Hack Nerd Font Mono, Roboto, Helvetica, Arial, sans-serif;
        font-size: 16px;
        min-height: 0;
        color: #${colorScheme.colors.base07};
    }

    window#waybar {
        background: #${colorScheme.colors.base00};
        opacity: 1;
        color: #${colorScheme.colors.base07};
    }

    tooltip {
      background: #${colorScheme.colors.base00};
      border: 1px solid ${config.packageSets.sway.accentColor};
    }

    tooltip label {
      color: #${colorScheme.colors.base07};
    }

    #workspaces button {
        padding: 0 5px;
        background: transparent;
        color: #${colorScheme.colors.base07};
    }

    #workspaces button.focused {
        background: ${config.packageSets.sway.accentColor};
    }

    #mode, #clock, #battery, #tray, #cpu, #memory, #disk, #pulseaudio {
        padding: 0 10px;
    }

    #mode {
        background: #${colorScheme.colors.base01};
    }

    #pulseaudio {
        background-color: #${colorScheme.colors.base09};
    }

    #disk {
        background-color: #${colorScheme.colors.base0B};
    }

    #memory {
        background-color: #${colorScheme.colors.base0D};
    }

    #cpu {
        background-color: #${colorScheme.colors.base08};
    }

    #clock.date {
        background-color: #${colorScheme.colors.base02};
    }

    #clock.time {
        background-color: #${colorScheme.colors.base01};
    }

    #custom-userhostname {
        background-color: #${colorScheme.colors.base00};
    }
  '';
}
