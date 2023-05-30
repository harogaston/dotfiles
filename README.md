## How to use it

1. Install GNU Stow:

    ```shell
    # On Arch Linux
    sudo pacman -S stow
    ```
2. Clone this repo:

    ```shell
    git clone https://github.com/harogaston/dotfiles.git $HOME/.dotfiles
    cd $HOME/.dotfiles
    ```
3. Execute [`./install.sh`](./install.sh).
    Make sure that you run the script in the main dotfiles directory - `cd ~/.dotfiles`.

## Updating
To update the dotfiles pull this repo including its submodules.

```
git pull --recurse-submodules
```
