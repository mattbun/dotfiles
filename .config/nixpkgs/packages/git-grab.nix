{ lib, config, ... }: {
  options = {
    bun.paths.repos = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/src";
    };

    bun.paths.scratch = lib.mkOption {
      type = lib.types.str;
      default = "${config.bun.paths.repos}/scratch";
    };
  };

  config = {
    bun.shellScripts = {
      git-grab = /* bash */ ''
        # Check that an argument was provided
        if [[ $# -ne 1 ]]; then
          echo "Usage: $0 <git-clone-url>"
          exit 1
        fi

        url="$1"

        # Remove any trailing .git suffix
        url="''${url%.git}"

        # Parse the URL
        # Supports:
        #   https://github.com/user/repo
        #   git@github.com:user/repo
        #   ssh://git@github.com/user/repo
        if [[ "$url" =~ ^https?://([^/]+)/([^/]+)/([^/]+)$ ]]; then
          # HTTPS style
          host="''${BASH_REMATCH[1]}"
          user="''${BASH_REMATCH[2]}"
          repo="''${BASH_REMATCH[3]}"
        elif [[ "$url" =~ ^git@([^:]+):([^/]+)/([^/]+)$ ]]; then
          # SSH short style (git@host:user/repo)
          host="''${BASH_REMATCH[1]}"
          user="''${BASH_REMATCH[2]}"
          repo="''${BASH_REMATCH[3]}"
        elif [[ "$url" =~ ^ssh://([^@]+)@([^/]+)/([^/]+)/([^/]+)$ ]]; then
          # SSH full style (ssh://git@host/user/repo)
          host="''${BASH_REMATCH[2]}"
          user="''${BASH_REMATCH[3]}"
          repo="''${BASH_REMATCH[4]}"
        else
          echo "Error: Unable to parse URL: $url"
          exit 2
        fi

        clone_path="${config.bun.paths.repos}/''${user}/''${repo}"
        mkdir -p "''${clone_path}"
        git clone $1 "''${clone_path}"

        # Tell z.lua about it so it's easy to jump to
        z.lua --add "''${clone_path}"
      '';

      git-scratch = /* bash */''
        repo_path="${config.bun.paths.scratch}/$1"
        mkdir -p "''${repo_path}"
        git init "''${repo_path}"

        # Tell z.lua about it so it's easy to jump to
        z.lua --add "''${repo_path}"
      '';
    };
  };
}
