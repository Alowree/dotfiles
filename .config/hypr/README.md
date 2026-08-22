# Hyprland Configuration

Lua-based Hyprland setup for a Lenovo ThinkBook Pro 16 (AMD Radeon 680M) running Arch Linux.

- **Hyprland:** 0.56.0
- **Config provider:** Lua (`hyprland.lua`)
- **Layout:** scrolling
- **Shell:** quickshell + custom IPC (themes, app launcher, power menu)

## File Layout

```
hypr/
├── hyprland.lua              # Entry point, requires all modules
├── .luarc.json               # Lua LSP config (loads Hyprland stubs)
├── hypridle.conf             # Idle daemon (lock after 5 min)
├── hyprlock.conf             # Screen locker
├── hyprpaper.conf            # Wallpapers per monitor
└── modules/
    ├── monitors.lua          # Monitor profiles
    ├── binds.lua             # Keybindings
    ├── autostart.lua         # Startup applications
    ├── env.lua               # Environment variables
    ├── decorations.lua       # Gaps, borders, shadows, blur, animations
    ├── layout.lua            # Layout settings (scrolling)
    ├── misc.lua              # Misc behavior flags
    ├── input.lua             # Keyboard/touchpad/gestures
    └── windowrules.lua       # Window & workspace rules
```

## Modules

### monitors (`modules/monitors.lua`)

Per-location monitor profiles keyed by EDID description:

| Monitor                         | Profile                       |
| ------------------------------- | ----------------------------- |
| eDP-1 (built-in, 2560x1600@120) | Primary, anchored at `0x0`    |
| Sony TV                         | Mirrors eDP-1 (meeting room); disabled by default — toggle via `SUPER+CTRL+SHIFT+M` (`scripts/tv-toggle.sh`, switches eDP-1 to 16:9 for bars-free mirroring) |
| Dell U2723QE                    | Extended, auto-right (home)   |
| Xiaomi Mi Monitor 4K            | Extended, auto-right (office) |

A fallback rule handles any unrecognized monitor.

### Binds (`modules/binds.lua`)

Modifiers: `SUPER` (primary), `SUPER+SHIFT` (secondary), `SUPER+CTRL+SHIFT` (tertiary).

| Key                           | Action                                                                |
| ----------------------------- | --------------------------------------------------------------------- |
| `SUPER + Return`              | Terminal (ghostty)                                                    |
| `SUPER + B` / `SUPER+SHIFT+B` | Browser (chromium) / Bluetooth manager                                |
| `SUPER + F` / `SUPER+SHIFT+F` | File manager (nemo) / fullscreen                                      |
| `SUPER + Space`               | App launcher (quickshell IPC)                                         |
| `SUPER + T` / `SUPER+SHIFT+T` | Theme toggle / float toggle                                           |
| `SUPER + ESC`                 | Power menu (quickshell IPC)                                           |
| `SUPER + BACKSPACE`           | Close window                                                          |
| `SUPER + hjkl`                | Focus window                                                          |
| `SUPER+SHIFT + hjkl`          | Move window                                                           |
| `SUPER+CTRL+SHIFT + hjkl`     | Resize window (repeating)                                             |
| `SUPER + 0-9`                 | Switch workspace; `SUPER+SHIFT` moves window                          |
| `SUPER + A-Z`                 | Letter-named workspaces (AeroSpace style); `SUPER+SHIFT` moves window |
| `SUPER + mouse LMB/RMB`       | Drag / resize window                                                  |
| `SUPER + scroll`              | Cycle workspaces                                                      |
| `XF86Audio*`                  | Volume / mute / media via `wpctl` + `playerctl`                       |
| `XF86MonBrightness*`          | Brightness via `brightnessctl`                                        |
| `SUPER/SHIFT/CTRL+SHIFT + P`  | Screenshot: output / window / region (`hyprshot`)                     |
| `SUPER+CTRL+SHIFT + M`        | Meeting-room TV mirror toggle (16:9, bars-free)                       |

### Autostart (`modules/autostart.lua`)

Started on `hyprland.start`: `playerctl daemon`, quickshell, hyprpaper, hypridle, fcitx5 (Wubi input method).

### Environment (`modules/env.lua`)

Cursor sizes, Qt platform theme (`qt6ct`). IM variables are intentionally left unset for Wayland-native apps (set per-app in wrapper scripts).

### Decorations (`modules/decorations.lua`)

- Gaps 10/20, 2px gradient borders, sharp corners
- Focused/unfocused opacity 0.9/0.8
- Soft shadow, 8px 4-pass blur
- Named curves (easeOutQuint, springs, etc.) + default animation set

### Layout (`modules/layout.lua`)

- `scrolling` layout globally, `fullscreen_on_one_column`
- Dwindle `preserve_split` kept for when it's enabled

### Misc & Input (`modules/misc.lua`, `modules/input.lua`)

- Default wallpaper/logo disabled
- US layout with `caps:swapescape`, 35Hz repeat
- Touchpad: tap-to-click, natural scroll off, disable-while-typing

### Window rules (`modules/windowrules.lua`)

- Ignore maximize requests, fix XWayland drags
- Float pavucontrol, blueman, nm-connection-editor, Loupe, rofi

## Companion Tools

- **hypridle** — locks after 300s idle (`loginctl lock-session` → hyprlock)
- **hyprlock** — blurred-wallpaper locker (rotates a random wallpaper every 60s), time/date labels, password field
- **hyprpaper** — static wallpaper per monitor
- **hyprshot** — screenshots
- **quickshell** — custom shell/bar with IPC commands (`theme`, `powermenu`, `applauncher`)

## Editor / LSP

`.luarc.json` points `lua-language-server` at the autogenerated stubs in `/usr/share/hypr/stubs/` and whitelists the `hl` global for diagnostics/autocomplete.
