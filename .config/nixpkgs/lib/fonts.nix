{ lib, ... }: {
  options = with lib; {
    fonts.fontconfig.defaultFonts.proportional = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "The name of the font to use as the default proportional monospace font";
    };
  };
}
