oops:
	@echo "probably meant to call make somewhere else"
	@exit 1

# OR
# oops:
# 	cd ../somewhere-else && nix flake update dotfiles && make

update: update-flake

update-flake:
	nix flake update --flake .
