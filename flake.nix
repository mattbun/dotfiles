{
  description = "Matt's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    basix.url = "github:NotAShelf/Basix";
  };

  outputs = { nixpkgs, home-manager, basix, darwin, ... }:
    let
      system = builtins.currentSystem;
      username = builtins.getEnv "USER";
      homeDirectory = builtins.getEnv "HOME";
    in
    {
      homeConfigurations."${username}" = let pkgs = nixpkgs.legacyPackages.${system}; in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./.config/nixpkgs/home.nix
            ./.config/nixpkgs/system.nix
            {
              home = {
                inherit username homeDirectory;
              };
            }
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = {
            inherit basix;
          };
        };

      homeConfigurations.base = let pkgs = nixpkgs.legacyPackages.${system}; in {
        inherit pkgs;

        modules = [
          ./.config/nixpkgs/home.nix
        ];

        extraSpecialArgs = {
          inherit basix;
        };
      };

      homeManagerModule = ./.config/nixpkgs/home.nix;

      templates = {
        default = {
          path = ./templates/flake;
        };

        matt = {
          path = ./templates/matt;
          description = "Configuration specific to Matt";
          welcomeText = ''
            Added `matt.nix`! Now add it as an import in `home.nix` or add it to the home-manager modules in `flake.nix`.

            ```nix
            imports = [
              ./matt.nix
            ];
            ```
          '';
        };
      };

      darwinConfigurations.rathbook = darwin.lib.darwinSystem {
        system = system;
        modules = [
          ./.config/nixpkgs/darwin.nix
          ./.config/nixpkgs/system.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = import ./.config/nixpkgs/home.nix;
            home-manager.extraSpecialArgs = {
              inherit basix username homeDirectory;
            };
          }
        ];
      };
    };
}
