{ pkgs
, config
, lib
, ...
}: {
  options = with lib; {
    packageSets.docker = mkOption {
      type = types.bool;
      description = "Whether or not to install docker packages";
      default = false;
    };
  };

  config = lib.mkIf config.packageSets.docker {
    home.packages = with pkgs; [
      docker
      docker-compose
    ];
  };
}
