{ pkgs
, config
, lib
, ...
}:
let
  colors = config.colorScheme.palette;
in
{
  fonts.fontconfig.enable = lib.mkIf config.programs.foot.enable true;

  programs.foot = {
    settings = {
      main = {
        font = "${lib.head config.fonts.fontconfig.defaultFonts.monospace}:size=12";
        shell = "${pkgs.tmux}/bin/tmux";
      };
      colors = {
        # https://github.com/tinted-theming/base16-foot/blob/main/templates/default.mustache
        foreground = colors.base05;
        background = colors.base00;
        regular0 = colors.ansi00; # black
        regular1 = colors.ansi01; # red
        regular2 = colors.ansi02; # green
        regular3 = colors.ansi03; # yellow
        regular4 = colors.ansi04; # blue
        regular5 = colors.ansi05; # magenta
        regular6 = colors.ansi06; # cyan
        regular7 = colors.ansi07; # white
        bright0 = colors.ansi08; # bright black
        bright1 = colors.ansi09; # bright red
        bright2 = colors.ansi10; # bright green
        bright3 = colors.ansi11; # bright yellow
        bright4 = colors.ansi12; # bright blue
        bright5 = colors.ansi13; # bright magenta
        bright6 = colors.ansi14; # bright cyan
        bright7 = colors.ansi15; # bright white
      };
    };
  };
}
