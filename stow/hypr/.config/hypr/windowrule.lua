-- ██╗    ██╗██╗███╗   ██╗██████╗ ██╗   ██╗██╗     ███████╗
-- ██║    ██║██║████╗  ██║██╔══██╗██║   ██║██║     ██╔════╝
-- ██║ █╗ ██║██║██╔██╗ ██║██████╔╝██║   ██║██║     █████╗
-- ██║███╗██║██║██║╚██╗██║██╔══██╗██║   ██║██║     ██╔══╝
-- ╚███╔███╔╝██║██║ ╚████║██║  ██║╚██████╔╝███████╗███████╗
--  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝

--------------------------------------------------------
---------------- REGLAS DE VENTANA ---------------------
--------------------------------------------------------

-- Prevenir que la pantalla se apague (Idle Inhibit)
hl.window_rule({
    match = { class = "^(.*celluloid.*)$|^(.*mpv.*)$|^(.*vlc.*)$" },
    idle_inhibit = "fullscreen"
})
hl.window_rule({
    match = { class = "^(.*[Ss]potify.*)$" },
    idle_inhibit = "fullscreen"
})
hl.window_rule({
    match = { class = "^(.*LibreWolf.*)$|^(.*floorp.*)$|^(.*brave-browser.*)$|^(.*firefox.*)$|^(.*chromium.*)$|^(.*zen.*)$|^(.*vivaldi.*)$" },
    idle_inhibit = "fullscreen"
})


-- Picture-in-Picture (PiP)
hl.window_rule({
    name = "hyde_picture_in_picture",
    match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
    tag = "+picture-in-picture",
    float = true,
    keep_aspect_ratio = true,
    move = "(monitor_w*0.73) (monitor_h*0.72)",
    size = "(monitor_w*0.25) (monitor_h*0.25)",
    pin = true
})

-- Opacidades (Usando bucles para mantener el código limpio)
-- Formato: "activa inactiva pantalla_completa"
local opacity_rules = {
    { class = "^(firefox)$", opacity = "0.90 0.90 1.0" },
    { class = "^(brave-browser)$", opacity = "0.90 0.90 1.0" },
    { class = "^(code-oss)$", opacity = "0.80 0.80 1.0" },
    { class = "^([Cc]ode)$", opacity = "0.80 0.80 1.0" },
    { class = "^(code-url-handler)$", opacity = "0.80 0.80 1.0" },
    { class = "^(code-insiders-url-handler)$", opacity = "0.80 0.80 1.0" },
    { class = "^(kitty)$", opacity = "0.80 0.80 1.0" },
    { class = "^(org.kde.dolphin)$", opacity = "0.80 0.80 1.0" },
    { class = "^(org.kde.ark)$", opacity = "0.80 0.80 1.0" },
    { class = "^(nwg-look)$", opacity = "0.80 0.80 1.0" },
    { class = "^(qt5ct)$", opacity = "0.80 0.80 1.0" },
    { class = "^(qt6ct)$", opacity = "0.80 0.80 1.0" },
    { class = "^(kvantummanager)$", opacity = "0.80 0.80 1.0" },
    
    { class = "^(org.pulseaudio.pavucontrol)$", opacity = "0.80 0.70 1.0" },
    { class = "^(blueman-manager)$", opacity = "0.80 0.70 1.0" },
    { class = "^(nm-applet)$", opacity = "0.80 0.70 1.0" },
    { class = "^(nm-connection-editor)$", opacity = "0.80 0.70 1.0" },
    { class = "^(org.kde.polkit-kde-authentication-agent-1)$", opacity = "0.80 0.70 1.0" },
    { class = "^(polkit-gnome-authentication-agent-1)$", opacity = "0.80 0.70 1.0" },
    { class = "^(org.freedesktop.impl.portal.desktop.gtk)$", opacity = "0.80 0.70 1.0" },
    { class = "^(org.freedesktop.impl.portal.desktop.hyprland)$", opacity = "0.80 0.70 1.0" },
    
    { class = "^([Ss]team)$", opacity = "0.70 0.70 1.0" },
    { class = "^(steamwebhelper)$", opacity = "0.70 0.70 1.0" },
    { class = "^([Ss]potify)$", opacity = "0.70 0.70 1.0" },
    { class = "^(com.github.rafostar.Clapper)$", opacity = "0.90 0.90 1.0" },
    
    { class = "^(com.github.tchx84.Flatseal)$", opacity = "0.80 0.80 1.0" },
    { class = "^(hu.kramo.Cartridges)$", opacity = "0.80 0.80 1.0" },
    { class = "^(com.obsproject.Studio)$", opacity = "0.80 0.80 1.0" },
    { class = "^(gnome-boxes)$", opacity = "0.80 0.80 1.0" },
    { class = "^(vesktop)$", opacity = "0.80 0.80 1.0" },
    { class = "^(discord)$", opacity = "0.80 0.80 1.0" },
    { class = "^(WebCord)$", opacity = "0.80 0.80 1.0" },
    { class = "^(ArmCord)$", opacity = "0.80 0.80 1.0" },
    { class = "^(app.drey.Warp)$", opacity = "0.80 0.80 1.0" },
    { class = "^(net.davidotek.pupgui2)$", opacity = "0.80 0.80 1.0" },
    { class = "^(yad)$", opacity = "0.80 0.80 1.0" },
    { class = "^(Signal)$", opacity = "0.80 0.80 1.0" },
    { class = "^(io.github.alainm23.planify)$", opacity = "0.80 0.80 1.0" },
    { class = "^(io.gitlab.theevilskeleton.Upscaler)$", opacity = "0.80 0.80 1.0" },
    { class = "^(com.github.unrud.VideoDownloader)$", opacity = "0.80 0.80 1.0" },
    { class = "^(io.gitlab.adhami3310.Impression)$", opacity = "0.80 0.80 1.0" },
    { class = "^(io.missioncenter.MissionCenter)$", opacity = "0.80 0.80 1.0" },
    { class = "^(io.github.flattool.Warehouse)$", opacity = "0.80 0.80 1.0" },
}

