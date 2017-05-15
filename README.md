# These are Matt's dotfiles

## Some highlights

* zsh syntax highlighting


* switch.vim press `-` on any character in  `true` to turn it to `false`, `'` to `"`, etc. and vice-versa.

* [the_silver_searcher](https://github.com/ggreer/the_silver_searcher) find stuff in files with just `ag "search text"`. Fast, prints nicely, and skips anything in .gitignore (like node_modules!).

* [thefuck](https://github.com/nvbn/thefuck) fixes commands entered wrong and a whole lot of other things

* [emoj](https://github.com/sindresorhus/emoj) - command line emoji search, because why not. `emoj -c unicorn`

* A whole bunch of helpful quicklook plugins like json and csv file support

* `please` - An alias that repeats your last command but with sudo.

  ```
  / $ touch this
  touch: this: Permission denied
  / $ please
  Password:
  / $ 
  ```

* [git-standup](https://github.com/kamranahmedse/git-standup) - See all of your commits so you can remember what you worked on. If you have a folder with multiple git repos in it, it will go through them all.  

  ```
  cd ~/Dev/qb
  git standup -d 5 > weekly_qb.txt
  ```



## A couple things I made that you might not care about

* [My prompt is a fork](https://github.com/mathrath/purer) of [purer](https://github.com/DFurnes/purer), which is a fork of [pure](https://github.com/sindresorhus/pure).

* oops - Copies a file/folder somewhere safe so I don't accidentally lose it. `oops lib/api/test-data -t "test data for hubnspokes"`

## Setup

To set up on a new computer,

```
cd
git init
git remote add origin https://mathrath@gitlab.com/mathrath/dotfiles.git
git fetch
git checkout -t master or git reset origin/master
git submodule update --init --recursive
```
