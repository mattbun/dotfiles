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

  ansiColors = [
    "black"
    "red"
    "green"
    "yellow"
    "blue"
    "magenta"
    "cyan"
    "white"
    "bright-black"
    "bright-red"
    "bright-green"
    "bright-yellow"
    "bright-blue"
    "bright-magenta"
    "bright-cyan"
    "bright-white"
  ];
in
{
  options = with lib; {
    colorScheme = let palette = config.colorScheme.palette; in {
      system = mkOption { type = enum [ "base16" "base24" ]; };

      slug = mkOption { type = str; };
      name = mkOption {
        type = str;
        default = config.colorScheme.slug;
      };

      accent = mkOption {
        type = enum (ansiColors ++ [
          # These don't have ansi equivalents so they'll be switched to a different color there
          "orange"
          "brown"
        ]);
        default = "white";
      };

      accentAnsi = mkOption {
        type = enum ansiColors;
        default = let accent = config.colorScheme.accent; in
          if accent == "orange" then "yellow" else if accent == "brown" then "red" else accent;
      };

      accentBrightAnsi = mkOption {
        type = enum ansiColors;
        default = "bright-${config.colorScheme.accentAnsi}";
      };

      accentColor = mkOption {
        type = hexColor;
        default = palette."${config.colorScheme.accent}";
      };

      accentBrightColor = mkOption {
        type = hexColor;
        default = palette."${config.colorScheme.accentBrightAnsi}";
      };

      accentIsAnsi = mkOption {
        type = bool;
        default = (config.colorScheme.accent != "orange" && config.colorScheme.accent != "brown");
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
        base0E = mkOption { type = hexColor; }; # magenta
        base0F = mkOption { type = hexColor; }; # brown

        # # base24
        base10 = mkOption { type = hexColor; default = palette.base00; }; # darker background
        base11 = mkOption { type = hexColor; default = palette.base00; }; # darkest background
        base12 = mkOption { type = hexColor; default = palette.base08; }; # bright red
        base13 = mkOption { type = hexColor; default = palette.base0A; }; # bright yellow
        base14 = mkOption { type = hexColor; default = palette.base0B; }; # bright green
        base15 = mkOption { type = hexColor; default = palette.base0C; }; # bright cyan
        base16 = mkOption { type = hexColor; default = palette.base0D; }; # bright blue
        base17 = mkOption { type = hexColor; default = palette.base0E; }; # bright magenta

        # ANSI
        ansi00 = mkOption { type = hexColor; default = palette.base01; }; # black
        ansi01 = mkOption { type = hexColor; default = palette.base08; }; # red
        ansi02 = mkOption { type = hexColor; default = palette.base0B; }; # green
        ansi03 = mkOption { type = hexColor; default = palette.base0A; }; # yellow
        ansi04 = mkOption { type = hexColor; default = palette.base0D; }; # blue
        ansi05 = mkOption { type = hexColor; default = palette.base0E; }; # magenta
        ansi06 = mkOption { type = hexColor; default = palette.base0C; }; # cyan
        ansi07 = mkOption { type = hexColor; default = palette.base05; }; # white
        ansi08 = mkOption { type = hexColor; default = palette.base04; }; # bright black
        ansi09 = mkOption { type = hexColor; default = palette.base12; }; # bright red
        ansi10 = mkOption { type = hexColor; default = palette.base14; }; # bright green
        ansi11 = mkOption { type = hexColor; default = palette.base13; }; # bright yellow
        ansi12 = mkOption { type = hexColor; default = palette.base16; }; # bright blue
        ansi13 = mkOption { type = hexColor; default = palette.base17; }; # bright magenta
        ansi14 = mkOption { type = hexColor; default = palette.base15; }; # bright cyan
        ansi15 = mkOption { type = hexColor; default = palette.base07; }; # bright white

        # Colors
        black = mkOption { type = hexColor; default = palette.ansi00; };
        red = mkOption { type = hexColor; default = palette.ansi01; };
        green = mkOption { type = hexColor; default = palette.ansi02; };
        yellow = mkOption { type = hexColor; default = palette.ansi03; };
        blue = mkOption { type = hexColor; default = palette.ansi04; };
        magenta = mkOption { type = hexColor; default = palette.ansi05; };
        cyan = mkOption { type = hexColor; default = palette.ansi06; };
        white = mkOption { type = hexColor; default = palette.ansi07; };
        bright-black = mkOption { type = hexColor; default = palette.ansi08; };
        bright-red = mkOption { type = hexColor; default = palette.ansi09; };
        bright-green = mkOption { type = hexColor; default = palette.ansi10; };
        bright-yellow = mkOption { type = hexColor; default = palette.ansi11; };
        bright-blue = mkOption { type = hexColor; default = palette.ansi12; };
        bright-magenta = mkOption { type = hexColor; default = palette.ansi13; };
        bright-cyan = mkOption { type = hexColor; default = palette.ansi14; };
        bright-white = mkOption { type = hexColor; default = palette.ansi15; };
        orange = mkOption { type = hexColor; default = palette.base09; };
        brown = mkOption { type = hexColor; default = palette.base0F; };
      };
    };
  };

  config = {
    colorScheme = {
      system = "base24";
      slug = "0x96f";

      palette = basix.schemeData."${config.colorScheme.system}"."${config.colorScheme.slug}".palette;
    };
  };
}
