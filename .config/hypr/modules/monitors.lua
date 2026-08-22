------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

-- 1. Fallback rule for any unrecognized random monitors
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

-- 2. Notebook's built-in primary display
hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	-- mode = "2560x1440@120", -- Shifts laptop from 16:10 to 16:9 (adds small bars to top/bottom of laptop instead)
	position = "0x0", -- Explicitly anchor your laptop as the top-left origin
	scale = 1,
	disabled = false,
})

-- 3. Sony TV (Meeting Room) - Configured to mirror your laptop
-- Disabled by default: hotplug auto-mirroring causes flicker on the TV.
-- Toggle with SUPER+CTRL+SHIFT+M (scripts/tv-toggle.sh): it switches eDP-1 to
-- 16:9 (2560x1440@120) first so the mirror fills the TV without black bars,
-- and restores eDP-1 when toggled off.
hl.monitor({
	-- output = "DP-2",
	output = "desc:Sony SONY TV  *02 0x01010101",
	mode = "1920x1080@60",
	position = "auto",
	-- disabled = true,
	mirror = "eDP-1", -- This forces the TV to replicate eDP-1
})

-- 4. Dell U2732QE (Home) - Configured as an extended display
-- Replace "desc:Dell Inc. U2732QE..." with your actual monitor description if needed
hl.monitor({
	output = "desc:Dell Inc. DELL U2723QE H5BJ834",
	mode = "preferred",
	position = "auto-right", -- Automatically places it to the right of your laptop
	scale = 1,
	-- mirror = "eDP-1", -- This forces the Dell monitor to replicate eDP-1
})

-- Xiaomi Mi Monitor (Office) - 4K Extended Display
hl.monitor({
	output = "desc:Xiaomi Corporation Mi Monitor 5877500057838",
	mode = "3840x2160@60",
	position = "auto-right", -- Automatically aligns it to the right of your laptop
	scale = 1, -- Set to 1.5 or 2 for comfortable UI scaling at 4K resolution
	-- mirror = "eDP-1", -- This forces the Xiaomi monitor to replicate eDP-1
})
