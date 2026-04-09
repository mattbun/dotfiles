{ config, ... }: {
  # Change NPM prefix so `npm install -g ...` doesn't try to install inside the nix store.
  programs.npm.settings.prefix = "${config.home.homeDirectory}/.npm";
}
