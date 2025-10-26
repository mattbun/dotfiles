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
  };
}
