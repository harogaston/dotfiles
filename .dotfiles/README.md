## Getting started

If you're starting from scratch, go ahead and

1 - create a .dotfiles folder, which we'll use to track your dotfiles

> `git init --bare $HOME/.dotfiles`

2 - create an alias dots so you don't need to type it all over again

> `alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`

3 - set git status to hide untracked files

> `dots config --local status.showUntrackedFiles no`

4 - add the alias to .bashrc (or .zshrc) so you can use it later

> `echo "alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.bashrc`

## Usage

Now you can use regular git commands such as:

```
dots status
dots add .vimrc
dots commit -m "Add vimrc"
dots add .bashrc
dots commit -m "Add bashrc"
dots push
```

Nice, right? Now if you're moving to a new system

## Setup environment in a new computer

Make sure to have git installed, then:

1 - clone your github repository

> `git clone --bare https://github.com/harogaston/dotfiles.git $HOME/.dotfiles`

2 - define the alias in the current shell scope

> `alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`

3 - checkout the actual content from the git repository to your $HOME

> `dots checkout`

(*) Note that if you already have some of the files you'll get an error message. You can either (1) delete them or (2) back them up somewhere else. It's up to you.

Awesome! You’re done.
