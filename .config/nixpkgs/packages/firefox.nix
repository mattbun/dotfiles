{ pkgs
, config
, lib
, ...
}: {
  options = with lib; {
    packageSets.firefox = {
      enable = mkOption {
        type = types.bool;
        description = "Whether or not to install and configure firefox";
        default = false;
      };
    };
  };

  config = lib.mkIf config.packageSets.firefox.enable
    {
      home.packages = [
        pkgs.nixos-icons
      ];

      programs.firefox = {
        enable = true;
        profiles = {
          default = {
            settings = {
              "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
            };

            search = {
              force = true;
              engines = {
                "Wikipedia (en)".metaData.alias = "w";

                "YouTube" = {
                  urls = [{
                    template = "https://www.youtube.com/results";
                    params = [
                      { name = "search_query"; value = "{searchTerms}"; }
                    ];
                  }];
                  definedAliases = [ "y" ];
                };

                "Nix Packages" = {
                  urls = [{
                    template = "https://search.nixos.org/packages";
                    params = [
                      { name = "type"; value = "packages"; }
                      { name = "query"; value = "{searchTerms}"; }
                    ];
                  }];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "nixpkgs" ];
                };

                "Nix Options" = {
                  urls = [{
                    template = "https://search.nixos.org/options";
                    params = [
                      { name = "query"; value = "{searchTerms}"; }
                      { name = "channel"; value = "unstable"; }
                    ];
                  }];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "nixopts" ];
                };

                "Home Manager Options" = {
                  urls = [{
                    template = "https://home-manager-options.extranix.com";
                    params = [
                      { name = "query"; value = "{searchTerms}"; }
                    ];
                  }];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "hmopts" ];
                };
              };
            };
          };
        };
      };
    };
}
