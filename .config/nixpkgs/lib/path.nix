{ lib, config, ... }: {
  options = with lib; {
    path.prepend = lib.mkOption {
      type = with types; listOf str;
      description = "Paths to prepend to the PATH environment variable";
      default = [ ];
    };

    path.append = mkOption {
      type = with types; listOf str;
      description = "Paths to append to the PATH environment variable";
      default = [ ];
    };
  };

  config = {
    home.sessionPath = config.path.prepend ++ config.path.append;
  };
}
