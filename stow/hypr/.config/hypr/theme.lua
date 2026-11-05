-- ████████╗███████╗███╗   ███╗ █████╗ ███████╗
-- ╚══██╔══╝██╔════╝████╗ ████║██╔══██╗██╔════╝
--    ██║   █████╗  ██╔████╔██║███████║███████╗
--    ██║   ██╔══╝  ██║╚██╔╝██║██╔══██║╚════██║
--    ██║   ███████╗██║ ╚═╝ ██║██║  ██║███████║
--    ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝

-- Variables de entorno
hl.env("GTK_THEME", "Gruvbox-Retro")
hl.env("ICON_THEME", "Gruvbox-Plus-Dark")
hl.env("CURSOR_THEME", "Bibata-Modern-Classic")
hl.env("CURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("COLOR_SCHEME", "prefer-dark")


-- Configuración general, grupos y decoración
hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 8,
        border_size = 1,
        col = {
            -- Colores de los bordes de ventanas
            active_border = {
                colors = {
                    "#7A00AFE2",
                    "#4300AFE2",
                },
                angle = 45,
            },
            inactive_border = {
                colors = {
                    "#7A00AF75",
                    "#4300AF75",
                },
                angle = 45,
            },
        },
        layout = "dwindle",
        resize_on_border = true
    },
    
    group = {
        col = {
            active_border = {
                colors = {
                    "#7A00AFE2",
                    "#4300AFE2",
                },
            },
            inactive_border = {
                colors = {
                    "#7A00AF75",
                    "#4300AF75",
                },
            },
        },
    },
    -- Decoraciones y blur
    decoration = {
        rounding = 20,
        shadow = {
            enabled = true
        },
        blur = {
            enabled = true,
            noise = 0.05,
            size = 5,
            passes = 2,
            new_optimizations = true,
            ignore_opacity = true,
            xray = false,
            variant = "haze",
            popups = true,
            ignore_opacity = true,
        },
        active_opacity = 0.98,
        inactive_opacity = 0.95,
        dim_inactive = true,
        dim_strength = 0.05,
    }
})

-- Reglas de capas
hl.layer_rule({
    name = "caelestia-blur",
    match = { namespace = "^(caelestia.*|quickshell.*)$" },
    blur = true,
    ignore_alpha = 0.2
})


-- Variables de tema de HyDE
hl.env("HYDE_THEME", "Ukory")
hl.env("GTK_THEME", "Gruvbox-Retro")
hl.env("COLOR_SCHEME", "prefer-dark")
hl.env("ICON_THEME", "Gruvbox-Plus-Dark")

-- Cursor (si ya definiste XCURSOR_SIZE antes, usa el valor numérico directamente)
hl.env("CURSOR_THEME", "Bibata-Modern-Classic")
hl.env("CURSOR_SIZE", "24")

-- Fuentes (asigna los valores reales en lugar de referenciar variables)
hl.env("FONT", "NombreDeTuFuente")
hl.env("FONT_SIZE", "11")
hl.env("DOCUMENT_FONT", "NombreDeTuFuenteDocumento")
hl.env("DOCUMENT_FONT_SIZE", "11")
hl.env("MONOSPACE_FONT", "NombreDeTuFuenteMono")
hl.env("MONOSPACE_FONT_SIZE", "11")

-- Tema de código y SDDM
hl.env("CODE_THEME", "NombreDeTuTemaDeCodigo")
hl.env("SDDM_THEME", "NombreDeTuTemaDeCodigo") -- Usa el mismo valor que CODE_THEME