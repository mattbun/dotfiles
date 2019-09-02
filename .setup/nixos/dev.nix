{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    docker
    docker_compose
    nodejs
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
}
