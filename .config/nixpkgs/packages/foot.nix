{ pkgs
, config
, lib
, ...
}:
let
  colors = config.colorScheme.colors; in
{
  options = with lib; {
    packageSets.foot.enable = mkOption {
      type = types.bool;
      description = "Whether or not to install and configure foot";
      default = false;
    };
  };

  config = lib.mkIf config.packageSets.foot.enable {
    packageSets.fonts.enable = true;

    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "${config.packageSets.fonts.default}:size=7";
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
  };
}
