{
  description = "A very basic flake";

  inputs = {
    dotfiles.url = "github:mattbun/dotfiles";

    # dotfiles can also be checked out locally, but be sure to run `nix flake update` to get latest changes
    # dotfiles.url = "/path/to/dotfiles";

    home-manager.follows = "dotfiles/home-manager";
    nixpkgs.follows = "dotfiles/nixpkgs";
  };

  outputs = { dotfiles, home-manager, nixpkgs, ... }:
    let
      username = builtins.getEnv "USER";
      homeDirectory = builtins.getEnv "HOME";
      system = builtins.currentSystem;
    in
    {
      homeConfigurations.${username} = let base = dotfiles.homeConfigurations.base; in
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          extraSpecialArgs = base.extraSpecialArgs // {
            inherit username homeDirectory;
          };

          modules = base.modules ++ [
            ./home.nix
          ];
        };
    };
}
