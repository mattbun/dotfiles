# These are Matt's dotfiles

## What I use

* zsh
* neovim
* ripgrep
* fzf
* jq

## Some highlights

### ZSH

* zsh syntax highlighting

* zsh autosuggestions

### Neovim

* switch.vim press `-` on any character in  `true` to turn it to `false`, `'` to `"`, etc. and vice-versa.

### Miscellaneous

* [git-standup](https://github.com/kamranahmedse/git-standup) - See all of your commits so you can remember what you worked on. If you have a folder with multiple git repos in it, it will go through them all.  

  ```
  cd ~/Dev/qb
  git standup -d 5 > weekly.txt
  ```

* [thefuck](https://github.com/nvbn/thefuck) fixes commands entered wrong and a whole lot of other things

* A whole bunch of helpful quicklook plugins like json and csv file support

## A couple things I made that you might not care about

* [My prompt is a fork](https://github.com/mathrath/purer) of [purer](https://github.com/DFurnes/purer), which is a fork of [pure](https://github.com/sindresorhus/pure).

* oops - Copies a file/folder somewhere safe so I don't accidentally lose it. `oops ./test-data -t "WIP data"`

## Setup

To set up on a new computer,

```
cd
git init
git remote add origin https://mathrath@github.com/mathrath/dotfiles.git
git fetch
git checkout -t master or git reset origin/master
```
