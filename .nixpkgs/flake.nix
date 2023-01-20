{
  description = "whatever";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-colors, darwin, ... }:
    let
      username = builtins.getEnv "USER";
      homeDirectory = builtins.getEnv "HOME"; # TODO can probably pass these to home-manager and nix-darwin
    in
    {
      darwinConfigurations = {
        rathbook = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${username}" = import "${homeDirectory}/.config/nixpkgs/home.nix"; # TODO absolute path requires '--impure'
              home-manager.extraSpecialArgs = {
                inherit nix-colors;
              };
            }
          ];
        };
      };
    };
}
