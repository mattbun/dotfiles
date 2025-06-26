{ config
, ...
}:
let
  colorScheme = config.colorScheme;
in
{
  programs.fzf = {
    colors = {
      "bg+" = "black";
      "bg" = "-1";
      "spinner" = "${colorScheme.accentAnsi}";
      "hl" = "blue";
      "fg" = "white";
      "header" = "blue";
      "info" = "yellow";
      "pointer" = "${colorScheme.accentAnsi}";
      "marker" = "${colorScheme.accentAnsi}";
      "fg+" = "bright-white";
      "prompt" = "${colorScheme.accentAnsi}";
      "hl+" = "blue";
    };
  };
}
