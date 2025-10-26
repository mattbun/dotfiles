{ ... }: {
  bun.shellScripts = {
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
  };
}
