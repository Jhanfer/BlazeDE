# Prompt nativo de Zsh.
setopt PROMPT_SUBST

autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' [%b]'
zstyle ':vcs_info:git:*' actionformats ' [%b|%a]'

_blazede_update_vcs() {
    vcs_info
}

# Evita registrar el mismo hook varias veces al recargar el archivo.
add-zsh-hook -d precmd _blazede_update_vcs
add-zsh-hook precmd _blazede_update_vcs

PROMPT='%F{cyan}%~%f%F{magenta}${vcs_info_msg_0_}%f %(?.%F{green}.%F{red})❯%f '
RPROMPT='%F{244}%D{%H:%M}%f'