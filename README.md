To set up on a new computer,

```
cd
git init
git remote add origin https://mathrath@gitlab.com/mathrath/dotfiles.git
git fetch
git checkout -t master or git reset origin/master
git submodule update --init --recursive
```
