{ lib, config, ... }:
{
  options = with lib; {
    bun.search.includeHidden = mkOption {
      type = types.bool;
      description = "Whether or not to include hidden files";
      default = false;
    };

    bun.search.includeGitignored = mkOption {
      type = types.bool;
      description = "Whether or not to include gitignored files";
      default = true;
    };

    bun.search.ignoredPaths = mkOption {
      type = with types; listOf str;
      description = "Paths to ignore when searching";
      default = [ ];
    };

    bun.search.includedPaths = mkOption {
      type = with types; listOf str;
      description = "Paths to include when searching";
      default = [ ];
    };
  };

  config = {
    home.file.".ignore".text = lib.concatStringsSep "\n" (
      lib.concatLists [
        config.bun.search.ignoredPaths
        (map (x: "!" + x) config.bun.search.includedPaths)
      ]
    );

    programs.ripgrep.arguments =
      lib.optionals config.bun.search.includeHidden [ "--hidden" ]
      ++ lib.optionals config.bun.search.includeGitignored [ "--no-ignore-vcs" ];

    programs.fzf = {
      defaultCommand = "fd --type f"
        + lib.optionalString config.bun.search.includeHidden " --hidden"
        + lib.optionalString config.bun.search.includeGitignored " --no-ignore-vcs";
    };

    home.shellAliases.fd = lib.mkIf (config.bun.search.includeHidden || config.bun.search.includeGitignored) (
      "fd"
      + lib.optionalString config.bun.search.includeHidden " --hidden"
      + lib.optionalString config.bun.search.includeGitignored " --no-ignore-vcs"
    );

    bun.search = {
      includeHidden = true;
      includeGitignored = false;
      ignoredPaths = [
        ".git"
      ];
      includedPaths = [
        ".env"
      ];
    };

    home.shellAliases = {
      # easier to remember commands that search everything
      fda = lib.mkIf config.programs.fd.enable "fd --no-ignore --hidden";
      rga = lib.mkIf config.programs.ripgrep.enable "rg --no-ignore --hidden";
    };
  };
}
