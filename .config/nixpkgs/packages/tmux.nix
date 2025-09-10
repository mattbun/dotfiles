{ config
, pkgs
, ...
}:
let
  colorScheme = config.colorScheme;
in
{
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    historyLimit = 50000;
    mouse = true;

    plugins = with pkgs; [
      tmuxPlugins.logging
    ];

    extraConfig = ''
      # No status bar!
      set -g status off

      # Set TERM inside tmux based on how many colors are available
      if-shell '(( $(tput colors 2>/dev/null) >= 256 ))' { set -g default-terminal "tmux-256color" } { set -g default-terminal "tmux" }

      # Set COLORTERM=truecolor if there's at least 256 colors available
      if-shell '(( $(tput colors 2>/dev/null) >= 256 ))' { set-environment -g COLORTERM truecolor }

      # Enable truecolor support for xterm-256color
      set -as terminal-overrides ",xterm-256color:RGB"

      # Name windows after the current directory!
      set-option -g status-interval 5
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'

      # Set terminal title!
      set-option -g set-titles on
      set-option -g set-titles-string "#{user}@#{host_short}[#{session_name},#I] #{?#{==:$HOME,#{pane_current_path}},~,#{b:pane_current_path}} #{pane_current_command}"

      # i3-style bindings!
      set -g base-index 1
      bind-key -n M-1 select-window -t :1
      bind-key -n M-2 select-window -t :2
      bind-key -n M-3 select-window -t :3
      bind-key -n M-4 select-window -t :4
      bind-key -n M-5 select-window -t :5
      bind-key -n M-6 select-window -t :6
      bind-key -n M-7 select-window -t :7
      bind-key -n M-8 select-window -t :8
      bind-key -n M-9 select-window -t :9
      bind-key -n M-0 select-window -t :10
      bind-key -n M-Tab last-window
      bind-key -n M-` choose-tree -Zw

      bind-key -n M-! join-pane -t :1
      bind-key -n M-@ join-pane -t :2
      bind-key -n M-# join-pane -t :3
      bind-key -n M-$ join-pane -t :4
      bind-key -n M-% join-pane -t :5
      bind-key -n M-^ join-pane -t :6
      bind-key -n M-& join-pane -t :7
      bind-key -n M-* join-pane -t :8
      bind-key -n M-( join-pane -t :9
      bind-key -n M-) join-pane -t :10

      bind-key -n M-Up select-pane -U
      bind-key -n M-Down select-pane -D
      bind-key -n M-Left select-pane -L
      bind-key -n M-Right select-pane -R

      bind-key -n M-S-Up swap-pane -s "{up-of}"
      bind-key -n M-S-Down swap-pane -s "{down-of}"
      bind-key -n M-S-Left swap-pane -s "{left-of}"
      bind-key -n M-S-Right swap-pane -s "{right-of}"

      bind-key -n M-z resize-pane -Z
      bind-key -n M-f resize-pane -Z

      bind-key -n M-j resize-pane -L 5
      bind-key -n M-l resize-pane -R 5
      bind-key -n M-k resize-pane -D 5
      bind-key -n M-i resize-pane -U 5
      bind-key -n M-, resize-pane -L 5
      bind-key -n M-. resize-pane -R 5
      bind-key -n M-< resize-pane -D 5
      bind-key -n M-> resize-pane -U 5

      bind-key -n M-v split-window -h -c "#{pane_current_path}"
      bind-key -n M-x split-window -v -c "#{pane_current_path}"

      bind-key -n M-V split-window -h -l 33% -c "#{pane_current_path}"
      bind-key -n M-X split-window -v -l 33% -c "#{pane_current_path}"

      bind-key -n M-n new-window
      bind-key -n M-t new-window

      bind-key -n M-: command-prompt

      # Colors!
      # default statusbar colors
      set-option -g status-style "fg=white,bg=black"

      # default window title colors
      set-window-option -g window-status-style "fg=white,bg=default"

      # active window title colors
      set-window-option -g window-status-current-style "fg=${colorScheme.accentAnsi},bg=default"

      # pane border
      set-option -g pane-border-style "fg=black"
      set-option -g pane-active-border-style "fg=${colorScheme.accentAnsi}"

      # message text
      set-option -g message-style "fg=white,bg=black"

      # pane number display
      set-option -g display-panes-active-colour "${colorScheme.accentAnsi}"
      set-option -g display-panes-colour "white"

      # clock
      set-window-option -g clock-mode-colour "${colorScheme.accentAnsi}"

      # copy mode highlight, selection in choose-tree
      set-window-option -g mode-style "fg=black,bg=${colorScheme.accentAnsi}"

      # bell
      set-window-option -g window-status-bell-style "fg=black,bg=${colorScheme.accentAnsi}"
    '';
  };
}
