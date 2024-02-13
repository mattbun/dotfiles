{ config
, ...
}:
let
  colorScheme = config.colorScheme;
in
{
  programs.fzf = {
    enable = true;
    colors = {
      "bg+" = "#${colorScheme.palette.base01}";
      "bg" = "#${colorScheme.palette.base00}";
      "spinner" = "#${colorScheme.palette.base0C}";
      "hl" = "#${colorScheme.palette.base0D}";
      "fg" = "#${colorScheme.palette.base04}";
      "header" = "#${colorScheme.palette.base0D}";
      "info" = "#${colorScheme.palette.base0A}";
      "pointer" = "#${colorScheme.palette.base0C}";
      "marker" = "#${colorScheme.palette.base0C}";
      "fg+" = "#${colorScheme.palette.base06}";
      "prompt" = "#${colorScheme.palette.base0A}";
      "hl+" = "#${colorScheme.palette.base0D}";
    };
  };
}
