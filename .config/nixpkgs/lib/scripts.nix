{ pkgs, lib, config, ... }:

let
  convertScriptsToPackages = scriptsAttrList: (map (key: (pkgs.writeShellScriptBin key scriptsAttrList."${key}")) (builtins.attrNames scriptsAttrList));
in
{
  options = with lib; {
    bun.shellScripts = mkOption {
      type = with types; attrsOf string;
      description = "Scripts to add to the PATH";
      default = [ ];
    };
  };

  config = {
    home.packages = convertScriptsToPackages config.bun.shellScripts;
  };
}
