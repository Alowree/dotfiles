---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "caps:swapescape", -- Switch Caps Lock and Esc on your keyboard
		kb_rules = "",

		repeat_rate = 25,
		repeat_delay = 300,

		follow_mouse = 1,

		sensitivity = 0, -- from -1.0 - 1.0; 0 is default

		touchpad = {
			natural_scroll = false, -- Invert scroll direction
			disable_while_typing = true, -- Prevent accidental clicks
			tap_to_click = true,
			drag_lock = false,
			scroll_factor = 1.0, -- Adjust scrolling speed
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
