# Kitty Configuration

## Overview

Personal [kitty](https://sw.kovidgoyal.net/kitty/) terminal configuration, kept
in `~/.config/kitty/`. It wires up a curated typeface setup (Latin + Chinese),
a dynamically-switching color scheme (driven by Quickshell), window and cursor
polish, and a fully remapped keyboard scheme.

The configuration is modular:

| File                     | Purpose                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------- |
| `kitty.conf`             | Main config: fonts, theme, window/cursor settings, includes                                                            |
| `mappings.conf`          | All keybindings (tabs, windows, layout, hints, scrolling, clipboard)                                                   |
| `fonts/en-*.conf`        | Latin font modules: `en-iosevka` (IosevkaTerm NFM), `en-jetbrains` (JetBrainsMono NFM Light), `en-ubuntu` (Ubuntu Mono derivative Powerline) |
| `fonts/cn-*.conf`        | Chinese font modules (via `symbol_map`): `cn-lxgw` (LXGW WenKai Mono), `cn-neoxihei` (NeoXiHei Code), `cn-jetbrains-maple` (JetBrains Maple Mono) |
| `themes/*.conf`          | Color schemes: tokyonight_night (base), Catppuccin-Mocha, Dracula, Kanagawa                                            |
| `current-theme.conf`     | Theme applied via kitty's theme switcher (Adwaita dark)                                                                |
| `theme-colors.conf`      | Dynamic palette written by Quickshell's `ThemeState.qml` (last theme include, overrides all above) |
| `make_default_config.sh` | Regenerates a stock `kitty.conf`                                                                                       |

> The trailing `BEGIN_KITTY_THEME` block in `kitty.conf` is managed by the
> kitty/theme tooling and takes precedence over the `include` lines above it.
> Fonts are fully owned by the `fonts/en-*.conf` / `fonts/cn-*.conf` modules.

## Included features

### Typography

- Latin font comes from one of the `fonts/en-*.conf` modules
  (**IosevkaTerm Nerd Font Mono** by default — fixed 1-cell advance for
  Latin, punctuation, and arrows). Toggle it by editing the `include` lines
  in `kitty.conf`.
- Chinese glyphs are mapped via
  `symbol_map U+3400-U+4DBF, U+4E00-U+9FFF → <cn font>` from the
  `fonts/cn-*.conf` modules (**LXGW WenKai Mono** by default; alternatives
  are NeoXiHei Code and JetBrains Maple Mono), so CJK text renders
  full-width (2 cells), matching VSCodium.
- `adjust_line_height 110%` adds breathing room between lines.

### Color scheme

- **Dynamic switching**: Quickshell's `ThemeState.qml` writes the active
  palette to `theme-colors.conf` and pushes it live via `kitty @ set-colors`.
  The file is included last in `kitty.conf`, so it overrides all other theme
  includes on startup and reload.
- Quickshell applies the same palette to **Ghostty** by writing
  `~/.config/ghostty/themes/dynamic.conf` (referenced via `config-file`) and
  signalling a `SIGUSR2` reload — so both terminals stay in sync on every
  `SUPER+T` theme switch.
- Static fallbacks shipped: Tokyo Night, Catppuccin Mocha, Dracula, Kanagawa,
  Adwaita dark (`current-theme.conf`). These are overridden by
  `theme-colors.conf` when Quickshell is running.

### Window & cursor

- `hide_window_decorations titlebar-only`
- 95% background opacity with `background_tint 0.99` and padding `1 4 4`
- Remembers window size; default 960×600
- Block cursor, blink disabled, cursor trail enabled (`cursor_trail 3`)

### Keybindings (`mappings.conf`)

- **Tabs**: create, switch, reorder, rename (`Ctrl+Alt+t/n/p`, `kitty_mod+.`/`,`/`i`)
- **Windows**: splits (`Ctrl+Alt+s`/`v`/`Enter`), resize, move, detach,
  swap, cycle/focus layouts
- **Scrolling**: line/page/home/end scrolling and scrollback search
- **Hints**: open paths, words, lines, and line numbers (`kitty_mod+f>…`)
- **Clipboard**: copy/paste, copy-then-paste a selection, open selection in a
  program
- **Misc**: edit/reload config, toggle fullscreen/maximize, font size
  `+`/`-`/`0`, clear terminal, `kitty_shell` window, broadcast kitten

> `kitty_mod` is kitty's modifier (Ctrl+Shift by default; Cmd on macOS).
