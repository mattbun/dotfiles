{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    zsh
    neovim
    mc
    htop
    iotop
    screen
    ripgrep
    bat
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.matt = {
    description = "Matt Rathbun";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };
}
