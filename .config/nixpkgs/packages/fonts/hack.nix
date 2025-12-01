{ pkgs
, config
, lib
, ...
}: {
  options.fonts.hack.enable = lib.mkEnableOption "hack font";

  config = lib.mkIf config.fonts.hack.enable {
    home.packages = with pkgs; [
      nerd-fonts.hack
    ];
  };
}
