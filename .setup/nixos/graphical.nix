{ config, pkgs, ... }:

{
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.displayManager.gdm.wayland = false;

  # I like keeping my options open ok?
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    google-chrome
    hack-font
    terminator
  ];
}
