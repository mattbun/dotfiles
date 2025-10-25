# The hyphen makes it not return an error if the file doesn't exist (like on mac)
-include /etc/os-release
ifeq ($(origin ID), undefined)
	os = mac
else
	os = $(ID)
endif

nix := $(shell command -v nix 2> /dev/null)
nixPath := /nix/var/nix/profiles/default/bin
home-manager := $(shell command -v home-manager 2> /dev/null)

switch: switch-$(os)
switch-arch: switch-home-manager
switch-bazzite: switch-home-manager
switch-nixos: switch-home-manager
switch-mac: switch-darwin

build: build-$(os)
build-arch: build-home-manager
build-bazzite: build-home-manager
build-nixos: build-home-manager
build-mac: build-darwin

install: install-$(os)
install-arch: install-home-manager
install-bazzite: install-home-manager
install-nixos: install-home-manager
install-mac: install-darwin

update: update-flake switch

update-flake:
	cd ./.config/nixpkgs && nix flake update

echo-os:
	@echo $(os)

install-nix:
ifndef nix
	curl -sSf -L https://install.lix.systems/lix | sh -s -- install --no-confirm
endif

install-home-manager: install-nix
ifndef home-manager
	PATH=$$PATH:$(nixPath) nix run home-manager/master -- init --switch ./.config/nixpkgs --impure
	@echo -e "\nAll set! Open a new shell!"
endif

switch-home-manager:
	home-manager switch --flake ./.config/nixpkgs --impure -b backup

build-home-manager:
	home-manager build --flake ./.config/nixpkgs#matt --impure

switch-darwin:
	darwin-rebuild switch --flake ./.config/nixpkgs#rathbook --impure

build-darwin:
	darwin-rebuild build --flake ./.config/nixpkgs#rathbook --impure

install-darwin:
	nix build --extra-experimental-features nix-command --extra-experimental-features flakes ./.config/nixpkgs#darwinConfigurations.rathbook.system --impure
	./result/sw/bin/darwin-rebuild switch --flake ./.config/nixpkgs#rathbook --impure
