{ config
, ...
}:
let
  colorScheme = config.colorScheme; in
{
  programs.fzf = {
    enable = true;
    colors = {
      "bg+" = "#${colorScheme.colors.base01}";
      "bg" = "#${colorScheme.colors.base00}";
      "spinner" = "#${colorScheme.colors.base0C}";
      "hl" = "#${colorScheme.colors.base0D}";
      "fg" = "#${colorScheme.colors.base04}";
      "header" = "#${colorScheme.colors.base0D}";
      "info" = "#${colorScheme.colors.base0A}";
      "pointer" = "#${colorScheme.colors.base0C}";
      "marker" = "#${colorScheme.colors.base0C}";
      "fg+" = "#${colorScheme.colors.base06}";
      "prompt" = "#${colorScheme.colors.base0A}";
      "hl+" = "#${colorScheme.colors.base0D}";
    };
  };
}
