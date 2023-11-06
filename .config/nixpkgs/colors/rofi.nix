{ config
, lib
, ...
}:
let
  colorScheme = config.colorScheme;

  # Use `mkLiteral` for string-like values that should show without
  # quotes, e.g.:
  # {
  #   foo = "abc"; => foo: "abc";
  #   bar = mkLiteral "abc"; => bar: abc;
  # };
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  # based on https://github.com/newmanls/rofi-themes-collection/blob/master/themes/squared-material-red.rasi
  programs.rofi.theme = lib.mkIf config.packageSets.sway.enable {
    "*" = {
      bg0 = mkLiteral "#${colorScheme.colors.base00}";
      fg0 = mkLiteral "#${colorScheme.colors.base06}";
      accent-color = mkLiteral "#${colorScheme.accentColor}";
      urgent-color = mkLiteral "#${colorScheme.colors.base08}";

      background-color = mkLiteral "transparent";
      text-color = mkLiteral "@fg0";

      margin = 0;
      padding = 0;
      spacing = 0;
    };

    window = {
      location = mkLiteral "center";
      width = 512;
      background-color = mkLiteral "@bg0";
    };

    inputbar = {
      spacing = mkLiteral "8px";
      padding = mkLiteral "8px";
      background-color = mkLiteral "@bg0";
    };

    "prompt, entry, element-icon, element-text" = {
      vertical-align = mkLiteral "0.5";
    };

    prompt = {
      text-color = mkLiteral "@accent-color";
    };

    textbox = {
      padding = mkLiteral "8px";
      background-color = mkLiteral "@bg0";
    };

    listview = {
      padding = mkLiteral "4px 0";
      lines = 8;
      columns = 1;
      fixed-height = false;
    };

    element = {
      padding = mkLiteral "8px";
      spacing = mkLiteral "8px";
    };

    "element normal normal" = {
      text-color = mkLiteral "@fg0";
    };

    "element normal urgent" = {
      text-color = mkLiteral "@urgent-color";
    };

    "element normal active" = {
      text-color = mkLiteral "@accent-color";
    };

    "element selected" = {
      text-color = mkLiteral "@fg0";
    };

    "element selected normal, element selected active" = {
      background-color = mkLiteral "@accent-color";
    };

    "element selected urgent" = {
      background-color = mkLiteral "@accent-color";
    };

    "element-icon" = {
      size = mkLiteral "0.8em";
    };

    "element-text" = {
      text-color = mkLiteral "inherit";
    };
  };
}
