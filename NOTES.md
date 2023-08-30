## Custom commands that need automation

### Manjaro Sway installation

1. Add manjaro-sway repo to pacman config

    ```shell
    sudo sh -c "curl -s https://pkg.manjaro-sway.download/$(pacman-mirrors -G)/ > /etc/pacman.d/manjaro-sway.repo.conf"
    ```

2. Update system

    ```shell
    sudo pacman -Syu
    sudo paccache -r -k 0
    ```

3. Install extra packages

    ```shell
    sudo pacman -S yay stow
    ```

4. GitHub ssh key

    ```shell
    ssh-keygen -t ed25519 -C "harogaston@gmail.com"
    cat ~/.ssh/github_ed25519.pub
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/github_ed25519
    ssh -T git@github.com
    ```
5. GitHub gpg key

   ```shell
   gpg --full-generate-key
   gpg --armor --export <id>
   git config --global user.signingkey <id>
   git config --global commit.gpgsign true
   gpg -o <filename.gpg> --export-options backup --export-secret-keys <id>
   ```

6. Clone dotfiles repo

    ```shell
    git clone git@github.com:harogaston/dotfiles.git $HOME/.dotfiles
    cd ~/.dotfiles
    ./install.sh
    ```

