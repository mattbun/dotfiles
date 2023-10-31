{ pkgs
, config
, lib
, ...
}: {
  options = with lib; {
    packageSets.fonts = {
      enable = mkOption {
        type = types.bool;
        description = "Whether or not to install and configure fonts";
        default = false;
      };

      default = mkOption {
        type = types.str;
        description = "The name of the font to use as the default";
        default = "Hack Nerd Font";
      };
    };
  };

  config = lib.mkIf config.packageSets.fonts.enable {
    fonts.fontconfig.enable = true; # pro-tip: see fonts with `fc-list`

    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };
}