-- Reglas específicas por Título
hl.window_rule({ match = { initial_title = "^(Spotify Free)$" }, opacity = "0.70 0.70 1.0" })
hl.window_rule({ match = { initial_title = "^(Spotify Premium)$" }, opacity = "0.70 0.70 1.0" })

-- Aplicar todas las reglas de opacidad de la tabla
for _, rule in ipairs(opacity_rules) do
    hl.window_rule({
        match = { class = rule.class },
        opacity = rule.opacity
    })
end

-- 4. Ventanas Flotantes
local float_classes = {
    "^(Signal)$", "^(com.github.rafostar.Clapper)$", "^(app.drey.Warp)$",
    "^(net.davidotek.pupgui2)$", "^(yad)$", "^(eog)$",
    "^(io.github.alainm23.planify)$", "^(io.gitlab.theevilskeleton.Upscaler)$",
    "^(com.github.unrud.VideoDownloader)$", "^(io.gitlab.adhami3310.Impression)$",
    "^(io.missioncenter.MissionCenter)$"
}

for _, class in ipairs(float_classes) do
    hl.window_rule({
        match = { class = class },
        float = true
    })
end

-- Forzar que Kitty no se abra en pantalla completa
hl.window_rule({
    match = { class = "^(kitty)$" },
    float = false,
    center = true,
    size = { 900, 600 }
})

------------------------------------------------------
----------------- REGLAS DE CAPAS --------------------
------------------------------------------------------
-- Se aplican a barras, notificaciones y menús.

local layer_namespaces = {
    "rofi",
    "notifications",
    "swaync-notification-window",
    "swaync-control-center",
    "logout_dialog"
}

for _, ns in ipairs(layer_namespaces) do
    hl.layer_rule({
        match = { namespace = ns },
        blur = true,
        -- Dependiendo de la app, ignore_alpha 0 ayuda a que el blur se vea bien en bordes
        ignore_alpha = 0 
    })
end