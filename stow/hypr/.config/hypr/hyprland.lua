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

-----------------------------------------------------------
---------- Configuraciones iniciales de BlazeDE -----------
-----------------------------------------------------------

local status, _ = pcall(require, os.getenv("HOME") .. "/.config/hypr/")
if not status then
    print("Aviso: No se pudo cargar el archivo de respaldo de HyDE.")
end

-- Importaciones de módulos
require("autostart") -- Inicialización de appsr
require("keybindings")   -- Atajos de teclado
require("monitor")   -- Configuración de monitores
require("input") -- Configuraciones de entrada
require("animations") -- Animaciones
require("theme") -- Temas
require("windowrule") -- Reglas de ventanas