# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "plugins/asdf", from:oh-my-zsh
zplug "ptavares/zsh-direnv"

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
  zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load

DISABLE_AUTO_TITLE="true"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Speed up asdf-managed tools with direnv. See https://github.com/asdf-community/asdf-direnv
# Hook direnv into your shell.
export DIRENV_LOG_FORMAT=
eval "$(asdf exec direnv hook zsh)"

# A shortcut for asdf managed direnv.
direnv() { asdf exec direnv "$@"; }

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
