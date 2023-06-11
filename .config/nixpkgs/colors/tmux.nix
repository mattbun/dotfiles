{ config
, ...
}:
let
  colorScheme = config.colorScheme; in
{
  programs.tmux.extraConfig = ''
    # Colors!
    # default statusbar colors
    set-option -g status-style "fg=#${colorScheme.colors.base04},bg=#${colorScheme.colors.base01}"

    # default window title colors
    set-window-option -g window-status-style "fg=#${colorScheme.colors.base04},bg=default"

    # active window title colors
    set-window-option -g window-status-current-style "fg=#${colorScheme.colors.base0A},bg=default"

    # pane border
    set-option -g pane-border-style "fg=#${colorScheme.colors.base01}"
    set-option -g pane-active-border-style "fg=#${colorScheme.colors.base02}"

    # message text
    set-option -g message-style "fg=#${colorScheme.colors.base05},bg=#${colorScheme.colors.base01}"

    # pane number display
    set-option -g display-panes-active-colour "#${colorScheme.colors.base0B}"
    set-option -g display-panes-colour "#${colorScheme.colors.base0A}"

    # clock
    set-window-option -g clock-mode-colour "#${colorScheme.colors.base0B}"

    # copy mode highligh
    set-window-option -g mode-style "fg=#${colorScheme.colors.base04},bg=#${colorScheme.colors.base02}"

    # bell
    set-window-option -g window-status-bell-style "fg=#${colorScheme.colors.base01},bg=#${colorScheme.colors.base08}"
  '';
}
