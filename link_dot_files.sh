#!/bin/bash

# Directory paths
CONFIG_PATH="$HOME/.config"
DOTFILES="$HOME/DotFiles"


##############################################
# ZSH
##############################################
ZSH_DIR="$DOTFILES/zsh"
# ZSH_LINK="$CONFIG_PATH/zsh"
ln -sfv "$ZSH_DIR/.zshrc" "$HOME/.zshrc"
# ln -sfv "$ZSH_DIR/.zshenv" "$HOME/.zshenv" 
# ln -sfv "$ZSH_DIR/.zprofile" "$HOME/.zprofile"
# ln -sfv "$ZSH_DIR/.zlogin" "$HOME/.zlogin"
# ln -sfv "$ZSH_DIR/.zlogout" "$HOME/.zlogout"
echo "Zsh config files linked successfully\n"

##############################################
# GHOSTTY
##############################################
GHOSTTY_DIR="$DOTFILES/ghostty"
GHOSTTY_LINK="$CONFIG_PATH/ghostty"
ln -sfv $GHOSTTY_DIR $GHOSTTY_LINK
echo "Ghostty config files linked successfully\n"

##############################################
# TMUX
##############################################
TMUX_DIR="$DOTFILES/tmux"
ln -sfv "$TMUX_DIR/" "$CONFIG_PATH/tmux"
ln -sfv "$TMUX_DIR/tmux.conf" "$HOME/.tmux.conf"
echo "TMUX config files linked successfully\n"

##############################################
# NEOVIM
##############################################
NVIM_DIR="$DOTFILES/nvim"
ln -sfv "$NVIM_DIR" "$CONFIG_PATH/nvim"
echo "NVIM config files linked successfully\n"


##############################################
# YAZU
##############################################
YAZI_DIR="$DOTFILES/yazi"
YAZI_LINK="$CONFIG_PATH/yazi"
ln -sfv $YAZI_DIR $YAZI_LINK
echo "Yazi config files linked successfully\n"
