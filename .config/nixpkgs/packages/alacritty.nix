{ pkgs
, config
, lib
, ...
}: {
  options = with lib; {
    packageSets.alacritty.enable = mkOption {
      type = types.bool;
      description = "Whether or not to install and configure alacritty";
      default = false;
    };
  };

  config = lib.mkIf config.packageSets.alacritty.enable {
    packageSets.fonts.enable = true;

    home.packages = with pkgs; [
      alacritty
    ];

    programs.alacritty = {
      enable = true;
      settings = {
        env = {
          TERM = "xterm-256color";
        };
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
