{ config
, ...
}:
let
  colorScheme = config.colorScheme;
in
{
  # This won't be applied automatically, you'll need to manually import this theme in blink.
  # Based on https://github.com/niklaas/base16-blink/blob/master/templates/default.mustache
  xdg.configFile."colors/blink.js".text = ''
    base00 = '#${colorScheme.palette.base00}';
    base01 = '#${colorScheme.palette.base01}';
    base02 = '#${colorScheme.palette.base02}';
    base03 = '#${colorScheme.palette.base03}';
    base04 = '#${colorScheme.palette.base04}';
    base05 = '#${colorScheme.palette.base05}';
    base06 = '#${colorScheme.palette.base06}';
    base07 = '#${colorScheme.palette.base07}';
    base08 = '#${colorScheme.palette.base08}';
    base09 = '#${colorScheme.palette.base09}';
    base0A = '#${colorScheme.palette.base0A}';
    base0B = '#${colorScheme.palette.base0B}';
    base0C = '#${colorScheme.palette.base0C}';
    base0D = '#${colorScheme.palette.base0D}';
    base0E = '#${colorScheme.palette.base0E}';
    base0F = '#${colorScheme.palette.base0F}';

    t.prefs_.set(
      'color-palette-overrides', 
      [
        base00,
        base08,
        base0B,
        base0A,
        base0D,
        base0E,
        base0C,
        base05,
        base03,
        base08,
        base0B,
        base0A,
        base0D,
        base0E,
        base0C,
        base07,
        base09,
        base0F,
        base01,
        base02,
        base04,
        base06,
      ]
    );

    t.prefs_.set('cursor-color', `''${base05}80`); // 80 makes it rgba and 50% opacity
    t.prefs_.set('foreground-color', base05);
    t.prefs_.set('background-color', base00);
  '';
}
