include /etc/os-release

os=$(ID)

switch: switch-$(os)

switch-arch: switch-home-manager
switch-nixos: switch-home-manager

switch-home-manager:
	home-manager switch --flake ~/.config/nixpkgs#matt

build: build-$(os)

build-arch: build-home-manager
build-nixos: build-home-manager

build-home-manager:
	home-manager build --flake ~/.config/nixpkgs#matt

install:
	nix build --no-link ~/.config/nixpkgs#homeConfigurations.matt.activationPackage
	$(shell nix path-info ~/.config/nixpkgs#homeConfigurations.matt.activationPackage)/activate
