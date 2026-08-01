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
	-- hl.exec_cmd("waybar")
	-- mpris media player command-line controller for vlc, mpv, RhythmBox, web browsers, cmus, mpd, spotify and others.
	-- See https://github.com/altdesktop/playerctl
	hl.exec_cmd("playerctl daemon")
	-- our own custom bar and shell
	hl.exec_cmd("quickshell")
	-- our own custom wallpapers
	hl.exec_cmd("hyprpaper")
	-- Hyprland's idle daemon
	hl.exec_cmd("hypridle")
	-- Chinese Wubi input method
	hl.exec_cmd("fcitx5 -d")
end)
