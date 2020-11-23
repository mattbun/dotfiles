# TODO sure would be cool if I could use .aliases
# . ~/.aliases
# bax "source ~/.aliases"

alias vim="nvim"
alias vimdiff="nvim -d"
alias l="exa --git --long"
alias la="exa --git --long -a"

alias gs="git s"
alias gdca='git diff --cached'
alias gpsup='git push --set-upstream origin (git branch --show-current)'

set --global tide_prompt_char_icon "\$"
set --global tide_left_prompt_items context pwd git_prompt prompt_char
set --global tide_right_prompt_items cmd_duration status

set --global tide_status_always_display true
set --global tide_status_failure_icon
set --global tide_status_success_icon

set --global __fish_git_prompt_char_stagedstate "+"
set --global __fish_git_prompt_char_upstream_ahead "^"
set --global __fish_git_prompt_char_upstream_behind "v"

# Don't show numbers
set --global __fish_git_prompt_showupstream auto
