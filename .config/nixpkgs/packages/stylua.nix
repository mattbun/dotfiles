{ config
, lib
, ...
}: {
  options.programs.stylua.enable = lib.mkEnableOption "stylua";

  config = lib.mkIf config.programs.stylua.enable {
    xdg.configFile."stylua/stylua.toml" = {
      text = ''
        indent_type = "Spaces"
        indent_width = 2
      '';
    };
  };
}
