# yesto hunxa : )

![Visual](./assets/look6.png)

## Install

CachyOS. Clone this repo, then run the script from a logged-in session so it can enable user services.

```bash
git clone git@github.com:sumit-poudel/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`./install.sh --noconfirm` passes `--noconfirm` through to pacman and paru.

The script:

- Installs the package list with pacman, drivers with `chwd`, and the AUR packages with paru. That step runs on CachyOS only.
- Sets fish as the login shell when `/etc/shells` already lists it.
- Symlinks each `.config/*` directory and the root dotfiles (`.zshrc`, `.zshenv`, `.vimrc`, `.tmux.conf`, `.zsh_plugins.txt`). Anything already at the destination is moved to the same path with a `.bck` suffix.
- Links `wallpapers/` to `~/Pictures/Wallpapers` and `avtar.jpg` to `~/Pictures/avtar.jpg`.
- Installs fisher plugins from `.config/fish/fisher.list`, the yazi recycle-bin plugin, tmux plugins, and [nvim](https://github.com/sumit-poudel/nvim.git).
- Enables and starts the user services `foot-server`, `mpd`, and `mpd-mpris`.

After that, `git pull` in this repo updates the linked configs. Noctalia rewrites its theme files in place. Those generated themes, plus MPD's database and logs, stay out of git.
