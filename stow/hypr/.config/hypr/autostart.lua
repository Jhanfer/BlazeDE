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
    -- Waybar
    hl.exec_cmd("waybar &")

    -- EasyEffects
    hl.exec_cmd("easyeffects --gapplication-service")

    -- Hypridle
    hl.exec_cmd("hypridle")

    -- Swaync
    hl.exec_cmd("swaync")

    -- Walker y Elephant
    hl.exec_cmd("elephant")
    hl.exec_cmd("walker --gapplication-service")
    
    -- wallpaper
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sleep 1 && awww img ~/.config/wallbash/wallpaper.png --transition-type any")
end)