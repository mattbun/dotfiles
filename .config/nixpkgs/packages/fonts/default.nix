{ ... }: {
  imports = [
    ./hack.nix
  ];

  config = {
    # Set hack as the default monospace and propo fonts
    fonts = {
      hack.enable = true;

      # pro-tip: see fonts with `fc-list`
      fontconfig.defaultFonts = {
        monospace = [
          "Hack Nerd Font"
        ];
        proportional = [
          "Hack Nerd Font"
        ];
      };
    };
  };
}
