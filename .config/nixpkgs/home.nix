{ config
, pkgs
, username
, homeDirectory
, lib
, ...
}: {
  imports = [
    ./system.nix
    ./lib
    ./packages
    ./scripts
  ];

  config = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = username;
    home.homeDirectory = homeDirectory;

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
      # base
      curl
      glow
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
    bun.search = {
      includeHidden = true;
      includeGitignored = false;
      ignoredPaths = [
        ".git"
      ];
      includedPaths = [
        ".env"
      ];
    };

    home.shellAliases = {
      # Make aliases work with sudo
      sudo = "sudo ";

      # easier to remember commands that search everything
      fda = lib.mkIf config.programs.fd.enable "fd --no-ignore --hidden";
      rga = lib.mkIf config.programs.ripgrep.enable "rg --no-ignore --hidden";
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
