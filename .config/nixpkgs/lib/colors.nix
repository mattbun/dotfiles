{ lib
, config
, basix
, ...
}:
with lib;
with types;
let
  hexColor = (coercedTo str (removePrefix "#") (mkOptionType {
    name = "hex-color";
    descriptionClass = "noun";
    description = "RGB color in hex format";
    check = x: isString x && !(hasPrefix "#" x);
  }));
in
{
  options = with lib; {
    colorScheme = let palette = config.colorScheme.palette; in {
      name = mkOption { type = str; };
      slug = mkOption { type = str; };

      accentColor = mkOption {
        type = hexColor;
        description = "Accent color to use in a few places";
        default = palette.base04;
      };

      palette = {
        base00 = mkOption { type = hexColor; }; # ---- (background)
        base01 = mkOption { type = hexColor; }; # ---  (lighter background)
        base02 = mkOption { type = hexColor; }; # --   (selection background)
        base03 = mkOption { type = hexColor; }; # -    (comments)
        base04 = mkOption { type = hexColor; }; # +    (dark foreground)
        base05 = mkOption { type = hexColor; }; # ++   (foreground)
        base06 = mkOption { type = hexColor; }; # +++  (light foreground)
        base07 = mkOption { type = hexColor; }; # ++++ (bright white)
        base08 = mkOption { type = hexColor; }; # red
        base09 = mkOption { type = hexColor; }; # orange
        base0A = mkOption { type = hexColor; }; # yellow
        base0B = mkOption { type = hexColor; }; # green
        base0C = mkOption { type = hexColor; }; # cyan
        base0D = mkOption { type = hexColor; }; # blue
        base0E = mkOption { type = hexColor; }; # purple
        base0F = mkOption { type = hexColor; }; # brown

        # # base24
        base10 = mkOption { type = hexColor; default = palette.base00; }; # darker background
        base11 = mkOption { type = hexColor; default = palette.base00; }; # darkest background
        base12 = mkOption { type = hexColor; default = palette.base08; }; # bright red
        base13 = mkOption { type = hexColor; default = palette.base0A; }; # bright yellow
        base14 = mkOption { type = hexColor; default = palette.base0B; }; # bright green
        base15 = mkOption { type = hexColor; default = palette.base0C; }; # bright cyan
        base16 = mkOption { type = hexColor; default = palette.base0D; }; # bright blue
        base17 = mkOption { type = hexColor; default = palette.base0E; }; # bright purple

        # ANSI
        ansi00 = mkOption { type = hexColor; default = palette.base01; }; # black
        ansi01 = mkOption { type = hexColor; default = palette.base08; }; # red
        ansi02 = mkOption { type = hexColor; default = palette.base0B; }; # green
        ansi03 = mkOption { type = hexColor; default = palette.base0A; }; # yellow
        ansi04 = mkOption { type = hexColor; default = palette.base0D; }; # blue
        ansi05 = mkOption { type = hexColor; default = palette.base0E; }; # purple
        ansi06 = mkOption { type = hexColor; default = palette.base0C; }; # cyan
        ansi07 = mkOption { type = hexColor; default = palette.base05; }; # white
        ansi08 = mkOption { type = hexColor; default = palette.base03; }; # bright black
        ansi09 = mkOption { type = hexColor; default = palette.base12; }; # bright red
        ansi10 = mkOption { type = hexColor; default = palette.base14; }; # bright green
        ansi11 = mkOption { type = hexColor; default = palette.base13; }; # bright yellow
        ansi12 = mkOption { type = hexColor; default = palette.base16; }; # bright blue
        ansi13 = mkOption { type = hexColor; default = palette.base17; }; # bright purple
        ansi14 = mkOption { type = hexColor; default = palette.base15; }; # bright cyan
        ansi15 = mkOption { type = hexColor; default = palette.base07; }; # bright white
      };
    };
  };

  config = {
    colorScheme = {
      slug = "helios";
      name = "helios";
      palette = basix.schemeData.base16.helios.palette;
    };
  };
}
