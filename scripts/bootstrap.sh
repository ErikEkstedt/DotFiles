#!/usr/bin/env bash
# scripts/bootstrap.sh — set up a new machine from scratch
#
# Usage on a fresh machine:
#   curl -fsSL https://raw.githubusercontent.com/ErikEkstedt/DotFiles/workspace/scripts/bootstrap.sh | bash
#
# Or after cloning:
#   bash ~/dotfiles/scripts/bootstrap.sh

set -euo pipefail

DOTFILES_REPO="https://github.com/ErikEkstedt/DotFiles.git"
DOTFILES_DIR="$HOME/dotfiles"
SSH_KEY="$HOME/.ssh/id_ed25519"
GIT_EMAIL="erikerikekstedt@gmail.com"

info()    { echo -e "\n\033[0;34m[info]\033[0m  $*"; }
success() { echo -e "\033[0;32m[done]\033[0m  $*"; }
warn()    { echo -e "\033[0;33m[warn]\033[0m  $*"; }
step()    { echo -e "\n\033[1;37m>>> $*\033[0m"; }

# ─── Detect OS ────────────────────────────────────────────────────────────────
OS="$(uname -s)"
ARCH="$(uname -m)"
step "Detected: $OS / $ARCH"

# ─── Install packages ─────────────────────────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
    step "Installing macOS packages via Homebrew"

    if ! command -v brew &>/dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    if [ -f "$DOTFILES_DIR/dots/Brewfile" ]; then
        brew bundle install --file="$DOTFILES_DIR/dots/Brewfile"
    else
        # Minimal set before dotfiles are cloned
        brew install git zsh neovim tmux fzf zoxide eza ripgrep fd lazygit git-delta gh just
    fi
    success "macOS packages installed"

elif [[ "$OS" == "Linux" ]]; then
    step "Installing Linux packages via apt"

    sudo apt-get update -qq
    sudo apt-get install -y --no-install-recommends \
        git zsh curl wget unzip build-essential \
        neovim tmux ripgrep fd-find

    # fzf — apt version is often too old, install from source
    if ! command -v fzf &>/dev/null; then
        info "Installing fzf from GitHub..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all --no-bash --no-fish
    fi

    # eza — modern ls
    if ! command -v eza &>/dev/null; then
        info "Installing eza..."
        if [[ "$ARCH" == "aarch64" ]]; then
            EZA_ARCH="aarch64-unknown-linux-gnu"
        else
            EZA_ARCH="x86_64-unknown-linux-gnu"
        fi
        EZA_VERSION=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
        curl -fsSL "https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_${EZA_ARCH}.tar.gz" \
            | sudo tar -xz -C /usr/local/bin eza
    fi

    # zoxide
    if ! command -v zoxide &>/dev/null; then
        info "Installing zoxide..."
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    fi

    # lazygit
    if ! command -v lazygit &>/dev/null; then
        info "Installing lazygit..."
        LG_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | sed 's/v//')
        curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LG_VERSION}/lazygit_${LG_VERSION}_Linux_${ARCH}.tar.gz" \
            | sudo tar -xz -C /usr/local/bin lazygit
    fi

    # delta (better git diffs)
    if ! command -v delta &>/dev/null; then
        info "Installing git-delta..."
        DELTA_VERSION=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
        if [[ "$ARCH" == "aarch64" ]]; then
            DELTA_ARCH="aarch64-unknown-linux-gnu"
        else
            DELTA_ARCH="x86_64-unknown-linux-gnu"
        fi
        curl -fsSL "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-${DELTA_ARCH}.tar.gz" \
            | tar -xz --strip-components=1 -C /tmp "delta-${DELTA_VERSION}-${DELTA_ARCH}/delta"
        sudo mv /tmp/delta /usr/local/bin/delta
    fi

    # just (task runner)
    if ! command -v just &>/dev/null; then
        info "Installing just..."
        curl -sSfL https://just.systems/install.sh | sudo bash -s -- --to /usr/local/bin
    fi

    # gh (GitHub CLI)
    if ! command -v gh &>/dev/null; then
        info "Installing GitHub CLI..."
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
            | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt-get update -qq && sudo apt-get install -y gh
    fi

    success "Linux packages installed"
fi

# ─── Clone dotfiles ───────────────────────────────────────────────────────────
step "Setting up dotfiles"

if [ -d "$DOTFILES_DIR/.git" ]; then
    info "Dotfiles already cloned at $DOTFILES_DIR — pulling latest"
    git -C "$DOTFILES_DIR" pull --ff-only
else
    info "Cloning dotfiles to $DOTFILES_DIR"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    # Checkout workspace branch (the new restructured branch)
    git -C "$DOTFILES_DIR" checkout workspace 2>/dev/null || true
fi

success "Dotfiles repo ready"

# ─── Run install.sh ───────────────────────────────────────────────────────────
step "Symlinking dotfiles"
bash "$DOTFILES_DIR/dots/install.sh"

# ─── SSH key ──────────────────────────────────────────────────────────────────
step "SSH key setup"

if [ -f "$SSH_KEY" ]; then
    info "SSH key already exists at $SSH_KEY"
else
    info "Generating ed25519 SSH key..."
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY" -N ""
    success "SSH key generated"
fi

echo ""
echo "  Your public key (add to GitHub → Settings → SSH keys):"
echo "  ─────────────────────────────────────────────────────────"
cat "${SSH_KEY}.pub"
echo "  ─────────────────────────────────────────────────────────"

# ─── Secrets directory ────────────────────────────────────────────────────────
step "Secrets directory"

SECRETS_DIR="$HOME/.config/secrets"
SECRETS_FILE="$SECRETS_DIR/env.sh"

mkdir -p "$SECRETS_DIR"
chmod 700 "$SECRETS_DIR"

if [ ! -f "$SECRETS_FILE" ]; then
    cat > "$SECRETS_FILE" << 'EOF'
# ~/.config/secrets/env.sh — sourced by .zshrc at login
# NEVER commit this file. Keep it private.
#
# Example:
# export ANTHROPIC_API_KEY="sk-ant-..."
# export OPENAI_API_KEY="sk-..."
# export GEMINI_API_KEY="..."
EOF
    chmod 600 "$SECRETS_FILE"
    info "Created secrets template at $SECRETS_FILE"
else
    skipped() { true; }
    info "Secrets file already exists at $SECRETS_FILE"
fi

# ─── Default shell ────────────────────────────────────────────────────────────
step "Default shell"

ZSH_PATH="$(command -v zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
    info "Changing default shell to zsh ($ZSH_PATH)..."
    if [[ "$OS" == "Linux" ]] && ! grep -q "$ZSH_PATH" /etc/shells; then
        echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi
    chsh -s "$ZSH_PATH"
    success "Default shell set to zsh"
else
    info "zsh is already the default shell"
fi

# ─── Summary ──────────────────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════"
echo "  Bootstrap complete!"
echo "════════════════════════════════════════════════"
echo ""
echo "  Next steps:"
echo "  1. Add your SSH public key to GitHub (shown above)"
echo "  2. Edit ~/.ssh/config with your server details"
echo "  3. Add API keys to ~/.config/secrets/env.sh"
echo "  4. Open a new terminal (or: exec zsh)"
echo ""
