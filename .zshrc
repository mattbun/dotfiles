# Generic shell configuration
source ~/.shrc

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

# Install zplug if it isn't installed
if [ ! -e ~/.zplug ]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug "paulirish/git-open", as:command
zplug "zdharma/zsh-diff-so-fancy"
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/git-auto-fetch", from:oh-my-zsh
zplug "plugins/jira", from:oh-my-zsh
zplug "plugins/osx", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "plugins/asdf", from:oh-my-zsh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load

DISABLE_AUTO_TITLE="true"

# nvm - disabled because it's slow and I don't use it anyway
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
