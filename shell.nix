with import <nixpkgs> { };
mkShell {
  nativeBuildInputs = [
    bashInteractive
    gnumake
  ];
}
