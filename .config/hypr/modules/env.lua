-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "30")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Input Method: X11 IM variables are only needed for X11/XWayland apps (Wine, games)
-- Native Wayland apps use the text-input protocol directly
-- These are set per-app in wrapper scripts (e.g., ~/.local/bin/wechat-im)
-- hl.env("XMODIFIERS", "@im=fcitx")
-- hl.env("GTK_IM_MODULE", "fcitx")
-- hl.env("QT_IM_MODULE", "fcitx")
