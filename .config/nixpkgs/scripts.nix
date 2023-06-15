{ pkgs, lib, config, ... }:

let
  convertScriptsToPackages = scriptsAttrList: (map (key: (pkgs.writeShellScriptBin key scriptsAttrList."${key}")) (builtins.attrNames scriptsAttrList));
in
{
  options = with lib; {
    additionalScripts = mkOption {
      type = with types; attrsOf string;
      description = "List of additional scripts";
      default = [ ];
    };
  };

  config = {
    home.packages = (convertScriptsToPackages {
      nxx = ''
        # Creates a nix-shell with the first argument as package and command to run.
        # Example: `nxx htop`
        nix-shell -p $1 --command "$1 ''${@:2}"
      '';

      nfx = ''
        # Creates a nix shell with the first argument as package and command to run.
        # Example: `nfx htop`
        nix shell nixpkgs#$1 --command $1 ''${@:2}
      '';

      nixify = ''
        if [ ! -e ./.envrc ]; then
          echo "use nix" > .envrc
          direnv allow
        fi

        if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
          cat > shell.nix <<'EOF'
        with import <nixpkgs> {};
        mkShell {
          nativeBuildInputs = [
            bashInteractive
          ];
        }
        EOF
          ''${EDITOR:-vim} shell.nix
        fi
      '';

      flakify = ''
        if [ ! -d .git ]; then
          git init
        fi

        if [ ! -e flake.nix ]; then
          nix flake new -t github:nix-community/nix-direnv .
          direnv allow
        elif [ ! -e .envrc ]; then
          echo "use flake" > .envrc
          direnv allow
        fi

        ''${EDITOR:-vim} flake.nix
      '';

      git-pr = ''
        ${if pkgs.stdenv.isDarwin then "open" else "xdg-open"} "$(git-open --print | sed -e 's|/tree/|/pull/new/|')"
      '';
    }) ++ (convertScriptsToPackages config.additionalScripts);
  };
}
