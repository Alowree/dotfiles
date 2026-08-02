# Kitty Configuration

## Overview

Personal [kitty](https://sw.kovidgoyal.net/kitty/) terminal configuration, kept
in `~/.config/kitty/`. It wires up a curated typeface setup (Latin + Chinese),
a dark color scheme, window and cursor polish, and a fully remapped keyboard
scheme.

The configuration is modular:

| File                     | Purpose                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------- |
| `kitty.conf`             | Main config: fonts, theme, window/cursor settings, includes                                                            |
| `mappings.conf`          | All keybindings (tabs, windows, layout, hints, scrolling, clipboard)                                                   |
| `fonts/*.conf`           | Swap-in font presets: `default` (JetBrainsMono NF), `jetbrains` (JetBrains Mono Light), `maplemono` (Maple Mono NF CN) |
| `themes/*.conf`          | Color schemes: tokyonight_night (base), Catppuccin-Mocha, Dracula, Kanagawa                                            |
| `current-theme.conf`     | Theme applied via kitty's theme switcher (Adwaita dark)                                                                |
| `theme-colors.conf`      | Hand-tuned warm/gold palette (kept as a spare, not included)                                                           |
| `make_default_config.sh` | Regenerates a stock `kitty.conf`                                                                                       |

> The trailing `BEGIN_KITTY_FONTS` and `BEGIN_KITTY_THEME` blocks in
> `kitty.conf` are managed by the kitty/theme tooling and take precedence over
> the `include` lines above them.

## Included features

### Typography

- Primary font: **IosevkaTerm Nerd Font Mono** — fixed 1-cell advance for
  Latin, punctuation, and arrows.
- Chinese glyphs are mapped via
  `symbol_map U+3400-U+4DBF, U+4E00-U+9FFF → NeoXiHei Code`, so CJK text
  renders full-width (2 cells), matching VSCodium.
- `adjust_line_height 110%` adds breathing room between lines.
- Font presets (`fonts/`) are toggled by editing the `include` lines in
  `kitty.conf`; the active preset (`fonts/jetbrains.conf`) is overridden by the
  `BEGIN_KITTY_FONTS` block.

### Color scheme

- Base theme: **Tokyo Night** (`themes/tokyonight_night.conf`).
- The kitty theme picker can override it; `current-theme.conf` (**Adwaita
  dark**) is currently applied.
- Alternatives shipped: Catppuccin Mocha, Dracula, Kanagawa.
- `theme-colors.conf` holds a spare warm/gold palette.

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
