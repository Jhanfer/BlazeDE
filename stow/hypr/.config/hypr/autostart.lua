--  ▄▄▄▄    ██▓    ▄▄▄      ▒███████▒▓█████ ▓█████▄ ▓█████
-- ▓█████▄ ▓██▒   ▒████▄    ▒ ▒ ▒ ▄▀░▓█   ▀ ▒██▀ ██▌▓█   ▀
-- ▒██▒ ▄██▒██░   ▒██  ▀█▄  ░ ▒ ▄▀▒░ ▒███   ░██   █▌▒███
-- ▒██░█▀  ▒██░   ░██▄▄▄▄██   ▄▀▒   ░▒▓█  ▄ ░▓█▄   ▌▒▓█  ▄
-- ░▓█  ▀█▓░██████▒▓█   ▓██▒▒███████▒░▒████▒░▒████▓ ░▒████▒
-- ░▒▓███▀▒░ ▒░▓  ░▒▒   ▓▒█░░▒▒ ▓░▒░▒░░ ▒░ ░ ▒▒▓  ▒ ░░ ▒░ ░
-- ▒░▒   ░ ░ ░ ▒  ░ ▒   ▒▒ ░░░▒ ▒ ░ ▒ ░ ░  ░ ░ ▒  ▒  ░ ░  ░
--  ░    ░   ░ ░    ░   ▒   ░ ░ ░ ░ ░   ░    ░ ░  ░    ░
--  ░          ░  ░     ░  ░  ░ ░       ░  ░   ░       ░  ░
--       ░                  ░                ░

hl.on("hyprland.start", function()
    -- Caelestia Shell (reemplaza Waybar y servidor de notificaciones)
    hl.exec_cmd("caelestia shell -d")

    -- Keyring
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")

    -- EasyEffects
    hl.exec_cmd("easyeffects --gapplication-service")

    -- Hypridle
    hl.exec_cmd("hypridle")

    -- Walker y Elephant
    hl.exec_cmd("elephant")
    hl.exec_cmd("walker --gapplication-service")
    
    -- Configuración de tema para GTK
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")

    -- wallpaper
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sleep 1 && awww img ~/.config/wallbash/wallpaper.png --transition-type any")
end)