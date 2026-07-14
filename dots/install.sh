#!/usr/bin/env bash
# dots/install.sh — idempotent, re-runnable dotfile symlinker
set -euo pipefail

DOTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

info()    { echo "  [info]  $*"; }
linked()  { echo "  [link]  $*"; }
skipped() { echo "  [skip]  $*"; }
warn()    { echo "  [warn]  $*"; }

symlink() {
    local src="$1"
    local dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        skipped "$dst (already linked)"
    else
        ln -sfn "$src" "$dst"
        linked "$dst → $src"
    fi
}

echo ""
echo "Installing dotfiles from: $DOTS"
echo ""

# Shell
symlink "$DOTS/zsh/.zshrc"              "$HOME/.zshrc"

# Editor
symlink "$DOTS/nvim"                    "$CONFIG/nvim"

# Multiplexer
symlink "$DOTS/tmux"                    "$CONFIG/tmux"
symlink "$DOTS/tmux/tmux.conf"          "$HOME/.tmux.conf"
symlink "$DOTS/herdr/config.toml"       "$CONFIG/herdr/config.toml"

# Terminal
symlink "$DOTS/ghostty"                 "$CONFIG/ghostty"

# File manager
symlink "$DOTS/yazi"                    "$CONFIG/yazi"

# Git
symlink "$DOTS/git/.gitconfig"          "$HOME/.gitconfig"
symlink "$DOTS/git/.gitignore_global"   "$HOME/.gitignore_global"

# SSH config — copy template only if no config exists yet
if [ ! -f "$HOME/.ssh/config" ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    cp "$DOTS/ssh/config.template" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
    info "Created ~/.ssh/config from template — edit it to add your server details"
else
    skipped "~/.ssh/config (already exists)"
fi

echo ""
echo "Done. To apply shell changes: source ~/.zshrc"
echo ""
