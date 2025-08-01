{ config, pkgs, ... }:

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
  programs.rofi = {
    package = pkgs.rofi-wayland;
    font = "${config.packageSets.fonts.default} 12";
    plugins = with pkgs; [
      rofi-calc # TODO doesn't work with keybinding
    ];
    extraConfig = {
      modi = "drun,run,ssh,combi";
      hover-select = true;
      click-to-exit = true; # TODO doesn't work https://github.com/lbonn/rofi/issues/22

      # Select menu items with one click
      me-select-entry = "MousePrimary";
      me-accept-entry = "!MousePrimary";
    };

    # based on https://github.com/newmanls/rofi-themes-collection/blob/master/themes/squared-material-red.rasi
    theme = {
      "*" = {
        bg0 = mkLiteral "#${colorScheme.palette.base00}";
        fg0 = mkLiteral "#${colorScheme.palette.base06}";
        accent-color = mkLiteral "#${colorScheme.accentColor}";
        urgent-color = mkLiteral "#${colorScheme.palette.base08}";

        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";

        margin = 0;
        padding = 0;
        spacing = 0;
      };

      window = {
        width = 512;
        background-color = mkLiteral "@bg0";
        border = 1;
        border-color = mkLiteral "@accent-color";
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
        text-color = mkLiteral "@bg0";
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
  };
}
