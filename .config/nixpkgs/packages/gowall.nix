{ config
, lib
, pkgs
, ...
}:
let
  colorScheme = config.colorScheme;
in
{
  options.programs.gowall.enable = lib.mkEnableOption "gowall";

  config = lib.mkIf config.programs.gowall.enable {
    home.packages = with pkgs; [
      gowall
    ];

    xdg.configFile."gowall/config.yml".text = builtins.toJSON {
      themes = [{
        name = "nix-${colorScheme.slug}";
        colors = [
          "#${colorScheme.palette.base00}"
          "#${colorScheme.palette.base01}"
          "#${colorScheme.palette.base02}"
          "#${colorScheme.palette.base03}"
          "#${colorScheme.palette.base04}"
          "#${colorScheme.palette.base05}"
          "#${colorScheme.palette.base06}"
          "#${colorScheme.palette.base07}"
          "#${colorScheme.palette.base08}"
          "#${colorScheme.palette.base09}"
          "#${colorScheme.palette.base0A}"
          "#${colorScheme.palette.base0B}"
          "#${colorScheme.palette.base0C}"
          "#${colorScheme.palette.base0D}"
          "#${colorScheme.palette.base0E}"
          "#${colorScheme.palette.base0F}"
        ];
      }];
    };
  };
}
