{ config
, pkgs
, lib
, ...
}:
let
  palette = config.colorScheme.palette;
in
lib.mkIf config.programs.ghostty.enable {
  programs.ghostty = {
    settings = {
      command = "${pkgs.tmux}/bin/tmux";

      mouse-hide-while-typing = true;

      macos-option-as-alt = true;
      keybind = [
        "alt+arrow_left=unbind"
        "alt+arrow_right=unbind"
      ];

      font-thicken = true;
      font-family = lib.head config.fonts.fontconfig.defaultFonts.monospace;
      font-size = "12.0";

      background = "${palette.base00}";
      foreground = "${palette.base07}";
      cursor-color = "${palette.base07}";
      cursor-text = "${palette.base00}";
      cursor-style = "block";
      shell-integration-features = "no-cursor";
      palette = [
        "0=${palette.ansi00}"
        "1=${palette.ansi01}"
        "2=${palette.ansi02}"
        "3=${palette.ansi03}"
        "4=${palette.ansi04}"
        "5=${palette.ansi05}"
        "6=${palette.ansi06}"
        "7=${palette.ansi07}"
        "8=${palette.ansi08}"
        "9=${palette.ansi09}"
        "10=${palette.ansi10}"
        "11=${palette.ansi11}"
        "12=${palette.ansi12}"
        "13=${palette.ansi13}"
        "14=${palette.ansi14}"
        "15=${palette.ansi15}"
      ];
    };
  };
}
