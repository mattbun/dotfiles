{ config, lib, pkgs, ... }:
{
  options.programs.nautilus.enable = lib.mkEnableOption "nautilus (gnome file manager)";

  config = lib.mkIf config.programs.nautilus.enable {
    home.packages = with pkgs; [
      nautilus
      sushi # quick look for nautilus
    ];

    dbus.packages = with pkgs; [
      sushi
    ];

    gtk.gtk3.bookmarks = [
      "file://${config.home.homeDirectory}/Downloads"
      "file://${config.home.homeDirectory}/screenshots"
      "file://${config.home.homeDirectory}/src"
    ];
  };
}
