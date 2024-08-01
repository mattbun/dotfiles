{ ... }: {
  programs.ripgrep = {
    arguments = [
      # "Searches case insensitively if the pattern is all lowercase. Search case sensitively otherwise."
      "--smart-case"
      # Some other arguments are configured in ../lib/search.nix
    ];
  };
}
