{ config, lib, pkgs, ... }:
let
  getRepo = (pkgs.writeShellScript "zk-get-repo" ''
    if [ -z "$ZK_REPOSITORY_TAG" ]; then
      REPO_PATH="$(git rev-parse --show-toplevel)"
      ZK_REPOSITORY_TAG="$(basename $REPO_PATH)"
    fi

    echo $ZK_REPOSITORY_TAG
  '');

  batFormat = "${pkgs.bat}/bin/bat -l markdown -p";
in
lib.mkIf config.programs.zk.enable
{
  home.shellAliases = {
    "zka" = "zk add";
    "zke" = "zk edit";
    "zkw" = "zk weekly";
  };

  bun.shellScripts = {
    # zkf makes a note with a file's contents in a codeblock
    "zkf" = /* bash */ ''
      FILEPATH="$1"
      FILENAME="$(basename $FILEPATH)"
      EXTENSION="''${FILENAME##*.}"

      echo $PWD
      echo $FILENAME "$EXTENSION"
      cat $FILEPATH | zk snippet --title "$FILENAME" --extra=type=$EXTENSION --interactive
    '';

    # zkr operates on repo-tagged notes
    "zkr" = /* bash */ ''
      SUBCOMMAND=$1
      ARGS="''${@:2}"
      REPO="$(${getRepo})"

      case "$SUBCOMMAND" in
        "new" | "todo")
          zk "$SUBCOMMAND" --extra repo="$REPO" "$ARGS" ;;

        "add")
          NOTE="''${*:2}"
          TIMESTAMP="$(date +%Y-%m-%dT%H:%M:%S%z)"

          echo -n "''${NOTE}" | zk new --title "''${TIMESTAMP}" --extra repo="$REPO" --interactive -p ;;

        "")
          zk edit --tag "$REPO" ;;

        *)
          zk "$SUBCOMMAND" --tag "$REPO" "$ARGS" ;;
      esac
    '';
  };

  home.sessionVariables = {
    # zk.nvim needs this
    ZK_NOTEBOOK_DIR = config.programs.zk.settings.notebook.dir;
  };

  programs.zk = {
    settings = {
      notebook.dir = lib.mkDefault "${config.home.homeDirectory}/zk";

      note = {
        filename = "{{id}}";
      };

      tool = {
        shell = "${pkgs.bash}/bin/bash";
        fzf-preview = "bat -p --color always {-1}";
      };

      filter = {
        today = "--modified 'today'";
      };

      group = {
        weekly = {
          paths = [ "weekly" ];

          note = {
            filename = "{{format-date now '%Y-%m-%d' }}";
            extension = "md";
            template = "weekly.md";
          };
        };

        todo = {
          paths = [ "todo" ];

          note = {
            filename = "todo{{#if extra.repo}}-{{ slug extra.repo }}{{/if}}";
            extension = "md";
            template = "todo.md";
          };
        };
      };

      alias = {
        # aliases to other commands
        ls = "zk list \"$@\"";
        log = "zk add \"$@\"";

        # changes to default settings
        list = "zk list --sort created $@";
        edit = "zk edit -i --sort modified- $@";

        # some handy shortcuts
        last = "zk list --limit 1 --sort modified- -f '{{raw-content}}' -P -q $@ | ${batFormat}";
        show = "zk list --sort created- -f '{{raw-content}}' -P -q -i $@";

        cat = "zk list --sort created- -f '{{raw-content}}' -P -q $@";
        tac = "zk list --sort created+ -f '{{raw-content}}' -P -q $@";

        bat = "zk list --sort created- -f '{{raw-content}}' -P -q $@ | ${batFormat}";
        tab = "zk list --sort created+ -f '{{raw-content}}' -P -q $@ | ${batFormat}";

        weekly = "zk this-week";
        week = "zk this-week";
        this-week =
          let
            # zk's date parser defaults to looking backward when looking for "monday" on a Monday.
            # https://stackoverflow.com/questions/6497525/print-date-for-the-monday-of-the-current-week-in-bash
            thisWeek =
              if pkgs.stdenv.isDarwin then
                "date -v -Mon +%Y-%m-%d"
              else
                "date --rfc-3339 date -d 'next-monday - 1 week'"
            ;
          in
          "zk new --no-input --date \"$(${thisWeek})\" \"$ZK_NOTEBOOK_DIR\/weekly\"";
        last-week = "zk new --no-input --date 'last week monday' \"$ZK_NOTEBOOK_DIR\/weekly\"";
        next-week = "zk new --no-input --date 'next week monday' \"$ZK_NOTEBOOK_DIR\/weekly\"";
        weeks = "zk edit weekly";

        todo = "zk new --no-input \"$ZK_NOTEBOOK_DIR/todo\" $@";

        # `zk add` is a quick way to store a message with a timestamp
        add = (pkgs.writeShellScript "zk-add" ''
          NOTE="$*"
          TIMESTAMP="$(date +%Y-%m-%dT%H:%M:%S%z)"

          echo -n "''${NOTE}" | zk new --title "''${TIMESTAMP}" --interactive -p
        '') + " $@";

        # `zk snippet` stores a snippet of code
        # cat some-file.sh | zk snippet -i --extra type=shell -t "A cool shell script"
        snippet = "zk new --template snippet.md \"$@\"";
      };
    };
  };

  xdg.configFile = {
    # Tags at the end seem to work best
    # - In title: weird markdown formatting
    # - After title: shows up in list as preview of the note
    "zk/templates/default.md".text = /* markdown */ ''
      # {{title}}

      {{content}}
      {{#if extra.repo}}

      #{{slug extra.repo}}
      {{/if}}
    '';

    "zk/templates/snippet.md".text = /* markdown */ ''
      # {{title}}

      ```{{extra.type}}
      {{content}}
      ```
      {{#if extra.type}}

      #{{slug extra.type}}
      {{/if}}
    '';

    "zk/templates/weekly.md".text = /* markdown */ ''
      # Week of {{format-date now "%Y-%m-%d" }}

      ## TODO

      - [ ] ...

      ## Notes

      {{content}}
    '';

    "zk/templates/todo.md".text = /* markdown */ ''
      # TODO{{#if extra.repo}} - {{slug extra.repo}}{{/if}}

      {{content}}
      {{#if extra.repo}}

      #{{slug extra.repo}}
      {{/if}}
    '';
  };

  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = zk-nvim;
      type = "lua";
      config = /* lua */ ''
        require("zk").setup({
          picker = "telescope",
        })
      '';
    }
  ];
}
