{ pkgs
, config
, lib
, ...
}: {
  options = with lib; {
    packageSets.kubernetes = mkOption {
      type = types.bool;
      description = "Whether or not to install kubernetes packages";
      default = false;
    };
  };

  config = lib.mkIf config.packageSets.kubernetes {
    home.packages = with pkgs; [
      k9s
      kubectl
      kubectx
      kubernetes-helm
      stern
    ];

    bun.shellScripts = {
      ktx = ''
        # kubectx but it adjusts its height to the number of contexts
        # xargs is trimming whitespace here
        numContexts=`kubectl config get-contexts --no-headers | wc -l | xargs`
        height=$((numContexts + 1))
        FZF_DEFAULT_OPTS="--info=hidden --height=$height" kubectx $@
      '';
    };

    # On mac, k9s tries to read configuration from ~/Library/Application Support/k9s 🤢
    home.sessionVariables = lib.mkIf pkgs.stdenv.isDarwin {
      K9SCONFIG = "${config.home.homeDirectory}/.config/k9s";
    };

    programs.k9s = {
      enable = true;
    };
  };
}
