#!/bin/bash

# Directory paths
CONFIG_PATH="$HOME/.config"
DOTFILES="$HOME/DotFiles"
ZSH_DIR="$DOTFILES/zsh"



##############################################
# ZSH
##############################################
ln -sfv "$ZSH_DIR/.zshrc" "$HOME/.zshrc"
# ln -sfv "$ZSH_DIR/.zshenv" "$HOME/.zshenv" 
# ln -sfv "$ZSH_DIR/.zprofile" "$HOME/.zprofile"
# ln -sfv "$ZSH_DIR/.zlogin" "$HOME/.zlogin"
# ln -sfv "$ZSH_DIR/.zlogout" "$HOME/.zlogout"

echo "Zsh config files linked successfully\n"

##############################################
# KITTY
##############################################
KITTY_DIR="$DOTFILES/kitty"
ln -sfv "$KITTY_DIR/" "$CONFIG_PATH/kitty"
echo "Kitty config files linked successfully\n"

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


