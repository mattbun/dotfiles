{ config
, lib
, ...
}: {
  home.shellAliases = lib.mkIf config.programs.ripgrep.enable {
    rga = lib.mkIf config.programs.ripgrep.enable "rg --no-ignore --hidden";
  };

  programs.ripgrep = {
    arguments = [
      # "Searches case insensitively if the pattern is all lowercase. Search case sensitively otherwise."
      "--smart-case"

      (lib.mkIf config.bun.search.includeHidden "--hidden")
      (lib.mkIf config.bun.search.includeGitignored "--no-ignore-vcs")
    ];
  };
}
