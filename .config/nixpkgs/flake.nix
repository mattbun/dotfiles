{
  description = "Matt's Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-colors, darwin, ... }:
    let
      system = builtins.currentSystem;
      username = builtins.getEnv "USER";
      homeDirectory = builtins.getEnv "HOME";
    in
    {
      homeConfigurations.matt = let pkgs = nixpkgs.legacyPackages.${system}; in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            ./system.nix
            ./home.nix
            ./scripts.nix
            ./colors/alacritty.nix
            ./colors/k9s.nix
            ./colors/tmux.nix
            ./colors/vim.nix
            ./packages/kubernetes.nix
            ./packages/docker.nix
            ./packages/graphical.nix
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = {
            inherit nix-colors username homeDirectory;
          };
        };

      darwinConfigurations.rathbook = darwin.lib.darwinSystem {
        system = system;
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit nix-colors username homeDirectory;
            };
          }
        ];
      };
    };
}
