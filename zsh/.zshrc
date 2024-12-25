# Export PATHS
export PATH="$PATH:/opt/homebrew/bin"
export PATH="$HOME/Applications:$PATH"                                   


# Exports
export DOTFILES=$HOME/.files
export COLORTERM="truecolor"
export EDITOR='nvim'
export BROWSER="brave-browser"
export MANPAGER='nvim +Man!'

###########################################################
# Alias
###########################################################
# nvim
alias v="nvim"
# alias vs="nvim -c 'SessionLoad'"
# alias vf="nvim -c 'Telescope find_files hidden=true'"
# alias vno="nvim -c 'Telescope find_files hidden=true cwd=~/zettelkasten'"

# Git
alias lg="lazygit"
alias gst="git status"
alias gad="git add"
alias gco="git commit -m"
alias gdi="git diff"
alias gps="git push"
alias gpl="git pull"
alias gch="git checkout --"

# Useful
alias ipy="ipython"  #--profile=erik"
alias wnvi="watch -n 1 nvidia-smi"
alias wnvi2="watch -n 1 nvidia-smi --query-gpu=index,memory.used,memory.total,power.draw --format=csv"

###########################################################
# LS Commands
###########################################################
if [[ $(uname) == 'Darwin' ]] && command -v gls &> /dev/null; then
    alias ll="gls -l --color"
    alias ld="gls -ld */ --color"
    alias la="gls -A -1 --group-directories-first --color"
    alias lsf="gls -1 --group-directories-first --color"
    alias lrt="gls -lrt --color"
else
    alias ll="ls -l --group-directories-first"
    alias ld="ls -ld */"
    alias la="ls -A -1 --group-directories-first"
    alias lla="ls -la --group-directories-first"
    alias lrt="ls -lrt"
fi


###########################################################
# Completions
###########################################################
# This seems like a good resource: https://thevaluable.dev/zsh-completion-guide-examples/
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Highlight the current autocomplete option
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Highlights the common pattern from the completion query
# zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:${(s.:.)LS_COLORS}")';

_comp_options+=(globdots)		# Include hidden files.

# Initialize the autocompletion
autoload -Uz compinit && compinit -i
# Must be set for menuselect keymaps to work
zmodload zsh/complist  


###########################################################
# Prompt
###########################################################
## autoload vcs and colors
autoload -U colors
colors

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green}●%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f" # default 'U'
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*:*' formats " %{$fg[yellow]%}%{$fg[magenta]%} %b%{$reset_color%} %m%c%u " # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats " %{$fg[yellow]%}%{$fg[magenta]%} %b%{$reset_color%}|%a%m%c%u " # default ' (%s)-[%b|%a]%c%u-'

function +vi-git-untracked() {
  emulate -L zsh
  if [[ -n $(git ls-files --exclude-standard --others 2> /dev/null) ]]; then
    hook_com[unstaged]+="%F{blue}●%f"
  fi
}

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt PROMPT_SUBST

## TODO
## Style Conda env
## look at examples from vcs -> https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples

NEWLINE=$'\n'
PROMPT="%{$fg[cyan]%}%3~%{$reset_color%}"
PROMPT+="\$vcs_info_msg_0_ "
PROMPT+=$'\n'
# PROMPT+="%{$fg_bold[green]%}-> %{$reset_color%}"
PROMPT+="%{$fg_bold[green]%}> %{$reset_color%}"

###########################################################
# VI-mode
###########################################################
bindkey -v
export KEYTIMEOUT=1

# otherwise the text written before vi-mode can't be deleted
bindkey -v '^?' backward-delete-char

# Use vim keys in tab complete menu:
# `zmodload zsh/complist` Must be set for menuselect keymaps to work: 
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^l' vi-forward-char
bindkey -M menuselect '^j' vi-down-line-or-history

# Move to beginning/end of line
bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line

# Change cursor shape for different vi modes.
# Set cursor style (DECSCUSR), VT520.
# 0  ⇒  blinking block.
# 1  ⇒  blinking block (default).
# 2  ⇒  steady block.
# 3  ⇒  blinking underline.
# 4  ⇒  steady underline.
# 5  ⇒  blinking bar, xterm.
# 6  ⇒  steady bar, xterm.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[2 q';;      # block (non-blinking)
        viins|main) echo -ne '\e[6 q';; # beam (non-blinking)
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[6 q" # beam (non-blinking)
}
zle -N zle-line-init
preexec() { echo -ne '\e[6 q' ;} # Use beam (non-blinking) shape cursor for each new prompt.


##############################################################
# Conda
##############################################################
# Conda

# Source function b/c Slow LOADING TIME 
# but I do require conda
function source_conda() {
  # >>> conda initialize >>> {{{
  # conda config --set changeps1 False  # show pre-prompt (base) etc
  __conda_setup="$( $HOME'/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then eval "$__conda_setup"; fi
  unset __conda_setup
  # <<< conda initialize <<< }}}
}

# source envs with fzf
function so() {
  local env
  source_conda
  if [ -z "$1" ]; then
    env=$(ls $HOME/miniconda3/envs | fzf)
    # source activate "$1"
  else
    env=$1
  fi
  conda activate "$env"
}
alias sod="conda deactivate"
zle -N so

##############################################################
# TMUX
##############################################################
if [ "$TMUX" = "" ]; then
  if tmux has-session -t=Terminal 2> /dev/null; then
    tmux attach -t Terminal
  else
    tmux new-session -s Terminal
  fi
fi # }}}


