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

zstyle ':completion:*' menu select

source ~/.zplug/init.zsh
zplug "plugins/git",   from:oh-my-zsh
zplug "supercrabtree/k"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "paulirish/git-open", as:command

zplug mafredri/zsh-async, from:github
zplug mathrath/purer, use:pure.zsh, from:github, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

. ~/.shrc
