{ config
, lib
, pkgs
, ...
}: {
  options.programs.stylua.enable = lib.mkEnableOption "stylua";

  config = lib.mkIf config.programs.stylua.enable {
    home.packages = with pkgs; [
      stylua
    ];

    xdg.configFile."stylua/stylua.toml" = {
      text = ''
        indent_type = "Spaces"
        indent_width = 2
      '';
    };
  };
}
