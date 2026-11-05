#!/usr/bin/env bash
# ==============================================================================
# BlazeDE Installer Script
# Automatización de instalación, paquetes, AUR, Flatpak, CachyOS Kernel, 
# BlazePilot, dotfiles, bootloader y servicios.
# ==============================================================================

set -eo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BLAZEDE_DIR="$SCRIPT_DIR"
PACKAGES_DIR="$BLAZEDE_DIR/packages"

# Colores de salida
CLR_RESET="\033[0m"
CLR_INFO="\033[1;34m"
CLR_SUCCESS="\033[1;32m"
CLR_WARN="\033[1;33m"
CLR_ERR="\033[1;31m"

log_info() { printf "${CLR_INFO}[INFO] %s${CLR_RESET}\n" "$*"; }
log_ok() { printf "${CLR_SUCCESS}[OK] %s${CLR_RESET}\n" "$*"; }
log_warn() { printf "${CLR_WARN}[WARN] %s${CLR_RESET}\n" "$*"; }
log_err() { printf "${CLR_ERR}[ERROR] %s${CLR_RESET}\n" "$*" >&2; }

# Función para leer paquetes de un archivo ignorando comentarios (#) y líneas vacías
read_packages() {
    local file="$1"
    if [[ -f "$file" ]]; then
        grep -v '^[[:space:]]*#' "$file" | grep -v '^[[:space:]]*$' | tr '\n' ' '
    fi
}

# 1. Comprobación de privilegios
if [[ $EUID -eq 0 ]]; then
    log_err "No ejecutes este script como root. El script solicitará permisos con sudo cuando sea necesario."
    exit 1
fi

# 2. Comprobación de conexión a Internet
log_info "Comprobando conexión a Internet..."
if ! ping -c 1 -W 3 archlinux.org >/dev/null 2>&1 && ! ping -c 1 -W 3 1.1.1.1 >/dev/null 2>&1; then
    log_err "No se detecta conexión a Internet activa. Por favor, conecte el equipo antes de continuar."
    exit 1
fi
log_ok "Conexión a Internet activa."

# 3. Herramientas base de compilación
log_info "Actualizando base del sistema e instalando herramientas base (base-devel, git, stow)..."
sudo pacman -Sy --needed --noconfirm base-devel git stow

# 4. Instalación de Yay (AUR Helper)
if ! command -v yay >/dev/null 2>&1; then
    log_info "Instalando yay desde AUR..."
    TEMP_YAY="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$TEMP_YAY/yay"
    (
        cd "$TEMP_YAY/yay"
        makepkg -si --noconfirm
    )
    rm -rf "$TEMP_YAY"
    log_ok "yay instalado con éxito."
else
    log_ok "yay ya se encuentra instalado."
fi

# 5. Configuración del Repositorio Chaotic-AUR (Kernel CachyOS precompilado)
log_info "Verificando repositorio Chaotic-AUR para Kernel CachyOS..."
if ! grep -q "^\[chaotic-aur\]" /etc/pacman.conf; then
    log_info "Añadiendo llaves y repositorio Chaotic-AUR..."
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com || true
    sudo pacman-key --lsign-key 3056513887B78AEB || true
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' || true
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' || true
    
    if ! grep -q "^\[chaotic-aur\]" /etc/pacman.conf; then
        echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
    fi
    sudo pacman -Sy
    log_ok "Repositorio Chaotic-AUR añadido con éxito."
else
    log_ok "Repositorio Chaotic-AUR ya activo en /etc/pacman.conf."
fi

# 6. Instalación del Kernel CachyOS y sus Headers
log_info "Instalando último Kernel CachyOS optimizado y sus headers..."
sudo pacman -S --needed --noconfirm linux-cachyos linux-cachyos-headers || log_warn "No se pudo instalar linux-cachyos vía repositorio."

