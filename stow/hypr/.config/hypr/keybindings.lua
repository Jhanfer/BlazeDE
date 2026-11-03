-- ██╗  ██╗███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██████╗ ███████╗
-- ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔══██╗██║████╗  ██║██╔══██╗██╔════╝
-- █████╔╝ █████╗   ╚████╔╝ ██████╔╝██║██╔██╗ ██║██║  ██║███████╗
-- ██╔═██╗ ██╔══╝    ╚██╔╝  ██╔══██╗██║██║╚██╗██║██║  ██║╚════██║
-- ██║  ██╗███████╗   ██║   ██████╔╝██║██║ ╚████║██████╔╝███████║
-- ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝

-- Variables de entorno y rutas para los scripts
local scriptPath = os.getenv("HOME") .. "/.config/blazede/scripts"

-- Modificador principal
local mainMod = "SUPER" -- super / meta / windows key

-- Aplicaciones
local term = "kitty"
local editor = "code"
local file = "blazepilot"
local browser = "flatpak run app.zen_browser.zen"
local vscode = "code-insiders"
local spot = "spotify"

------------------------------------------------
----------- Binds de ratón y teclado -----------
------------------------------------------------

-- Selector de color Hyprpicker
hl.bind(
    mainMod .. " + SHIFT + P", 
    hl.dsp.exec_cmd("hyprpicker -a"), 
    { 
        description = "Color Picker" 
    }
)

-- Acciones de ventana/sesión
hl.bind(mainMod .. " + Q", hl.dsp.window.close()) -- cerrar ventana enfocada
hl.bind("Alt + F4", hl.dsp.window.close()) -- cerrar ventana enfocada
hl.bind(mainMod .. " + Delete", hl.dsp.exit()) -- matar sesión de hyprland
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" })) -- alternar flotante
hl.bind(mainMod .. " + G", hl.dsp.group.toggle()) -- alternar grupo
hl.bind("Alt + Return", hl.dsp.window.fullscreen()) -- alternar pantalla completa
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("swaylock")) -- bloquear pantalla


hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(scriptPath .. "/windowpin.sh")) -- fijar ventana
hl.bind(mainMod .. " + Backspace", hl.dsp.exec_cmd(scriptPath .. "/logoutlaunch.sh")) -- menú de cierre de sesión
hl.bind("Ctrl+Alt + W", hl.dsp.exec_cmd("killall waybar || (env reload_flag=1 " .. scriptPath .. "/wbarconfgen.sh)")) -- alternar waybar


-- Atajos de aplicaciones
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(file))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(spot))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(vscode))

hl.bind("Ctrl+Shift + Escape", hl.dsp.exec_cmd(scriptPath .. "/sysmonlaunch.sh"))

------------------------------------------------
----------- Lanzadores con Walker --------------
------------------------------------------------
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("walker"))
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("walker -m windows"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("walker -m files"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("walker -m clipboard"))

-- Control de audio
hl.bind(
    "F10",
    hl.dsp.exec_cmd(scriptPath .. "/volumecontrol.sh -o m"), 
    { locked = true }
)
hl.bind(
    "F11",
    hl.dsp.exec_cmd(scriptPath .. "/volumecontrol.sh -o d"), 
    { repeating = true, locked = true }
)
hl.bind(
    "F12", 
    hl.dsp.exec_cmd(scriptPath .. "/volumecontrol.sh -o i"), 
    { repeating = true, locked = true }
)
hl.bind(
    "XF86AudioMute", 
    hl.dsp.exec_cmd(scriptPath .. "/volumecontrol.sh -o m"), 
    { locked = true }
)
hl.bind(
    "XF86AudioMicMute", 
    hl.dsp.exec_cmd(scriptPath .. "/volumecontrol.sh -i m"), 
    { locked = true }
)
hl.bind(
    "XF86AudioLowerVolume", 
    hl.dsp.exec_cmd(scriptPath .. "/volumecontrol.sh -o d"), 
    { repeating = true, locked = true }
)
hl.bind(
    "XF86AudioRaiseVolume", 
    hl.dsp.exec_cmd(scriptPath .. "/volumecontrol.sh -o i"), 
    { repeating = true, locked = true }
)

-- Control de medios
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Moverse entre ventanas agrupadas
hl.bind(mainMod .. " + CTRL + H", hl.dsp.group.prev())
hl.bind(mainMod .. " + CTRL + L", hl.dsp.group.next())

-- Capturas de pantalla
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(scriptPath .. "/screenshot.sh s"))
hl.bind(mainMod .. " + Ctrl + P", hl.dsp.exec_cmd(scriptPath .. "/screenshot.sh sf"))
hl.bind(mainMod .. " + Alt + P", hl.dsp.exec_cmd(scriptPath .. "/screenshot.sh m"))
hl.bind("Print", hl.dsp.exec_cmd(scriptPath .. "/screenshot.sh p"))

-- Scripts personalizados
hl.bind(mainMod .. " + Alt + G", hl.dsp.exec_cmd(scriptPath .. "/gamemode.sh"))
hl.bind(mainMod .. " + Alt + Right", hl.dsp.exec_cmd(scriptPath .. "/swwwallpaper.sh -n"))
hl.bind(mainMod .. " + Alt + Left", hl.dsp.exec_cmd(scriptPath .. "/swwwallpaper.sh -p"))
hl.bind(mainMod .. " + Alt + Up", hl.dsp.exec_cmd(scriptPath .. "/wbarconfgen.sh n"))
hl.bind(mainMod .. " + Alt + Down", hl.dsp.exec_cmd(scriptPath .. "/wbarconfgen.sh p"))


-- Mover/Cambiar foco de ventana
hl.bind(mainMod .. " + Left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + Up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + Down", hl.dsp.focus({ direction = "d" }))
hl.bind("Alt + Tab", hl.dsp.focus({ direction = "d" }))

-- Cambiar de workspace / Mover ventana enfocada a un workspace
for i = 1, 10 do
    local key = i == 10 and "0" or tostring(i)
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = tostring(i)}))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(i)}))

    -- Mover ventana enfocada a un workspace silenciosamente
    hl.bind(mainMod .. " + Alt + " .. key, hl.dsp.window.move({ workspace = tostring(i), follow = false }))
end

-- Redimensionar ventanas
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Left", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Up", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Down", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })

-- Mover/Redimensionar ventana con el ratón
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Mover/Redimensionar ventana con teclado
hl.bind(mainMod .. " + Z", hl.dsp.window.drag())
hl.bind(mainMod .. " + X", hl.dsp.window.resize())

-- Toggle split
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))