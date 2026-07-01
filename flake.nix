{
  description = "Matt's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    basix.url = "github:NotAShelf/Basix";
  };

  outputs = { basix, ... }: {
    homeModule = { config, ... }: {
      imports = [
        ./.config/nixpkgs/home.nix
      ];

      colorScheme.palette = basix.schemeData."${config.colorScheme.system}"."${config.colorScheme.slug}".palette;
    };

    darwinModule = ./.config/nixpkgs/darwin.nix;

    templates.default.path = ./templates/default;
  };
}
