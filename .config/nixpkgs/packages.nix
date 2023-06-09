{ pkgs, lib, config, ... }: {
  options = with lib; {
    packageSets = mkOption {
      type = with types; listOf string;
      description = "Package sets to install";
      default = [ ];
    };

    additionalPackages = mkOption {
      type = with types; listOf package;
      description = "List of additional packages to install";
      default = [ ];
    };
  };

  config = {
    home.packages = with pkgs; [
      # base
      asdf-vm
      bat
      curl
      delta
      fd
      git
      glow
      gnutar
      gzip
      jq
      ripgrep
      rnix-lsp
      stylua
      sumneko-lua-language-server
      tmux
      unzip
      zsh
    ] ++ (if builtins.elem "kubernetes" config.packageSets then [
      # kubernetes
      k9s
      kubectl
      kubectx
      kubernetes-helm
      stern
    ] else [ ])
    ++ (if builtins.elem "docker" config.packageSets then [
      # docker
      docker
      docker-compose
    ] else [ ])
    ++ (if builtins.elem "graphical" config.packageSets then [
      # graphical
      alacritty
      hack-font
    ] else [ ])
    ++ config.additionalPackages;
  };
}
