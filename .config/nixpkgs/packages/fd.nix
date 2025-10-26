{ config
, lib
, ...
}: {
  home.shellAliases = lib.mkIf config.programs.fd.enable {
    fda = lib.mkIf config.programs.fd.enable "fd --no-ignore --hidden";
  };

  programs.fd = {
    extraOptions = [
      (lib.mkIf config.bun.search.includeHidden "--hidden")
      (lib.mkIf config.bun.search.includeGitignored "--no-ignore-vcs")
    ];
  };
}
