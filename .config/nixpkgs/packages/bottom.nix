{ config, lib, pkgs, ... }:

let
  colorScheme = config.colorScheme;

  makeTheme = accent: /* toml */ ''
    [styles.tables.headers]
    color = "${accent}"

    [styles.widgets]
    selected_border_color = "${accent}"
    selected_text = { bg_color = "${accent}" }
  '';

  ansiTheme = makeTheme colorScheme.accentAnsi;
  truecolorTheme = makeTheme "#${colorScheme.accentColor}";
in
lib.mkIf config.programs.bottom.enable
{
  # Make the ansi theme the default if the alias isn't configured
  xdg.configFile."bottom/bottom.toml".text = ansiTheme;

  home.shellAliases = {
    btm = "btm-auto";
  };

  bun.shellScripts = {
    btm-auto = /* bash */ ''
      ARGS="$@"
      ACCENT_IS_ANSI=${lib.boolToString colorScheme.accentIsAnsi}

      if [ "$ACCENT_IS_ANSI" != "true" ] && [ "$COLORTERM" = "truecolor" ]; then
        btm -C ${pkgs.writeText "btm-truecolor.toml" truecolorTheme} $ARGS
      else
        btm -C ${pkgs.writeText "btm-ansi.toml" ansiTheme} $ARGS
      fi
    '';
  };
}
