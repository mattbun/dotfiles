{ config, ... }:

let
  palette = config.colorScheme.palette;
  themeName = "nix-${config.colorScheme.slug}";
in
{
  programs.helix = {
    settings = {
      theme = themeName;
    };
    themes = {
      "${themeName}" = {
        inherits = "base16_default_dark";
        palette = {
          # TODO default = "#${}";
          black = "#${palette.ansi00}";
          red = "#${palette.ansi01}";
          green = "#${palette.ansi02}";
          yellow = "#${palette.ansi03}";
          blue = "#${palette.ansi04}";
          magenta = "#${palette.ansi05}";
          cyan = "#${palette.ansi06}";
          gray = "#${palette.ansi07}";
          light-red = "#${palette.ansi08}";
          light-green = "#${palette.ansi09}";
          light-yellow = "#${palette.ansi10}";
          light-blue = "#${palette.ansi11}";
          light-magenta = "#${palette.ansi12}";
          light-cyan = "#${palette.ansi13}";
          light-gray = "#${palette.ansi14}";
          white = "#${palette.ansi15}";

          base00 = "#${palette.base00}";
          base01 = "#${palette.base01}";
          base02 = "#${palette.base02}";
          base03 = "#${palette.base03}";
          base04 = "#${palette.base04}";
          base05 = "#${palette.base05}";
          base06 = "#${palette.base06}";
          base07 = "#${palette.base07}";
          base08 = "#${palette.base08}";
          base09 = "#${palette.base09}";
          base0A = "#${palette.base0A}";
          base0B = "#${palette.base0B}";
          base0C = "#${palette.base0C}";
          base0D = "#${palette.base0D}";
          base0E = "#${palette.base0E}";
          base0F = "#${palette.base0F}";
        };
        "ui.gutter".bg = "#${palette.base00}";
        "ui.linenr".bg = "#${palette.base00}";
        "ui.linenr".fg = "#${palette.base03}";
        "ui.linenr.selected".bg = "#${palette.base00}";
      };
    };
  };
}
