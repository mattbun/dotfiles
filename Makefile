# The hyphen makes it not return an error if the file doesn't exist (like on mac)
-include /etc/os-release
ifeq ($(origin ID), undefined)
	os = mac
else
	os = $(ID)
endif

switch: switch-$(os)
switch-arch: switch-home-manager
switch-nixos: switch-home-manager
switch-mac: switch-darwin

build: build-$(os)
build-arch: build-home-manager
build-nixos: build-home-manager
build-mac: build-darwin

install: install-$(os)
install-arch: install-home-manager
install-nixos: install-home-manager
install-mac: install-darwin

update: update-flake switch

update-flake:
	cd ./.config/nixpkgs && nix flake update

echo-os:
	@echo $(os)

switch-home-manager:
	home-manager switch --flake ./.config/nixpkgs#matt --impure

switch-darwin:
	darwin-rebuild switch --flake ./.config/nixpkgs#rathbook --impure

build-home-manager:
	home-manager build --flake ./.config/nixpkgs#matt --impure

build-darwin:
	darwin-rebuild build --flake ./.config/nixpkgs#rathbook --impure

install-home-manager:
	nix build --experimental-features nix-command --extra-experimental-features flakes --impure --no-link ./.config/nixpkgs#homeConfigurations.matt.activationPackage
	$(shell nix path-info --experimental-features nix-command --extra-experimental-features flakes --impure ./.config/nixpkgs#homeConfigurations.matt.activationPackage)/activate

install-darwin:
	nix build --extra-experimental-features nix-command --extra-experimental-features flakes ./.config/nixpkgs#darwinConfigurations.rathbook.system --impure
	./result/sw/bin/darwin-rebuild switch --flake ./.config/nixpkgs#rathbook --impure

direnv: .envrc
.envrc:
	echo "use nix" > ./.envrc
