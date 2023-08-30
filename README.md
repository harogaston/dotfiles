## How to use it

1. Install GNU Stow:

    ```shell
    # On Arch Linux
    sudo pacman -S stow
    ```
2. Clone this repo:

    ```shell
    git clone git@github.com:harogaston/dotfiles.git $HOME/.dotfiles
    cd $HOME/.dotfiles
    ```
3. Execute [`./install.sh`](./install.sh).
    Make sure that you run the script in the main dotfiles directory - `cd ~/.dotfiles`.
    If stow refuses to stow some package due to existing files, simple `adopt <pkg>` and `git checkout .`
