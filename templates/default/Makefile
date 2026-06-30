stamp_file ?= .stamp
watched_files = $(shell find . -type f -not -name $(stamp_file))

home_manager := $(shell command -v home-manager 2> /dev/null)

.PHONY: switch
switch: $(stamp_file)
$(stamp_file): $(watched_files)
ifndef home_manager
	nix run home-manager/master -- switch --flake . --impure
	@touch $(stamp_file)
	@echo -e "\nhome-manager has been installed! Open a new shell!"
else
	home-manager switch --flake . --impure
	@touch $(stamp_file)
endif

.PHONY: build
build:
ifndef home_manager
	nix run home-manager/master -- build --flake . --impure
else
	home-manager build --flake . --impure
endif

.PHONY: update update-flake
update: update-flake switch
update-flake:
	nix flake update --flake .

.PHONY: clean-stamp
clean-stamp:
	rm $(stamp_file)
