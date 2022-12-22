include /etc/os-release

os=$(ID)

switch: switch-$(os)

switch-arch:
	@echo "Looks like this is Arch! Using home-manager..."
	home-manager switch --flake ~/.config/nixpkgs#matt

build: build-$(os)

build-arch:
	@echo "Looks like this is Arch! Using home-manager..."
	home-manager build --flake ~/.config/nixpkgs#matt
