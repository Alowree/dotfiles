---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = "ghostty"
local fileManager = "nemo"
local browser = "chromium"

-- Capture the active window
local shotactivewindow = "hyprshot -m window -o ~/Downloads/screenshots"
-- Capture the entire screen/output
local shotentirewindow = "hyprshot -m output -o ~/Downloads/screenshots"
-- Capture a selected active window (drag and select)
local shotselectedregion = "hyprshot -m region -o ~/Downloads/screenshots"

-- rofi
-- local launcher = "rofi -show drun -show-icons"
-- local runner = "rofi -show run"

---------------------
---- KEYBINDINGS ----
---------------------

-- `SUPER` key defition as on Arch Linux 2026-06-20
-- `Windows` key on Lenovo Windows laptop orignal keyboard
-- `System` key on external SKN 4.0 keyboard

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local secondMod = "SUPER + SHIFT" -- Sets "Windows" + "Shift" key as second modifier
local thirdMod = "SUPER + CTRL + SHIFT" -- Sets "Windows" + "Ctrl" + "Shift" key as third modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

---------------------
---- WINDOW/APP ----
---------------------
-- Grouped by key. mainMod / secondMod / thirdMod variants are kept together.

-- ===== BACKSPACE =====
-- Close the focused window
hl.bind(mainMod .. " + BACKSPACE", hl.dsp.window.close())

-- ===== RETURN =====
-- Terminal
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))

-- ===== SPACE =====
-- old launcher (rofi menus)
-- hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(launcher))
-- hl.bind(secondMod .. " + Space", hl.dsp.exec_cmd(runner))
-- new launcher (quickshell)
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("qs ipc call applauncher toggle"))

-- ===== PERIOD =====
-- quickshell: Wallpaper Picker
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("qs ipc call wallpaper toggle"))

-- ===== ESCAPE =====
-- quickshell: Power Menu
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("qs ipc call powermenu toggle"))

-- ===== B =====
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser)) -- Browser chromium
hl.bind(secondMod .. " + B", hl.dsp.exec_cmd("blueman-manager")) -- Bluetooth

-- ===== F =====
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager)) -- File Manager nemo
hl.bind(secondMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" })) -- maximized still keeps the status bar
-- hl.bind(secondMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" })) -- fullscreen also removes the status bar

-- ===== M =====
-- Meeting-room TV mirror toggle (Sony TV, scripts/tv-toggle.sh)
hl.bind(thirdMod .. " + M", hl.dsp.exec_cmd("/home/alowree/.config/hypr/scripts/tv-toggle.sh"))

-- ===== T =====
-- quickshell: Theme Toggle
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("qs ipc call theme toggle"))
-- Toggle floating
hl.bind(secondMod .. " + T", hl.dsp.window.float({ action = "toggle" }))

-- ===== V =====
-- Layout specific (scrolling layout), dwindle only, disabled
-- hl.bind(mainMod .. " + V", hl.dsp.layout("togglesplit"))

-- ===== Z =====
-- Voice assistant (Nova): toggle recording on/off with one press
-- command mode: turn speech into a desktop action (open app / switch ws / find app / move windows)
hl.bind("SUPER + Z", hl.dsp.exec_cmd("~/.config/hypr/assistant/toggle.sh"))
-- chat mode: turn speech into a spoken reply from the LLM directly
hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd("~/.config/hypr/assistant/toggle_talking.sh"))

---------------------
---- NAVIGATION ----
---------------------
-- Grouped by key. mainMod / secondMod / thirdMod variants are kept together.

-- ===== H =====
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" })) -- Move focus left
hl.bind(secondMod .. " + h", hl.dsp.window.move({ direction = "left" })) -- Move window left
hl.bind(thirdMod .. " + h", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true }) -- Resize left

-- ===== L =====
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" })) -- Move focus right
hl.bind(secondMod .. " + l", hl.dsp.window.move({ direction = "right" })) -- Move window right
hl.bind(thirdMod .. " + l", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true }) -- Resize right

-- ===== K =====
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" })) -- Move focus up
hl.bind(secondMod .. " + k", hl.dsp.window.move({ direction = "up" })) -- Move window up
hl.bind(thirdMod .. " + k", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true }) -- Resize up

-- ===== J =====
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" })) -- Move focus down
hl.bind(secondMod .. " + j", hl.dsp.window.move({ direction = "down" })) -- Move window down
hl.bind(thirdMod .. " + j", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true }) -- Resize down

-- ===== MOUSE (drag/resize) =====
-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

---------------------
---- SCREENSHOTS ----
---------------------

-- ===== P =====
-- Alternative Print key binds
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(shotactivewindow)) -- Capture the entire screen/output
hl.bind(secondMod .. " + P", hl.dsp.exec_cmd(shotentirewindow)) -- Capture the active window
hl.bind(thirdMod .. " + P", hl.dsp.exec_cmd(shotselectedregion)) -- Capture a selected region (drag and select)

---------------------
---- MULTIMEDIA ----
---------------------

-- ===== VOLUME =====
-- Laptop multimedia keys for volume
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)

-- ===== BRIGHTNESS =====
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- ===== MEDIA PLAYBACK =====
-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

---------------------
---- WORKSPACE: FOCUS ----
---------------------
-- Switch to / focus a workspace

-- ===== NUMERIC 0-9 =====
-- Switch workspaces with mainMod + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
end

