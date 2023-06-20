{ pkgs, lib, config, ... }:

let
  convertScriptsToPackages = scriptsAttrList: (map (key: (pkgs.writeShellScriptBin key scriptsAttrList."${key}")) (builtins.attrNames scriptsAttrList));
in
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
      type = with types; listOf string;
      description = "Paths to add to ~/.ignore";
      default = [ ];
    };
  };

  config = {
    home.file.".ignore".text = lib.concatStringsSep "\n" config.bun.search.ignoredPaths;

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
  };
}
