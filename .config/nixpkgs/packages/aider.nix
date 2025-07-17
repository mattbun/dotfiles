{ config
, lib
, pkgs
, ...
}:
{
  options.programs.aider = {
    enable = lib.mkEnableOption "aider";

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
    };
  };

  config = let cfg = config.programs.aider; in lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      aider-chat
    ];

    programs.aider.settings = {
      dark-mode = true;
    };

    home.file.".aider.conf.yml".text = builtins.toJSON cfg.settings;
  };
}
