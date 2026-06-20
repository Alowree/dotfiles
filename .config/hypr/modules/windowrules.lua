--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.window_rule({
	name = "ghostty",
	match = { class = "com.mitchellh.ghostty" },
	-- Add specific rules for ghostty if needed, e.g., opacity
	-- opacity = 0.95,
})

-- Common floating windows
hl.window_rule({ name = "float-pavucontrol", match = { class = "pavucontrol" }, float = true })
hl.window_rule({ name = "float-pavucontrol-qt", match = { class = "org.pulseaudio.pavucontrol" }, float = true })
hl.window_rule({ name = "float-nm-editor", match = { class = "nm-connection-editor" }, float = true })
hl.window_rule({ name = "float-blueman", match = { class = "blueman-manager" }, float = true })
-- Force Loupe image viewer to open in floating mode
hl.window_rule({
	match = { class = "org.gnome.Loupe" },
	float = true,
	size = { 1080, 720 }, -- Sets a comfortable default width and height
	center = true, -- Centers the floating window on launch
})

-- Rofi styling
hl.window_rule({
	name = "rofi",
	match = { class = "Rofi" },
	float = true,
	stay_focused = true,
})

-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- What this does? Auto move the external monitor to workspace 2?
hl.workspace_rule({
	workspace = "2",
	layout = "scrolling",
})