# 7. Paquetes de Repositorios Oficiales desde packages/pacman.txt
PACMAN_FILE="$PACKAGES_DIR/pacman.txt"
if [[ -f "$PACMAN_FILE" ]]; then
    # shellcheck disable=SC2207
    OFFICIAL_PKGS=($(read_packages "$PACMAN_FILE"))
    log_info "Instalando paquetes oficiales desde packages/pacman.txt..."
    sudo pacman -S --needed --noconfirm "${OFFICIAL_PKGS[@]}" || log_warn "Algunos paquetes oficiales no se pudieron instalar o ya estaban presentes."
else
    log_warn "No se encontró el archivo $PACMAN_FILE."
fi

# 8. Paquetes desde AUR desde packages/yay.txt
YAY_FILE="$PACKAGES_DIR/yay.txt"
if [[ -f "$YAY_FILE" ]]; then
    # shellcheck disable=SC2207
    AUR_PKGS=($(read_packages "$YAY_FILE"))
    log_info "Instalando paquetes AUR desde packages/yay.txt..."
    yay -S --needed --noconfirm "${AUR_PKGS[@]}" || log_warn "Revisar avisos de compilación/instalación en AUR."
else
    log_warn "No se encontró el archivo $YAY_FILE."
fi

# 9. Configuración e Instalación de Flatpak desde packages/flatpak.txt
log_info "Verificando repositorio Flathub..."
if command -v flatpak >/dev/null 2>&1; then
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
    
    FLATPAK_FILE="$PACKAGES_DIR/flatpak.txt"
    if [[ -f "$FLATPAK_FILE" ]]; then
        # shellcheck disable=SC2207
        FLATPAK_PKGS=($(read_packages "$FLATPAK_FILE"))
        if [[ ${#FLATPAK_PKGS[@]} -gt 0 ]]; then
            log_info "Instalando aplicaciones Flatpak desde packages/flatpak.txt..."
            flatpak install -y flathub "${FLATPAK_PKGS[@]}" || log_warn "Algunas aplicaciones Flatpak no se pudieron instalar."
        fi
    fi
    log_ok "Flatpak y Flathub configurados."
fi

# Instalación de herramientas Cargo (xdg-desktop-portal-zenzai)
if command -v cargo >/dev/null 2>&1; then
    if ! command -v xdg-desktop-portal-zenzai >/dev/null 2>&1; then
        log_info "Instalando xdg-desktop-portal-zenzai mediante cargo..."
        cargo install xdg-desktop-portal-zenzai || log_warn "No se pudo compilar xdg-desktop-portal-zenzai."
    fi
fi

# 10. Descarga de BlazePilot en la carpeta de Descargas
log_info "Preparando descarga de BlazePilot..."
DOWNLOAD_DIR="$HOME/Descargas"
# Si el sistema está en inglés y no existe Descargas, usa Downloads
if [[ ! -d "$DOWNLOAD_DIR" && -d "$HOME/Downloads" ]]; then
    DOWNLOAD_DIR="$HOME/Downloads"
fi

mkdir -p "$DOWNLOAD_DIR"

log_info "Obteniendo la última versión precompilada de BlazePilot desde GitHub..."
# Obtener la URL del activo (asset) de la última release usando la API de GitHub
BLAZEPILOT_URL=$(curl -sL https://api.github.com/repos/Jhanfer/blazepilot/releases/latest \
    | jq -r '.assets[] | select(.name | contains("x86_64-unknown-linux-gnu") and (endswith(".sha256") | not)) | .browser_download_url')

if [[ -z "$BLAZEPILOT_URL" || "$BLAZEPILOT_URL" == "null" ]]; then
    log_err "No se pudo encontrar el binario de BlazePilot para Linux x86_64 en la última release."
else
    log_info "Descargando BlazePilot desde: $BLAZEPILOT_URL"
    curl -sL "$BLAZEPILOT_URL" -o "$DOWNLOAD_DIR/blazepilot"
    chmod +x "$DOWNLOAD_DIR/blazepilot"
    log_ok "BlazePilot descargado y listo para ejecutar en: $DOWNLOAD_DIR/blazepilot"
fi

# Clonar Blazelestia si no existe
if [[ ! -d "$HOME/.config/quickshell/caelestia" ]]; then
    log_info "Clonando Blazelestia..."
    # Aseguramos que la carpeta base exista antes de clonar
    mkdir -p "$HOME/.config/quickshell"
    git clone https://github.com/Jhanfer/Blazelestia.git "$HOME/.config/quickshell/caelestia"
fi

# 11. Despliegue de dotfiles mediante GNU Stow con Respaldo Preventivo
log_info "Preparando despliegue de dotfiles con GNU Stow..."
if [[ -d "$BLAZEDE_DIR/stow" ]]; then
    # Backup preventivo de las carpetas que coincidan con los módulos a desplegar
    BACKUP_DATE="$(date +%Y%m%d_%H%M%S)"
    BACKUP_DIR="$HOME/.config/blazede_backup_$BACKUP_DATE"
    
    mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/state/zsh" "$HOME/.cache/zsh"
    
    STOW_MODULES=(
        shell
        blazede
        fastfetch
        hypr
        environment
        uwsm
        wallbash
        kitty
        xdg-desktop-portal-zenzai
        caelestia
    )
    
    # Lista de posibles carpetas en ~/.config con las que podría haber colisión previa
    COLLISION_TARGETS=("hypr" "fastfetch" "wallbash" "blazede" "zsh" "kitty" "caelestia" "environment" "uwsm")
    HAS_COLLISIONS=0
    for target in "${COLLISION_TARGETS[@]}"; do
        if [[ -d "$HOME/.config/$target" && ! -L "$HOME/.config/$target" ]]; then
            HAS_COLLISIONS=1
            break
        fi
    done
    
    if [[ $HAS_COLLISIONS -eq 1 ]]; then
        log_info "Se detectaron configuraciones previas no-simbólicas. Creando backup en: $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        for target in "${COLLISION_TARGETS[@]}"; do
            if [[ -d "$HOME/.config/$target" && ! -L "$HOME/.config/$target" ]]; then
                cp -ra "$HOME/.config/$target" "$BACKUP_DIR/"
            fi
        done
        log_ok "Backup preventivo completado."
    fi

    (
        cd "$BLAZEDE_DIR/stow"
        for mod in "${STOW_MODULES[@]}"; do
            if [[ -d "$mod" ]]; then
                log_info "Enlazando módulo Stow: $mod"
                stow --adopt -t "$HOME" "$mod" 2>/dev/null || stow -t "$HOME" "$mod" 2>/dev/null || true
            fi
        done
        # Restaurar el estado original del repositorio tras el adopt
        git checkout -- . 2>/dev/null || true
    )
    log_ok "Dotfiles desplegados correctamente en $HOME."
fi

# 12. Compilación de módulos DKMS
log_info "Verificando compilación de módulos NVIDIA DKMS..."
if command -v dkms >/dev/null 2>&1; then
    sudo dkms autoinstall || log_warn "DKMS autoinstall finalizó con advertencias (revisar si ya están precompilados)."
fi

# 13. Configuración de Plymouth, Tema del GRUB y Regeneración del Bootloader
# Configuración de Plymouth
if command -v plymouth-set-default-theme >/dev/null 2>&1; then
    log_info "Configurando Plymouth..."
    # Configurar hook de plymouth en /etc/mkinitcpio.conf si no está presente
    if [[ -f /etc/mkinitcpio.conf ]] && ! grep -q "plymouth" /etc/mkinitcpio.conf; then
        log_info "Añadiendo hook 'plymouth' a /etc/mkinitcpio.conf..."
        if grep -q "sd-encrypt" /etc/mkinitcpio.conf; then
            # Basado en systemd con cifrado: justo antes de sd-encrypt
            sudo sed -i 's/\bsd-encrypt\b/plymouth sd-encrypt/' /etc/mkinitcpio.conf
        elif grep -q "encrypt" /etc/mkinitcpio.conf; then
            # Basado en udev con cifrado: justo antes de encrypt
            sudo sed -i 's/\bencrypt\b/plymouth encrypt/' /etc/mkinitcpio.conf
        elif grep -q "systemd" /etc/mkinitcpio.conf; then
            # systemd sin cifrado: justo después de systemd
            sudo sed -i 's/\bsystemd\b/systemd plymouth/' /etc/mkinitcpio.conf
        elif grep -q "udev" /etc/mkinitcpio.conf; then
            # udev sin cifrado: justo después de udev o base udev
            sudo sed -i 's/\budev\b/udev plymouth/' /etc/mkinitcpio.conf
        fi
    fi

    # Seleccionar tema disponible
    PLYMOUTH_THEME="bgrt"
    if ! plymouth-set-default-theme -l | grep -qx "$PLYMOUTH_THEME"; then
        PLYMOUTH_THEME="$(plymouth-set-default-theme -l | head -n 1)"
    fi

    if [[ -n "$PLYMOUTH_THEME" ]]; then
        log_info "Estableciendo tema de Plymouth a: $PLYMOUTH_THEME"
        sudo plymouth-set-default-theme -R "$PLYMOUTH_THEME" || sudo plymouth-set-default-theme "$PLYMOUTH_THEME" || true
    fi
fi

# Regeneración de initramfs
log_info "Regenerando initramfs para todos los kernels instalados..."
sudo mkinitcpio -P || log_warn "mkinitcpio devolvió advertencias."

# Configuración de Vimix para GRUB
# Localización dinámica por si el paquete varía el prefijo del directorio
VIMIX_DIR="$(find /usr/share/grub/themes/ -maxdepth 1 -name "*vimix*very-dark-blue*" 2>/dev/null | head -n 1)"
if [[ -z "$VIMIX_DIR" ]]; then
    VIMIX_DIR="$(find /usr/share/grub/themes/ -maxdepth 1 -name "*vimix*" 2>/dev/null | head -n 1)"
fi

if [[ -n "$VIMIX_DIR" && -d "$VIMIX_DIR" ]]; then
    log_info "Configurando el tema Vimix ($VIMIX_DIR) para GRUB..."
    VIMIX_NAME="$(basename "$VIMIX_DIR")"
    # Copia a /boot/grub/themes para compatibilidad y acceso directo en boot/EFI
    sudo mkdir -p /boot/grub/themes
    sudo cp -r "$VIMIX_DIR" /boot/grub/themes/
    GRUB_THEME_FILE="/boot/grub/themes/$VIMIX_NAME/theme.txt"

    if [[ -f "$GRUB_THEME_FILE" && -f /etc/default/grub ]]; then
        sudo sed -i '/^GRUB_THEME=/d' /etc/default/grub
        echo "GRUB_THEME=\"$GRUB_THEME_FILE\"" | sudo tee -a /etc/default/grub >/dev/null
        log_ok "Tema Vimix configurado en /etc/default/grub ($GRUB_THEME_FILE)."
    fi
else
    log_warn "No se encontró el directorio del tema Vimix en /usr/share/grub/themes/."
fi

# Actualización bootloader
log_info "Actualizando gestor de arranque..."
if command -v grub-mkconfig >/dev/null 2>&1 && [[ -d /boot/grub ]]; then
    log_info "Detectado GRUB. Actualizando /boot/grub/grub.cfg..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    log_ok "GRUB actualizado correctamente."
elif command -v bootctl >/dev/null 2>&1 && [[ -d /boot/loader ]]; then
    log_info "Detectado systemd-boot. Actualizando entradas..."
    sudo bootctl update
    log_ok "systemd-boot actualizado correctamente."
else
    log_warn "No se reconoció automáticamente el gestor de arranque (GRUB/systemd-boot). Por favor, actualícelo manualmente."
fi

# 14. Habilitación de Servicios esenciales
log_info "Habilitando servicios de sistema y de usuario..."
sudo systemctl enable bluetooth.service || true

# Servicios de usuario
systemctl --user enable pipewire.service || true
systemctl --user enable pipewire-pulse.service || true
systemctl --user enable wireplumber.service || true


# 15. Configuración de SDDM (Tema y Wayland)
log_info "Configurando SDDM para Hyprland..."
sudo mkdir -p /etc/sddm.conf.d

# Crear configuración para forzar el inicio en Wayland y usar el tema
sudo tee /etc/sddm.conf.d/10-wayland.conf > /dev/null << 'EOF'
[General]
DisplayServer=wayland
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/sddm-astronaut-theme,QT_WAYLAND_SHELL_INTEGRATION=layer-shell

[Theme]
Current=sddm-astronaut-theme
EOF

# Si el tema astronaut requiere ajustes extra (como el archivo de configuración del tema)
if [[ -d "/usr/share/sddm/themes/sddm-astronaut-theme" ]]; then
    log_info "Aplicando configuración base al tema Astronaut..."
    # Copiar el archivo de configuración por defecto para que el usuario pueda editarlo luego
    sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/theme.conf /usr/share/sddm/themes/sddm-astronaut-theme/theme.conf.bak 2>/dev/null || true
    # Aquí podrías usar 'sed' para cambiar el fondo por defecto si quisieras
fi

# Habilitar SDDM
sudo systemctl enable sddm.service || true
log_ok "SDDM configurado y habilitado."

# Generar las carpetas de usuario (desktop, music, images, etc)
log_info "Generar carpetas de usuario..."
if command -v xdg-user-dirs-update >/dev/null 2>&1; then
    xdg-user-dirs-update
    log_ok "Carpetas de usuario creadas correctamente."
fi

# Configurar PAM para GNOME Keyring y Hyprlock
log_info "Configurando archivos PAM..."

# Configuración limpia de /etc/pam.d/hyprlock
sudo tee /etc/pam.d/hyprlock > /dev/null << 'EOF'
#%PAM-1.0
auth       include      system-login
account    include      system-login
session    optional     pam_keyinit.so force revoke
session    include      system-login
EOF
log_ok "Archivo /etc/pam.d/hyprlock configurado."

# Cambiar shell por defecto a zsh para el usuario si no lo es
if [[ "$SHELL" != *"zsh"* ]]; then
    log_info "Cambiando shell por defecto a zsh..."
    sudo usermod -s "$(which zsh)" "$USER" || log_warn "No se pudo cambiar automáticamente la shell con chsh."
fi

log_ok "========================================================"
log_ok "¡Instalación finalizada con éxito!"
log_ok "========================================================"

log_ok " ▄▄▄▄    ██▓    ▄▄▄      ▒███████▒▓█████ ▓█████▄ ▓█████"
log_ok "▓█████▄ ▓██▒   ▒████▄    ▒ ▒ ▒ ▄▀░▓█   ▀ ▒██▀ ██▌▓█   ▀"
log_ok "▒██▒ ▄██▒██░   ▒██  ▀█▄  ░ ▒ ▄▀▒░ ▒███   ░██   █▌▒███"
log_ok "▒██░█▀  ▒██░   ░██▄▄▄▄██   ▄▀▒   ░▒▓█  ▄ ░▓█▄   ▌▒▓█  ▄"
log_ok "░▓█  ▀█▓░██████▒▓█   ▓██▒▒███████▒░▒████▒░▒████▓ ░▒████▒"
log_ok "░▒▓███▀▒░ ▒░▓  ░▒▒   ▓▒█░░▒▒ ▓░▒░▒░░ ▒░ ░ ▒▒▓  ▒ ░░ ▒░ ░"
log_ok "▒░▒   ░ ░ ░ ▒  ░ ▒   ▒▒ ░░░▒ ▒ ░ ▒ ░ ░  ░ ░ ▒  ▒  ░ ░  ░"
log_ok  "░    ░   ░ ░    ░   ▒   ░ ░ ░ ░ ░   ░    ░ ░  ░    ░"
log_ok  "░          ░  ░     ░  ░  ░ ░       ░  ░   ░       ░  ░"
log_ok  "░                  ░                ░"

log_ok "========================================================"
log_ok "Ya puedes reiniciar el equipo"
log_ok "========================================================"