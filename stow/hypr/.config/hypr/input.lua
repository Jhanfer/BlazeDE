-- ██╗███╗   ██╗██████╗ ██╗   ██╗████████╗███████╗
-- ██║████╗  ██║██╔══██╗██║   ██║╚══██╔══╝██╔════╝
-- ██║██╔██╗ ██║██████╔╝██║   ██║   ██║   ███████╗
-- ██║██║╚██╗██║██╔═══╝ ██║   ██║   ██║   ╚════██║
-- ██║██║ ╚████║██║     ╚██████╔╝   ██║   ███████║
-- ╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝    ╚═╝   ╚══════╝

hl.config({
    input = {
        kb_layout  = "es",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 1.0,

        force_no_accel = false,
        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})