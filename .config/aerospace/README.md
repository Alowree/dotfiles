# AeroSpace Configuration

TOML-based [AeroSpace](https://github.com/nikitabobko/AeroSpace) setup for macOS, deliberately
mirroring the Hyprland + quickshell workspace/keybind layout used on the Arch Linux ThinkBook.

- **AeroSpace:** tiling window manager for macOS
- **Config file:** `~/.config/aerospace/aerospace.toml`
- **Layout:** tiles (default) / accordion
- **Modifier:** `alt` (Option) — physical twin of `SUPER` on Arch

## Modifier mapping

AeroSpace uses `alt` where Hyprland uses `SUPER`; the muscle memory transfers 1:1.

| Arch (Hyprland)        | macOS (AeroSpace)    |
| ---------------------- | -------------------- |
| `SUPER`                | `alt`                |
| `SUPER + SHIFT`        | `alt + shift`        |
| `SUPER + CTRL + SHIFT` | `alt + ctrl + shift` |

## File Layout

```
aerospace/
├── aerospace.toml   # All AeroSpace configuration
└── README.md        # This document
```

## Features

- **Tiling layouts** — `tiles` and `accordion`, switchable per-workspace; root orientation
  is `auto` (wide monitor → horizontal, tall monitor → vertical).
- **Normalization** — flatten redundant containers and auto-rotate orientation of nested
  containers for a predictable tree.
- **Gaps** — 4px inner/outer (0px top) gaps.
- **Workspaces** — numeric `1-10` plus letter-named workspaces (below); all persistent so the
  empty ones stay alive and visible in the menu bar.
- **App routing** — `on-window-detected` sends apps to their designated workspace (and floats
  Finder).
- **Binding modes** — `main` (default) and `service` (tile surgery / workspace reset).
- **Mouse follows focus** — cursor auto-centers on focused window / monitor.
- **JankyBorders** — launched via `after-startup-command`; 2px active/inactive borders.
- **Auto-login** — `start-at-login = true`.

## Workspaces

Numeric workspaces `1`–`10` (`alt-0` selects `10`). Letter workspaces and their purpose:

| Letter | Purpose              | Letter | Purpose        |
| ------ | -------------------- | ------ | -------------- |
| `C`    | Config / Code        | `Q`    | (unassigned)   |
| `D`    | Design / Figma       | `R`    | (unassigned)   |
| `E`    | Email                | `S`    | Safari / Brave |
| `G`    | Gmail / Chromium     | `U`    | (unassigned)   |
| `I`    | (unassigned)         | `V`    | (unassigned)   |
| `M`    | Mail (Outlook/Apple) | `W`    | WeChat         |
| `N`    | (unassigned)         | `X`    | (unassigned)   |
| `O`    | (unassigned)         | `Y`    | (unassigned)   |
|        |                      | `Z`    | Zen            |

Letters `A`, `B`, `F`, `P`, `T` are **not** workspaces — they are reserved for actions,
matching Arch: `A` is held for Neovim, `B` = browser, `F` = Finder, `P` = screenshots,
`T` = theme (dark-mode) toggle.

### App routing (`on-window-detected`)

| App (bundle id)               | Rule            |
| ----------------------------- | --------------- |
| Brave, Safari                 | → workspace `S` |
| Google Chrome                 | → workspace `G` |
| Figma                         | → workspace `D` |
| Finder                        | floating        |
| Microsoft Outlook, Apple Mail | → workspace `M` |

## Keybindings

### Main mode

| Keys                          | Action                                     |
| ----------------------------- | ------------------------------------------ |
| `alt + enter`                 | Terminal (Ghostty)                         |
| `alt + backspace`             | Close window                               |
| `alt + space`                 | Launcher (Spotlight)                       |
| `alt + b`                     | Browser (Brave)                            |
| `alt + f`                     | File manager (Finder, home)                |
| `alt + t`                     | Toggle dark mode (quickshell theme ≈)      |
| `alt + h` / `alt + l`         | Focus left / right                         |
| `alt + shift + h/j/k/l`       | Move window left / down / up / right       |
| `alt + ctrl + shift + h/l`    | Resize width −50 / +50                     |
| `alt + ctrl + shift + j/k`    | Resize height +50 / −50                    |
| `alt + minus` / `alt + equal` | Resize smart −50 / +50                     |
| `alt + 0-9`                   | Switch to workspace `10` / `1-9`           |
| `alt + A-Z`                   | Switch to letter workspace                 |
| `alt + shift + 0-9`           | Move window to workspace `10` / `1-9`      |
| `alt + shift + A-Z`           | Move window to letter workspace            |
| `alt + tab`                   | Back-and-forth between last two workspaces |
| `alt + shift + tab`           | Move workspace to next monitor             |
| `alt + /`                     | Layout: tiles, toggle h/v orientation      |
| `alt + ,`                     | Layout: accordion, toggle h/v orientation  |
| `alt + p`                     | Screenshot: full output                    |
| `alt + shift + p`             | Screenshot: active window                  |
| `alt + ctrl + shift + p`      | Screenshot: selected region                |
| `alt + shift + f`             | Toggle fullscreen                          |
| `alt + shift + t`             | Toggle floating / tiling                   |
| `alt + shift + ;`             | Enter `service` mode                       |

### Service mode (`alt + shift + ;` to enter)

| Keys                    | Action                                    |
| ----------------------- | ----------------------------------------- |
| `esc`                   | Reload config, back to main mode          |
| `r`                     | Flatten workspace tree (reset tiles)      |
| `f`                     | Toggle floating / tiling                  |
| `backspace`             | Close all windows but current             |
| `alt + shift + h/j/k/l` | Join window with left / down / up / right |

### Deliberate differences from Arch

- **`alt + j/k` focus** — reserved for Neovim; focus is `alt + h/l` only.
- **`alt + a`** — reserved for Neovim; workspace `A` is unbound on macOS.
- **No scroll-cycle** — workspace cycling on Arch (`SUPER + scroll`) maps to `alt + tab`
  back-and-forth instead.
- **Power menu** — no equivalent to quickshell's `SUPER + ESC` powermenu; use the macOS
  Apple menu / lock screen.

## Comparison: AeroSpace vs Hyprland + quickshell

| Action                      | Hyprland (Arch)                                | AeroSpace (macOS)                    |
| --------------------------- | ---------------------------------------------- | ------------------------------------ |
| Terminal                    | `SUPER + Return` (ghostty)                     | `alt + enter` (Ghostty)              |
| Browser                     | `SUPER + B` (chromium)                         | `alt + b` (Brave)                    |
| File manager                | `SUPER + F` (nemo)                             | `alt + f` (Finder)                   |
| Close window                | `SUPER + Backspace`                            | `alt + backspace`                    |
| App launcher                | `SUPER + Space` (quickshell IPC)               | `alt + space` (Spotlight)            |
| Theme toggle                | `SUPER + T` (quickshell IPC)                   | `alt + t` (dark mode)                |
| Power menu                  | `SUPER + Esc` (quickshell IPC)                 | — (Apple menu / lock screen)         |
| Focus direction             | `SUPER + h/j/k/l`                              | `alt + h/l` (`j/k` held for Neovim)  |
| Move window                 | `SUPER + Shift + h/j/k/l`                      | `alt + shift + h/j/k/l`              |
| Resize window               | `SUPER + Ctrl + Shift + h/j/k/l`               | `alt + ctrl + shift + h/j/k/l`       |
| Fullscreen                  | `SUPER + Shift + F` (maximized)                | `alt + shift + f`                    |
| Toggle float                | `SUPER + Shift + T`                            | `alt + shift + t`                    |
| Switch workspace            | `SUPER + 0-9`                                  | `alt + 0-9` (`0` = ws `10`)          |
| Move window → workspace     | `SUPER + Shift + 0-9`                          | `alt + shift + 0-9`                  |
| Switch letter workspace     | `SUPER + A-Z`                                  | `alt + A-Z` (subset, B/F/P/T freed)  |
| Move window → letter ws     | `SUPER + Shift + A-Z`                          | `alt + shift + A-Z`                  |
| Cycle workspaces            | `SUPER + scroll`                               | `alt + tab` (back-and-forth)         |
| Screenshot output           | `SUPER + P` (hyprshot)                         | `alt + p` (screencapture)            |
| Screenshot window           | `SUPER + Shift + P` (hyprshot)                 | `alt + shift + p` (screencapture)    |
| Screenshot region           | `SUPER + Ctrl + Shift + P` (hyprshot)          | `alt + ctrl + shift + p`             |
| Bluetooth manager           | `SUPER + Shift + B` (blueman)                  | —                                    |
| Mouse drag / resize         | `SUPER + LMB / RMB`                            | — (macOS native)                     |
| Volume / media / brightness | `XF86*` keys (wpctl, playerctl, brightnessctl) | — (macOS native keys)                |
| Status bar                  | quickshell                                     | macOS menu bar (sketchybar optional) |

### quickshell feature mapping

| quickshell (Arch)    | macOS equivalent                        |
| -------------------- | --------------------------------------- |
| App launcher IPC     | Spotlight (`alt + space`)               |
| Power menu IPC       | Apple menu / lock screen                |
| Theme toggle IPC     | Appearance dark-mode toggle (`alt + t`) |
| Status bar / widgets | macOS menu bar (sketchybar available)   |

## Notes

- `alt + backspace` captures Option+Backspace (delete-word) while AeroSpace is active; use
  `alt + shift + backspace` if you rely on the word-delete behavior.
- Terminals open on the **current** workspace (no auto-assignment to `T`), matching Arch.
- The AeroSpace CLI lives at `~/.aerospace/bin/aerospace`; reload with
  `aerospace reload-config` after editing.
