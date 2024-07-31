{ pkgs
, config
, lib
, ...
}:
let
  colors = config.colorScheme.palette;
in
{
  packageSets.fonts.enable = lib.mkIf config.programs.foot.enable true;

  programs.foot = {
    settings = {
      main = {
        font = "${config.packageSets.fonts.mono}:size=12";
        shell = "${pkgs.tmux}/bin/tmux";
      };
      colors = {
        # https://github.com/tinted-theming/base16-foot/blob/main/templates/default.mustache
        foreground = colors.base05;
        background = colors.base00;
        regular0 = colors.base00; # black
        regular1 = colors.base08; # red
        regular2 = colors.base0B; # green
        regular3 = colors.base0A; # yellow
        regular4 = colors.base0D; # blue
        regular5 = colors.base0E; # magenta
        regular6 = colors.base0C; # cyan
        regular7 = colors.base05; # white
        bright0 = colors.base03; # bright black
        bright1 = colors.base08; # bright red
        bright2 = colors.base0B; # bright green
        bright3 = colors.base0A; # bright yellow
        bright4 = colors.base0D; # bright blue
        bright5 = colors.base0E; # bright magenta
        bright6 = colors.base0C; # bright cyan
        bright7 = colors.base07; # bright white
      };
    };
  };
}
