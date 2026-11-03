#!/usr/bin/env zsh

# Directorios base XDG
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Rutas personales en PATH
typeset -U path

path=(
  "$HOME/.config/blazede/scripts"
  "$HOME/.local/bin"
  "$HOME/.npm-global/bin"
  $path
)

export PATH

# Node Version Manager (NVM)
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
