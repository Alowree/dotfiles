-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function()
	-- hl.exec_cmd(terminal)
	-- hl.exec_cmd("nm-applet")
	-- hl.exec_cmd("waybar & hyprpaper & firefox")
	hl.exec_cmd("waybar")
	hl.exec_cmd("playerctl daemon")
	-- Autostart clipboard history daemon
	hl.exec_cmd("wl-paste --watch cliphist store")
	-- our own custom wallpapers
	hl.exec_cmd("hyprpaper")
	-- Chinese wubdi input method
	hl.exec_cmd("fcitx5 -d")
end)
