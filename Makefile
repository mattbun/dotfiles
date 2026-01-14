flakePath := .

# Check if home-manager is installed
home-manager := $(shell command -v home-manager 2> /dev/null)

switch: switch-home-manager
switch-home-manager:
ifndef home-manager
	nix run home-manager/master -- switch --flake $(flakePath) --impure
else
	home-manager switch --flake $(flakePath) --impure -b backup
endif

build-home-manager:
ifndef home-manager
	nix run home-manager/master -- build --flake $(flakePath) --impure
else
	home-manager build --flake $(flakePath)#matt --impure
endif

switch-darwin:
	darwin-rebuild switch --flake $(flakePath)#rathbook --impure

build-darwin:
	darwin-rebuild build --flake $(flakePath)#rathbook --impure

install-darwin:
	nix build --extra-experimental-features nix-command --extra-experimental-features flakes $(flakePath)#darwinConfigurations.rathbook.system --impure
	./result/sw/bin/darwin-rebuild switch --flake $(flakePath)#rathbook --impure

update: update-flake home

update-flake:
	nix flake update --flake $(flakePath)
