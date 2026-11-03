--  █████╗ ███╗   ██╗██╗███╗   ███╗ █████╗  ██████╗██╗ ██████╗ ███╗   ██╗███████╗███████╗
-- ██╔══██╗████╗  ██║██║████╗ ████║██╔══██╗██╔════╝██║██╔═══██╗████╗  ██║██╔════╝██╔════╝
-- ███████║██╔██╗ ██║██║██╔████╔██║███████║██║     ██║██║   ██║██╔██╗ ██║█████╗  ███████╗
-- ██╔══██║██║╚██╗██║██║██║╚██╔╝██║██╔══██║██║     ██║██║   ██║██║╚██╗██║██╔══╝  ╚════██║
-- ██║  ██║██║ ╚████║██║██║ ╚═╝ ██║██║  ██║╚██████╗██║╚██████╔╝██║ ╚████║███████╗███████║
-- ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝

------------------------------------------------------
----- CURVAS DE ANIMACIÓN (Beziers y Springs) --------
------------------------------------------------------

-- Curvas originales
hl.curve("easeOutQuint", { type = "bezier", points = {{0.23, 1}, {0.32, 1}}})
hl.curve("easeInOutCubic", { type = "bezier", points = {{0.65, 0.05}, {0.36, 1}}})
hl.curve("linear", { type = "bezier", points = {{0, 0}, {1, 1} }})
hl.curve("almostLinear", { type = "bezier", points = {{0.5, 0.5}, {0.75, 1} }})
hl.curve("quick", { type = "bezier", points = {{0.15, 0}, {0.1, 1}}})

-- Spring original
hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, damping = 24.21279333 })

-- CURVAS BURBUJA
-- bubblePop: Se pasa de tamaño (1.4) y vuelve
hl.curve("bubblePop", { type = "bezier", points = {{0.28, 1.4}, {0.58, 1} }})
-- bubbleSoft: Rebote muy sutil (1.1) para menús y barras.
hl.curve("bubbleSoft", { type = "bezier", points = { {0.05, 1.1}, {0.1, 1.05}}})
-- bubbleQuick: Rápido y con un pequeño rebote (1.2)
hl.curve("bubbleQuick", { type = "bezier", points = { {0.2, 1.2}, {0.4, 1}}})

-- alternativo
hl.curve("bubbleSpring", { type = "spring", mass = 1, stiffness = 180, damping = 12 })


------------------------------------------------------
----------------- Animaciones ------------------------
------------------------------------------------------

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })

-- Ventanas: Apertura con efecto burbuja
hl.animation({ leaf = "windows", enabled = true, speed = 4.5, bezier = "bubblePop", style = "popin 80%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.0, bezier = "bubblePop", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.5, bezier = "linear" })

-- Fades: Suavizados con las nuevas curvas
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "bubbleSoft" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "bubbleSoft" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })

-- Capas
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "bubbleSoft" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "bubbleSoft", style = "popin 95%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })

-- Workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, bezier = "bubbleQuick", style = "slidefade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 3.0, bezier = "bubbleQuick", style = "slidefade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 3.0, bezier = "bubbleQuick", style = "slidefade" })

hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })


------------------------------------------------------
----------- Configuración de layouts -----------------
------------------------------------------------------

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})