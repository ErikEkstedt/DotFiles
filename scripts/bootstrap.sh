#!/usr/bin/env bash
# scripts/bootstrap.sh — set up a new machine from scratch
#
# On a fresh machine:
#   curl -fsSL https://raw.githubusercontent.com/ErikEkstedt/DotFiles/workspace/scripts/bootstrap.sh | bash
#
# After cloning:
#   bash ~/dotfiles/scripts/bootstrap.sh

set -euo pipefail

DOTFILES_REPO="https://github.com/ErikEkstedt/DotFiles.git"
DOTFILES_BRANCH="workspace"
DOTFILES_DIR="$HOME/dotfiles"
LOCAL_BIN="$HOME/.local/bin"
SSH_KEY="$HOME/.ssh/id_ed25519"
GIT_EMAIL="erikerikekstedt@gmail.com"

# ─── Helpers ──────────────────────────────────────────────────────────────────
info()    { echo -e "\033[0;34m[info]\033[0m  $*"; }
success() { echo -e "\033[0;32m[done]\033[0m  $*"; }
step()    { echo -e "\n\033[1;37m=== $* ===\033[0m"; }
skip()    { echo -e "\033[0;90m[skip]\033[0m  $*"; }

gh_latest() {
    curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
        | grep '"tag_name"' | cut -d'"' -f4
}

install_bin() {
    # install_bin <url> <binary-name> [strip-components=1]
    local url="$1" name="$2" strip="${3:-1}"
    mkdir -p "$LOCAL_BIN"
    curl -fsSL "$url" | tar -xz --strip-components="$strip" -C "$LOCAL_BIN" "$name"
    chmod +x "$LOCAL_BIN/$name"
}

# ─── OS / arch ────────────────────────────────────────────────────────────────
OS="$(uname -s)"
ARCH="$(uname -m)"
step "Detected: $OS / $ARCH"

if [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
    FZF_ARCH="linux_arm64"
    EZA_ARCH="aarch64-unknown-linux-gnu"
else
    FZF_ARCH="linux_amd64"
    EZA_ARCH="x86_64-unknown-linux-gnu"
fi

mkdir -p "$LOCAL_BIN"

# ─── Step 1: Package manager + git ───────────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
    step "Homebrew"
    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
    else
        skip "brew already installed"
    fi
    command -v git &>/dev/null || brew install git

elif [[ "$OS" == "Linux" ]]; then
    step "apt — core system packages"
    # Only packages that can't be installed to ~/.local/bin
    sudo apt-get update -qq
    sudo apt-get install -y --no-install-recommends \
        git curl ca-certificates \
        zsh tmux \
        ripgrep fd-find
    # fd binary on apt is named fdfind
    [ -f "$LOCAL_BIN/fd" ] || ln -sf "$(command -v fdfind 2>/dev/null || true)" "$LOCAL_BIN/fd" 2>/dev/null || true
    success "git, zsh, tmux, ripgrep, fd"
fi

# ─── Step 2: Clone dotfiles ───────────────────────────────────────────────────
step "Dotfiles repo"
if [ -d "$DOTFILES_DIR/.git" ]; then
    skip "Already cloned — pulling"
    git -C "$DOTFILES_DIR" pull --ff-only
else
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    git -C "$DOTFILES_DIR" checkout "$DOTFILES_BRANCH"
    success "Cloned to $DOTFILES_DIR"
fi

# ─── Step 3: Install tools ────────────────────────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
    step "macOS packages (Brewfile)"
    brew bundle install --file="$DOTFILES_DIR/dots/Brewfile"
    success "Done"

elif [[ "$OS" == "Linux" ]]; then
    step "Shell tools → $LOCAL_BIN"

    # fzf — fuzzy finder (ctrl-r, ctrl-t, alt-c)
    if ! command -v fzf &>/dev/null; then
        info "fzf..."
        VER=$(gh_latest junegunn/fzf)
        VER_CLEAN="${VER#v}"
        install_bin \
            "https://github.com/junegunn/fzf/releases/download/${VER}/fzf-${VER_CLEAN}-${FZF_ARCH}.tar.gz" \
            fzf 0
        success "fzf $VER"
    else
        skip "fzf $(fzf --version)"
    fi

    # eza — modern ls (ll, la, lt aliases)
    if ! command -v eza &>/dev/null; then
        info "eza..."
        VER=$(gh_latest eza-community/eza)
        install_bin \
            "https://github.com/eza-community/eza/releases/download/${VER}/eza_${EZA_ARCH}.tar.gz" \
            eza 0
        success "eza $VER"
    else
        skip "eza $(eza --version | head -1)"
    fi

    # zoxide — smart cd (z command)
    if ! command -v zoxide &>/dev/null; then
        info "zoxide..."
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh \
            | ZOXIDE_INSTALL="$LOCAL_BIN" sh
        success "zoxide installed"
    else
        skip "zoxide $(zoxide --version)"
    fi

    success "Shell tools installed"
fi

# ─── Step 4: Symlink dotfiles ─────────────────────────────────────────────────
step "Symlinking dotfiles"
bash "$DOTFILES_DIR/dots/install.sh"

# ─── Step 5: SSH key ──────────────────────────────────────────────────────────
step "SSH key"
if [ -f "$SSH_KEY" ]; then
    skip "Key exists at $SSH_KEY"
else
    mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY" -N ""
    success "Generated $SSH_KEY"
fi
echo ""
echo "  Public key — add to GitHub → Settings → SSH keys:"
echo "  ──────────────────────────────────────────────────"
cat "${SSH_KEY}.pub"
echo "  ──────────────────────────────────────────────────"

# ─── Step 6: Secrets directory ────────────────────────────────────────────────
step "Secrets"
SECRETS="$HOME/.config/secrets/env.sh"
mkdir -p "$(dirname "$SECRETS")" && chmod 700 "$(dirname "$SECRETS")"
if [ ! -f "$SECRETS" ]; then
    cat > "$SECRETS" << 'EOF'
# ~/.config/secrets/env.sh — sourced by .zshrc at login. Never commit this.
# export ANTHROPIC_API_KEY="sk-ant-..."
# export OPENAI_API_KEY="sk-..."
# export GEMINI_API_KEY="..."
EOF
    chmod 600 "$SECRETS"
    success "Template created at $SECRETS"
else
    skip "Secrets file already exists"
fi

# ─── Step 7: Default shell → zsh ─────────────────────────────────────────────
step "Default shell"
ZSH_PATH="$(command -v zsh)"
if [ "$SHELL" = "$ZSH_PATH" ]; then
    skip "Already zsh"
else
    if [[ "$OS" == "Linux" ]] && ! grep -q "$ZSH_PATH" /etc/shells; then
        echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi
    chsh -s "$ZSH_PATH" && success "Default shell → zsh" \
        || info "chsh failed — run 'exec zsh' to start it now"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo "══════════════════════════════════════"
echo "  Done! Start your shell: exec zsh"
echo "══════════════════════════════════════"
echo ""
echo "  Remaining manual steps:"
echo "  1. Add SSH public key to GitHub (shown above)"
echo "  2. Edit ~/.ssh/config with your server/host details"
echo "  3. Fill in ~/.config/secrets/env.sh with API keys"
echo ""
