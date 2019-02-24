# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob notify
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/Users/matt/.zshrc'

autoload -Uz compinit
compinit

autoload -Uz promptinit
promptinit
# End of lines added by compinstall

# Get the home and end keys working right
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

# ctl-arrows move one word (like chromeos)
bindkey ";5D" backward-word
bindkey ";5C" forward-word
# alt-arrows home and end
bindkey ";3D" beginning-of-line
bindkey ";3C" end-of-line

zstyle ':completion:*' menu select

source ~/.zplug/init.zsh
zplug "plugins/git",   from:oh-my-zsh
zplug "supercrabtree/k"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug "paulirish/git-open", as:command
zplug "zsh-users/zsh-autosuggestions"

zplug mafredri/zsh-async, from:github

zplug mathrath/purer, use:pure.zsh, from:github, as:theme
#zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme

# Spaceship prompt configuration
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_PROMPT_ADD_NEWLINE=false

SPACESHIP_DIR_PREFIX=""
SPACESHIP_DIR_TRUNC_REPO=false  # Disabled because it doesn't show '~' for home folder

SPACESHIP_GIT_PREFIX=""
SPACESHIP_GIT_SYMBOL=""
SPACESHIP_GIT_STATUS_PREFIX=""
SPACESHIP_GIT_STATUS_SUFFIX=""
SPACESHIP_GIT_STATUS_COLOR=8
SPACESHIP_GIT_STATUS_UNTRACKED=""
SPACESHIP_GIT_STATUS_ADDED=""
SPACESHIP_GIT_STATUS_MODIFIED=*
SPACESHIP_GIT_STATUS_RENAMED=""
SPACESHIP_GIT_STATUS_DELETED=""
SPACESHIP_GIT_STATUS_STASHED=""
SPACESHIP_GIT_STATUS_UNMERGED=""
SPACESHIP_GIT_BRANCH_COLOR=8  # Gray

SPACESHIP_EXEC_TIME_PREFIX=""
SPACESHIP_EXEC_TIME_COLOR=8  # Gray

SPACESHIP_CHAR_COLOR_SUCCESS=white
SPACESHIP_CHAR_SYMBOL="$ "

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# Generic shell configuration
. ~/.aliases
. ~/.functions
. ~/.exports

DISABLE_AUTO_TITLE="true"

# nvm - disabled because it's slow and I don't use it anyway
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
