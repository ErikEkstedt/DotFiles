# DotFiles

Personal dotfiles and environment setup. Public repo — no secrets committed here.

## Quick Start (new machine)

```sh
curl -fsSL https://raw.githubusercontent.com/ErikEkstedt/DotFiles/workspace/scripts/bootstrap.sh | bash
```

This installs all tools, clones the repo, symlinks configs, generates an SSH key, and sets up zsh as the default shell.

Or, after cloning manually:

```sh
git clone https://github.com/ErikEkstedt/DotFiles.git ~/dotfiles
cd ~/dotfiles && git checkout workspace
just install       # symlink dotfiles
just brew          # install macOS packages (macOS only)
```

## What's Included

| Config | Location after install |
|---|---|
| zsh | `~/.zshrc` |
| neovim | `~/.config/nvim/` |
| tmux | `~/.config/tmux/` + `~/.tmux.conf` |
| ghostty | `~/.config/ghostty/` |
| yazi | `~/.config/yazi/` |
| git | `~/.gitconfig` + `~/.gitignore_global` |
| SSH | `~/.ssh/config` (from template, not overwritten if exists) |

## Tools Installed by Bootstrap

- **Shell:** zsh, fzf (fuzzy finder), zoxide (smart cd)
- **Editor:** neovim
- **Multiplexer:** tmux
- **Git:** lazygit, git-delta, gh
- **Listing:** eza (modern ls with icons + git status)
- **Search:** ripgrep, fd

## Structure

```
dotfiles/
├── Justfile                   # Task runner (just install / just update)
├── dots/
│   ├── Brewfile               # macOS package list
│   ├── install.sh             # Symlink script (idempotent, re-runnable)
│   ├── zsh/.zshrc
│   ├── nvim/
│   ├── tmux/tmux.conf
│   ├── ghostty/
│   ├── yazi/
│   ├── git/.gitconfig
│   └── ssh/config.template
└── scripts/
    └── bootstrap.sh           # Full new-machine setup
```

## Secrets

API keys and credentials live at `~/.config/secrets/env.sh` — sourced by `.zshrc` at login, never committed anywhere. The bootstrap script creates a template.

## Justfile Commands

```sh
just install    # Symlink all dotfiles (safe to re-run)
just brew       # Install macOS packages via Brewfile
just bootstrap  # Full setup (packages + symlinks)
just update     # Pull latest + re-apply dotfiles
just check      # Show current symlink state
```
