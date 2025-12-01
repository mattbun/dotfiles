{ config, lib, ... }:

{
  services.mako.settings = {
    font = "${lib.head config.fonts.fontconfig.defaultFonts.monospace} 12";
    background-color = "#${config.colorScheme.palette.base00}FF";
    border-color = "#${config.colorScheme.accentColor}FF";
    progress-color = "#${config.colorScheme.palette.base01}FF"; # notify-send -t 2500 "25%" -h "int:value:25"

    default-timeout = 5000;
  };
}
