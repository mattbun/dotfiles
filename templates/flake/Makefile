# `--impure` is required in the commands below since the flake reads the USER and HOME env vars.

# Check if home-manager is installed
home-manager := $(shell command -v home-manager 2> /dev/null)

.PHONY: *

switch:
ifndef home-manager
	nix run home-manager/master -- switch --flake $(homePath) --impure -b backup
	@echo -e "\nHome-manager has been installed! Open a new shell!"
else
	home-manager switch --flake . --impure -b backup
endif

build:
ifndef home-manager
	nix run home-manager/master -- build --flake . --impure
else
	home-manager build --flake . --impure
endif

clean:
	rm -f result

update: update-flake switch

update-flake:
	nix flake update
