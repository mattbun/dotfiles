{ config
, lib
, ...
}:
let
  colorScheme = config.colorScheme;
in
{
  programs.fd.enable = lib.mkIf config.programs.fzf.enable (lib.mkDefault true);

  programs.fzf = {
    defaultCommand = "fd --type f"
      + lib.optionalString config.bun.search.includeHidden " --hidden"
      + lib.optionalString config.bun.search.includeGitignored " --no-ignore-vcs";

    colors = {
      "bg+" = "black";
      "bg" = "-1";
      "spinner" = "${colorScheme.accentAnsi}";
      "hl" = "blue";
      "fg" = "white";
      "header" = "blue";
      "info" = "yellow";
      "pointer" = "${colorScheme.accentAnsi}";
      "marker" = "${colorScheme.accentAnsi}";
      "fg+" = "bright-white";
      "prompt" = "${colorScheme.accentAnsi}";
      "hl+" = "blue";
    };
  };
}
