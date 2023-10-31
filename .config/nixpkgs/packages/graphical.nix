{ pkgs
, config
, lib
, ...
}: {
  options = with lib; {
    packageSets.graphical = mkOption {
      type = types.bool;
      description = "Whether or not to install graphical packages";
      default = false;
    };
  };

  config = lib.mkIf config.packageSets.graphical {
    packageSets.fonts.enable = true;

    home.packages = with pkgs; [
      alacritty
    ];

    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal = {
            family = config.packageSets.fonts.default;
          };
          size = 13.0;
        };
        selection = {
          save_to_clipboard = true;
        };
        shell = {
          program = "${pkgs.tmux}/bin/tmux";
        };
      };
    };

  };
}
