homePath := ./home
nixosPath := ./nixos

# `switch*` targets use these stamp files to record the timestamp of the last successful switch
# https://www.technovelty.org/tips/the-stamp-idiom-with-make.html
stampPath := ./.stamp
stampPathHome := $(stampPath)/switch-home
stampPathNixos := $(stampPath)/switch-nixos

# Check if home-manager is installed
home-manager := $(shell command -v home-manager 2> /dev/null)

# switch - apply configurations
.PHONY: switch
switch: switch-nixos switch-home

.PHONY: switch-nixos
switch-nixos: $(stampPathNixos)
$(stampPathNixos): $(nixosPath)/*
	sudo nixos-rebuild switch --flake $(nixosPath)#default
	@mkdir -p $(stampPath)
	@touch $(stampPathNixos)

.PHONY: switch-home
switch-home: $(stampPathHome)
$(stampPathHome): $(homePath)/*
ifndef home-manager
	nix run home-manager/master -- switch --flake $(homePath) --impure
	@mkdir -p $(stampPath)
	@touch $(stampPathHome)
	@echo -e "\nHome-manager has been installed! Open a new shell!"
else
	home-manager switch --flake $(homePath) --impure
	@mkdir -p $(stampPath)
	@touch $(stampPathHome)
endif

# clean - remove stamp files
.PHONY: clean
clean:
	rm -R $(stampPath)

# build-* - build configurations without applying them, see symlink `./result`

.PHONY: build-nixos
build-nixos:
	nixos-rebuild build --flake $(nixosPath)#default

.PHONY: build-home
build-home:
ifndef home-manager
	nix run home-manager/master -- build --flake $(homePath) --impure
else
	home-manager build --flake $(homePath) --impure
endif

# update - update flakes
.PHONY: update
update: update-nixos update-home switch-nixos switch-home

.PHONY: update-nixos update-nixos-flake
update-nixos: update-nixos-flake switch-nixos
update-nixos-flake:
	nix flake update --flake $(nixosPath)

.PHONY: update-home update-home-flake
update-home: update-home-flake switch-home
update-home-flake:
	nix flake update --flake $(homePath)

# nixos-config - generate a nixos config
.PHONY: nixos-config
nixos-config:
	nixos-generate-config --flake --dir $(nixosPath)
