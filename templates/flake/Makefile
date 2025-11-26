# `--impure` is required in the commands below since the flake reads the USER and HOME env vars.

switch:
	home-manager switch --flake . --impure -b backup 

build:
	home-manager build --flake . --impure

update:
	nix flake update

nix := $(shell command -v nix 2> /dev/null)
nixPath := /nix/var/nix/profiles/default/bin
home-manager := $(shell command -v home-manager 2> /dev/null)

install-nix:
ifndef nix
	curl -sSf -L https://install.lix.systems/lix | sh -s -- install --no-confirm
endif

install: install-nix
ifndef home-manager
	PATH=$$PATH:$(nixPath) nix run home-manager/master -- init --switch . --impure
	@echo -e "\nAll set! Open a new shell!"
endif
