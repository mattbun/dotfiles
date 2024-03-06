{ config, ... }:

{
  services.mako = {
    font = "${config.packageSets.fonts.default} 12";
    backgroundColor = "#${config.colorScheme.palette.base00}FF";
    borderColor = "#${config.colorScheme.accentColor}FF";
    progressColor = "#${config.colorScheme.palette.base01}FF"; # notify-send -t 2500 "25%" -h "int:value:25"
  };
}
