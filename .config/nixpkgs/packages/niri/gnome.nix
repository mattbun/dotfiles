{ config, lib, pkgs, ... }:
{
  options.wayland.windowManager.niri.gnome-apps.enable = lib.mkEnableOption "a minimal set of gnome apps for use with niri";

  config = lib.mkIf config.wayland.windowManager.niri.gnome-apps.enable {
    programs.nautilus.enable = true;

    home.packages = with pkgs; [
      amberol # audio player
      apostrophe # markdown editor
      eyedropper # color picker
      file-roller # compress/decompress archives
      gnome-calculator
      gnome-characters # character picker
      gnome-clocks # clock
      gnome-font-viewer
      gnome-text-editor
      loupe # image viewer
      papers # document viewer
      resources # system monitor
      showtime # video player
      snapshot # camera
    ];

    gtk = {
      enable = true;

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };
  };
}
