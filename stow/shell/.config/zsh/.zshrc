# ==============================================================================
# Configuración Zsh desacoplada (XDG compliant)
# ==============================================================================

# Bienvenida en shells interactivas
if [[ $- == *i* ]] && command -v fastfetch >/dev/null 2>&1; then
    LOGO_FILE="$("$HOME/.config/fastfetch/fastfetch.sh" logo 2>/dev/null)"
    if [[ -n "$LOGO_FILE" && -f "$LOGO_FILE" ]]; then
        fastfetch --logo "$LOGO_FILE" --logo-type kitty
    else
        fastfetch --logo-type kitty
    fi
fi

# Directorios XDG de respaldo si no están cargados
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# --- Historial ---
mkdir -p -- "$XDG_STATE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# --- Edición de línea y teclas ---
bindkey -e
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line

# --- Autocompletado ---
autoload -Uz compinit
mkdir -p -- "$XDG_CACHE_HOME/zsh"
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

# --- Node Version Manager (NVM) ---
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
fi

# --- Alias personales ---
alias c='clear'
alias vc='code'
alias fastfetch='fastfetch --logo "$("$HOME/.config/fastfetch/fastfetch.sh" logo 2>/dev/null)" --logo-type kitty'
alias ll='ls -lah'
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# --- Prompt nativo ---
if [[ -r "$ZDOTDIR/prompt.zsh" ]]; then
    source "$ZDOTDIR/prompt.zsh"
fi

# --- Carga de funciones auxiliares ---
if [[ -d "$ZDOTDIR/functions" ]]; then
    for func_file in "$ZDOTDIR"/functions/*.zsh; do
        [[ -r "$func_file" ]] && source "$func_file"
    done
fi

# --- Herramientas interactivas (FZF y Zoxide) ---
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

# --- Plugins (Autosuggestions y Syntax Highlighting) ---
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# 1. zsh-autosuggestions (predictivo)
if [[ -r "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# 2. zsh-syntax-highlighting (resaltado de sintaxis, siempre al final de los plugins)
if [[ -r "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# --- Editor predeterminado ---
export EDITOR=code

# --- Variables de entorno y SDKs ---

# Pyenv
if [[ -d "$HOME/.pyenv" ]]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)" 2>/dev/null
fi

# CUDA
if [[ -d "/usr/local/cuda" ]]; then
    export PATH="/usr/local/cuda/bin:$PATH"
    export LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
fi
export TF_ENABLE_ONEDNN_OPTS=0

# Bun
export BUN_INSTALL="$HOME/.local/share/reflex/bun"
if [[ -d "$BUN_INSTALL" ]]; then
    export PATH="$BUN_INSTALL/bin:$PATH"
    [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
fi

# Java
if [[ -d "/usr/lib/jvm/java-17-openjdk" ]]; then
    export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
    export PATH="$PATH:$JAVA_HOME/bin"
fi

# Android SDK
export ANDROID_HOME="/opt/android-sdk"
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export ANDROID_AVD_HOME="$HOME/.config/.android/avd"
export ANDROID_EMULATOR_HOME="$HOME/.config/.android"

# Flutter
if [[ -d "/opt/flutter/bin" ]]; then
    export PATH="$PATH:/opt/flutter/bin"
fi
export CHROME_EXECUTABLE=/usr/bin/chromium

# Spicetify
if [[ -d "$HOME/.spicetify" ]]; then
    export PATH="$PATH:$HOME/.spicetify"
fi

# Flyctl
export FLYCTL_INSTALL="$HOME/.fly"
if [[ -d "$FLYCTL_INSTALL/bin" ]]; then
    export PATH="$FLYCTL_INSTALL/bin:$PATH"
fi