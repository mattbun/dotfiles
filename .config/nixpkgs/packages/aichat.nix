{ config
, lib
, ...
}:
{
  config = lib.mkIf config.programs.aichat.enable
    {
      programs.fish = {
        interactiveShellInit = ''
          bind \ee _aichat_fish
        '';

        functions = {
          # https://github.com/sigoden/aichat/blob/main/scripts/shell-integration/integration.fish
          "_aichat_fish" = {
            body = /* fish */''
              set -l _old (commandline)
              if test -n $_old
                  echo -n "⌛"
                  commandline -f repaint
                  commandline (aichat -e $_old)
              end
            '';
          };
        };
      };
    };
}
