{ lib, config, ... }: {
  options = {
    bun.paths.bak = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/bak";
    };
  };

  config = {
    home.shellAliases = {
      "mvbak" = "bak mv";
      "cpbak" = "bak cp";
    };

    bun.shellScripts = {
      bak = /* bash */ ''
        set -euo pipefail

        usage() {
          cat <<'EOF' >&2
        Usage:
          bak mv <path> [<path> …]   # move   each into ${config.bun.paths.bak}/...
          bak cp <path> [<path> …]   # copy   each into ${config.bun.paths.bak}/...
          bak <path> [<path> …]      # rename each file to <name>.bak.<ext>

        Both mv/cp create the same mirror‑tree under "$HOME/bak".
        EOF
          exit 1
        }

        [[ $# -ge 1 ]] || usage

        # move_or_copy builds a matching directory structure and moves the
        # file/directory to that path.
        move_or_copy() {
          local act=$1   # "mv" or "cp"
          shift
          for src in "$@"; do
            src=$(readlink -f -- "$src") || {
              printf 'Error: cannot resolve %s\n' "$src" >&2
              exit 1
            }

            dst="${config.bun.paths.bak}''${src}"
            mkdir -p "$(dirname "$dst")"

            if [[ $act == mv ]]; then
              mv -- "$src" "$dst"
              echo "mv $src $dst"
            else
              cp -a -- "$src" "$dst"
              echo "cp $src $dst"
            fi
          done
        }

        # add_bak_extension adds a .bak extension to a path.
        add_bak_extension() {
          for src in "$@"; do
            src=$(readlink -f -- "$src") || {
              printf 'Error: cannot resolve %s\n' "$src" >&2
              exit 1
            }

            dir=$(dirname "$src")
            base=$(basename "$src")

            # Insert ".bak" before the last dot (or just append if no dot)
            if [[ "$base" == *.* ]]; then
              name=''${base%.*}
              ext=''${base##*.}
              new="''${name}.bak.''${ext}"
            else
              new="''${base}.bak"
            fi

            mv -- "$src" "$dir/$new"
            echo "mv $src $dir/$new"
          done
        }

        # Get the command and then shift the arguments to only be paths
        cmd=$1
        shift

        case "$cmd" in
          mv)
            [[ $# -ge 1 ]] || usage
            move_or_copy mv "$@"
            ;;

          cp)
            [[ $# -ge 1 ]] || usage
            move_or_copy cp "$@"
            ;;

          -h|--help)
            usage
            ;;

          *)
            # $cmd actually contains the first path; prepend it to the remaining args
            paths=("$cmd" "$@")          # "$cmd" is guaranteed to be non‑empty
            add_bak_extension "''${paths[@]}"
            ;;
        esac
      '';

      unbak = /* bash */''
        set -euo pipefail

        usage() {
          cat <<'EOF' >&2
        Usage:
          unbak <path> [<path> …]

          * If <path> is under the backup tree, it is moved back to the
            location it originated from (the backup prefix is stripped).

          * If <path> is *not* under the backup tree, the script removes the
            first occurrence of the literal string ".bak" from the basename,
            leaving the object in the same directory.

          * If the path is outside the backup tree and its name does not
            contain ".bak", an error is reported for that entry.

        Multiple paths can be supplied; the script will exit on any error.
        EOF
          exit 1
        }
        [[ $# -ge 1 ]] || usage

        # Resolve both the *logical* and the *real* bak directory.
        # These are different on bazzite where /home is linked to /var/home.
        bak_logical="${config.bun.paths.bak}"
        bak_real=$(readlink -f -- "''${bak_logical}")

        # restore_from_bak restores a file from the bak directory
        restore_from_bak() {
          local src=$1
          local matched_prefix=$2

          # Strip the matched prefix
          local rel="''${src#$matched_prefix}"
          [[ -n "$rel" ]] || {
            printf 'Error: cannot restore "%s" (empty relative part)\n' "$src" >&2
            return 1
          }

          local dst="''${rel}"
          if [[ -e "$dst" ]]; then
            printf 'Error: target "%s" already exists – refusing to overwrite\n' "$dst" >&2
            return 1
          fi

          mkdir -p "$(dirname "$dst")"
          mv -- "$src" "$dst"
          echo "mv $src $dst"
        }

        # strip_bak_suffix strips the first ".bak" from the basename of a path.
        strip_bak_suffix() {
          local src=$1
          local dir base newbase newpath

          dir=$(dirname "$src")
          base=$(basename "$src")

          newbase=''${base/.bak/}
          if [[ "$newbase" == "$base" ]]; then
            printf 'Error: "%s" does not contain ".bak" in its name\n' "$src" >&2
            return 1
          fi

          newpath="''${dir}/''${newbase}"
          if [[ -e "$newpath" ]]; then
            printf 'Error: target "%s" already exists – refusing to overwrite\n' "$newpath" >&2
            return 1
          fi

          mv -- "$src" "$newpath"
          echo "mv $src $newpath"
        }

        # cleanup_empty_dirs removes any empty directories from ${config.bun.paths.bak}
        cleanup_empty_dirs() {
          # -mindepth 1 prevents removal of $HOME/bak itself.
          find "$bak_real" -mindepth 1 -type d -empty -delete
        }

        # Iterate through each argument, exit if there are any errors
        for arg in "$@"; do
          # Expand `~`.
          arg_expanded=''${arg/#\~/$HOME}

          # Resolve to an absolute path.
          src=$(readlink -f -- "$arg_expanded") || {
            printf 'Error: cannot resolve "%s"\n' "$arg" >&2
            exit 1
          }

          # Verify it exists.
          if [[ ! -e "$src" ]]; then
            printf 'Error: "%s" does not exist\n' "$src" >&2
            exit 1
          fi

          # Determine what to do with it based on its location.
          case "$src" in
            "$bak_logical"/*)
              restore_from_bak "$src" "$bak_logical"
              ;;
            "$bak_real"/*)
              restore_from_bak "$src" "$bak_real"
              ;;
            *)
              strip_bak_suffix "$src"
              ;;
          esac
        done

        cleanup_empty_dirs
      '';
    };
  };
}

