# Justfile — task runner for dotfiles
# Install: brew install just
# Usage: just <recipe>

# List available recipes
default:
    @just --list

# Symlink all dotfiles to their correct locations (safe to re-run)
install:
    bash dots/install.sh

# Install macOS packages via Homebrew Bundle
brew:
    brew bundle install --file=dots/Brewfile

# Run full bootstrap (install packages + symlink dotfiles)
bootstrap:
    bash scripts/bootstrap.sh

# Pull latest changes and re-apply dotfiles
update:
    git pull
    bash dots/install.sh

# Show what symlinks are in place
check:
    @echo "=== Dotfile symlinks ==="
    @ls -la ~/.zshrc ~/.gitconfig ~/.tmux.conf 2>/dev/null || true
    @ls -la ~/.config/nvim ~/.config/tmux ~/.config/ghostty ~/.config/yazi 2>/dev/null || true
