{ pkgs
, config
, lib
, ...
}: {
  config = lib.mkIf config.programs.firefox.enable
    {
      home.packages = [
        pkgs.nixos-icons
      ];

      programs.firefox = {
        profiles = {
          default = {
            settings = {
              "browser.download.dir" = "${config.home.homeDirectory}/Downloads";

              # Remove most things from the new tab page
              "browser.newtabpage.activity-stream.feeds.topsites" = false;
              "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
              "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
            };

            search = {
              force = true;
              default = "kagi";

              engines = {
                "wikipedia".metaData.alias = "w";

                youtube = {
                  name = "YouTube";
                  urls = [{
                    template = "https://www.youtube.com/results";
                    params = [
                      { name = "search_query"; value = "{searchTerms}"; }
                    ];
                  }];
                  definedAliases = [ "y" ];
                };

                nixpkgs = {
                  name = "Nix Packages";
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

                nixopts = {
                  name = "Nix Options";
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

                hmopts = {
                  name = "Home Manager Options";
                  urls = [{
                    template = "https://home-manager-options.extranix.com";
                    params = [
                      { name = "query"; value = "{searchTerms}"; }
                    ];
                  }];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "hmopts" ];
                };

                kagi = {
                  name = "Kagi";
                  definedAliases = [ "k" ];
                  urls = [{
                    template = "https://kagi.com/search";
                    params = [
                      { name = "q"; value = "{searchTerms}"; }
                      { name = "personalized"; value = "1"; }
                    ];
                  }];
                };
              };
            };
          };
        };
      };
    };
}
