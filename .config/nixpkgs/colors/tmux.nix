{ config
, ...
}:
let
  colorScheme = config.colorScheme;
in
{
  programs.tmux.extraConfig = ''
    # Colors!
    # default statusbar colors
    set-option -g status-style "fg=#${colorScheme.palette.base04},bg=#${colorScheme.palette.base01}"

    # default window title colors
    set-window-option -g window-status-style "fg=#${colorScheme.palette.base04},bg=default"

    # active window title colors
    set-window-option -g window-status-current-style "fg=#${colorScheme.palette.base0A},bg=default"

    # pane border
    set-option -g pane-border-style "fg=#${colorScheme.palette.base01}"
    set-option -g pane-active-border-style "fg=#${colorScheme.accentColor}"

    # message text
    set-option -g message-style "fg=#${colorScheme.palette.base05},bg=#${colorScheme.palette.base01}"

    # pane number display
    set-option -g display-panes-active-colour "#${colorScheme.palette.base0B}"
    set-option -g display-panes-colour "#${colorScheme.palette.base0A}"

    # clock
    set-window-option -g clock-mode-colour "#${colorScheme.palette.base0B}"

    # copy mode highligh
    set-window-option -g mode-style "fg=#${colorScheme.palette.base04},bg=#${colorScheme.palette.base02}"

    # bell
    set-window-option -g window-status-bell-style "fg=#${colorScheme.palette.base01},bg=#${colorScheme.palette.base08}"
  '';
}
