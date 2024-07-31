{ config
, lib
, ...
}:
lib.mkIf config.programs.direnv.enable {
  programs.direnv = {
    nix-direnv.enable = true;
    silent = true;
  };

  bun.shellScripts = {
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
  };
}
