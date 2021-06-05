# These are Matt's dotfiles

## Some personal highlights

### Packages
* zsh
* neovim
* ripgrep
* fzf
* jq
* bat
* exa

### ZSH

* syntax highlighting
* autosuggestions
* [`git open`](https://github.com/paulirish/git-open)
* [`z`](https://github.com/agkozak/zsh-z)

### Neovim

* [`switch.vim`](https://github.com/AndrewRadev/switch.vim) press `-` on any character in  `true` to turn it to `false`, `'` to `"`, etc. and vice-versa.
* [`fzf.vim`](https://github.com/junegunn/fzf.vim)
* [`fugitive`](https://github.com/tpope/vim-fugitive)
* [`coc`](https://github.com/neoclide/coc.nvim) but it falls back to [ALE](https://github.com/dense-analysis/ale) if node isn't installed
* [`editorconfig`](https://editorconfig.org/)

## Setup

To set up on a new computer,

```
cd
git init
git remote add origin git@github.com:mattbun/dotfiles.git
git fetch
git checkout -t main or git reset origin/main
```