-- ===== LETTER WORKSPACES =====
-- Letter-named workspaces (AeroSpace style), focus with mainMod + key
hl.bind(mainMod .. " + A", hl.dsp.focus({ workspace = "name:A" })) -- Amazon
-- hl.bind(mainMod .. " + B", hl.dsp.focus({ workspace = "name:B" })) -- Occuppied by Browser
hl.bind(mainMod .. " + C", hl.dsp.focus({ workspace = "name:C" })) -- Config/Code
hl.bind(mainMod .. " + D", hl.dsp.focus({ workspace = "name:D" })) -- Design/Figma
hl.bind(mainMod .. " + E", hl.dsp.focus({ workspace = "name:E" })) -- Email/NeoMutt/Excel
-- hl.bind(mainMod .. " + F", hl.dsp.focus({ workspace = "name:F" })) -- Occuppied by File Manager
hl.bind(mainMod .. " + G", hl.dsp.focus({ workspace = "name:G" })) -- Chromium/Gmail
hl.bind(mainMod .. " + I", hl.dsp.focus({ workspace = "name:I" }))
hl.bind(mainMod .. " + M", hl.dsp.focus({ workspace = "name:M" })) -- MaraPython
hl.bind(mainMod .. " + N", hl.dsp.focus({ workspace = "name:N" })) -- MaraPython
hl.bind(mainMod .. " + O", hl.dsp.focus({ workspace = "name:O" })) -- MaraPython
-- hl.bind(mainMod .. " + P", hl.dsp.focus({ workspace = "name:P" })) -- Occuppied by screenshots
hl.bind(mainMod .. " + R", hl.dsp.focus({ workspace = "name:R" })) -- MaraPython
hl.bind(mainMod .. " + S", hl.dsp.focus({ workspace = "name:S" })) -- Safari/Brave for Amazon
-- hl.bind(mainMod .. " + T", hl.dsp.focus({ workspace = "name:T" })) -- Occupied by Theme toggle (quickshell)
hl.bind(mainMod .. " + U", hl.dsp.focus({ workspace = "name:U" }))
hl.bind(mainMod .. " + V", hl.dsp.focus({ workspace = "name:V" }))
hl.bind(mainMod .. " + W", hl.dsp.focus({ workspace = "name:W" })) -- WeChat/WhatsApp
hl.bind(mainMod .. " + X", hl.dsp.focus({ workspace = "name:X" }))
hl.bind(mainMod .. " + Y", hl.dsp.focus({ workspace = "name:Y" }))
-- hl.bind(mainMod .. " + Z", hl.dsp.focus({ workspace = "name:Z" })) -- Freed for voice assistant

-- ===== MOUSE SCROLL =====
-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- ===== SPECIAL WORKSPACE (scratchpad) =====
-- -- Show/hide the special workspace named "magic"
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))

---------------------
---- WORKSPACE: MOVE ----
---------------------
-- Move the active/ focused window to a workspace

-- ===== NUMERIC 0-9 =====
-- Move active window to a workspace with secondMod + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(secondMod .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- ===== LETTER WORKSPACES =====
-- Move active window to a letter-named workspace with secondMod + key
hl.bind(secondMod .. " + A", hl.dsp.window.move({ workspace = "name:A" }))
-- hl.bind(secondMod .. " + B", hl.dsp.window.move({ workspace = "name:B" })) -- Occuppied by Bluetooth Manager
hl.bind(secondMod .. " + C", hl.dsp.window.move({ workspace = "name:C" }))
hl.bind(secondMod .. " + D", hl.dsp.window.move({ workspace = "name:D" }))
hl.bind(secondMod .. " + E", hl.dsp.window.move({ workspace = "name:E" }))
-- hl.bind(secondMod .. " + F", hl.dsp.window.move({ workspace = "name:F" })) -- Occupped by Fullscreen
hl.bind(secondMod .. " + G", hl.dsp.window.move({ workspace = "name:G" }))
hl.bind(secondMod .. " + I", hl.dsp.window.move({ workspace = "name:I" }))
hl.bind(secondMod .. " + M", hl.dsp.window.move({ workspace = "name:M" }))
hl.bind(secondMod .. " + N", hl.dsp.window.move({ workspace = "name:N" }))
hl.bind(secondMod .. " + O", hl.dsp.window.move({ workspace = "name:O" }))
-- hl.bind(secondMod .. " + P", hl.dsp.window.move({ workspace = "name:P" })) -- Occuppied by screenshots
hl.bind(secondMod .. " + R", hl.dsp.window.move({ workspace = "name:R" }))
hl.bind(secondMod .. " + S", hl.dsp.window.move({ workspace = "name:S" }))
-- hl.bind(secondMod .. " + T", hl.dsp.window.move({ workspace = "name:T" })) -- Occupped by Toogle Float
hl.bind(secondMod .. " + U", hl.dsp.window.move({ workspace = "name:U" }))
hl.bind(secondMod .. " + V", hl.dsp.window.move({ workspace = "name:V" }))
hl.bind(secondMod .. " + W", hl.dsp.window.move({ workspace = "name:W" }))
hl.bind(secondMod .. " + X", hl.dsp.window.move({ workspace = "name:X" }))
hl.bind(secondMod .. " + Y", hl.dsp.window.move({ workspace = "name:Y" }))
-- hl.bind(secondMod .. " + Z", hl.dsp.window.move({ workspace = "name:Z" })) -- Freed for voice assistant

-- ===== SPECIAL WORKSPACE (scratchpad) =====
-- -- Move the focused window to the special workspace
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
