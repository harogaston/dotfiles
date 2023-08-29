# How to add a new file to be managed by stow?

Notes: 
> The default "target" `-t` directory is the parent of the current directory
> The default stow directory `-d` is the current directory

The following explanation works from the ~/.dotfiles directory:

1. Let's say you want to include a new file localted at `~/.some-dir/some-file`
2. First you would create a directory for the new "package" inside the stow directory: `$ mkdir my-package`
3. Then you would create a dummy file at the same relative location but inside you new package directory: `$ mkdir my-package/.some-dir && touch some-file`
4. Add the package to stow: `stow --adopt -(n)v my-package` (the `-n` option simulates the execution)
5. Done. Now `git add` the new files and commit.
