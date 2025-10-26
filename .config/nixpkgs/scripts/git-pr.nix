{ pkgs, ... }: {
  bun.shellScripts = {
    git-pr = ''
      ${if pkgs.stdenv.isDarwin then "open" else "xdg-open"} "$(git-open --print | sed -e 's|/tree/|/pull/new/|')"
    '';
  };
}
