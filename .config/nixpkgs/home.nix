{ lib
, pkgs
, ...
}: {
  imports = [
    ./lib
    ./packages
    ./scripts
  ];

  config = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "22.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
      curl
      gnumake
      gnused
      gnutar
      gzip
      jq
      unzip
    ];

    nix = {
      enable = true;
      package = lib.mkDefault pkgs.nix; # allow nix-darwin to override this
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

    # These options apply to ripgrep and fd (which are used in fzf and neovim)
    # Implemented in ./lib/search.nix

    home.shellAliases = {
      # Make aliases work with sudo
      sudo = "sudo ";
    };

    home.sessionVariables = {
      "DOTFILES_PATH" = builtins.getEnv "PWD";
    };

    # This works around some logic that tries to prevent reloading env vars
    home.sessionVariablesExtra = ''
      unset __HM_SESS_VARS_SOURCED
    '';

    home.file.".hushlogin" = {
      enable = true;
      text = "";
    };

    news.display = "silent";
  };
}
