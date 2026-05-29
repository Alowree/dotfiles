<h1 align="center">macos-trash.yazi</h1>

<p align="center">
A compact trash manager for <a target="_blank" rel="noopener noreferrer" href="https://github.com/sxyazi/yazi">Yazi</a> on macOS, powered by the trash CLI.
</p>

![macos-trash.yazi screenshot](showcase.png)

> [!NOTE] 
>
> The `main` branch follows the design of [omni-trash.yazi](https://github.com/goon/omni-trash.yazi), while the `recycle-bin-style` branch draws inspiration from [recycle-bin.yazi](https://github.com/uhs-robert/recycle-bin.yazi). Grateful for the open‑source efforts of the original authors.

## Overview

`macos-trash.yazi` opens a modal trash view inside Yazi and works with items that are already in Trash.

It provides:

- A single table view for trashed items
- Restore for the current item or marked items
- Permanent deletion for the current item or marked items
- Mark-by-days selection for old trash entries
- Full trash empty with confirmation

## Requirements

- macOS (Ensure `.DS_Store` can be generated)
- A recent Yazi release with plugin support
- [walavave/trash-cli](https://www.github.com/walavave/trash-cli) 

> [!IMPORTANT]
>
> The original [trash-cli](https://github.com/andreafrancia/trash-cli) doesn't support macOS, check [here](https://github.com/andreafrancia/trash-cli/discussions/308).

## Installation

```sh
ya pkg add walavave/macos-trash
```

Add a keybinding in `~/.config/yazi/keymap.toml`:

```toml
[[mgr.prepend_keymap]]
{on   = "R", run  = "plugin macos-trash", desc = "Open macOS Trash"},
```

## Usage

Press your keybinding to open the modal trash list.

The table shows:

- Item name
- Volume label when available
- Deleted timestamp
- Original path

Marked items are shown with a leading `|`.

## Keybindings

| Key | Action |
| --- | --- |
| `j` / `↓` | Move down |
| `k` / `↑` | Move up |
| `<Space>` | Mark or unmark the current item |
| `r` | Restore the marked items, or the current item if nothing is marked |
| `d` | Permanently delete the marked items, or the current item if nothing is marked |
| `D` | Mark items older than `N` days |
| `E` | Empty the entire Trash |
| `q` / `Esc` | Close the modal |

## Behavior

- `D` prompts for a positive integer and marks all visible items older than that many days
- `r` restores items to their original locations through `trash restore`
- `d` permanently deletes items through `trash rm`
- `E` runs `trash empty` after confirmation
- When no items are marked, `r` and `d` act on the current row
- Paths are displayed without the macOS `/System/Volumes/Data` prefix for readability

## Notes

- This plugin manages existing trash entries. It does not send files to Trash.
- The modal reads from `trash list`, so the displayed contents depend on what your installed `trash` command exposes.
- If the plugin cannot read the trash list or cannot find `trash`, it shows a Yazi notification with the command error.

## Troubleshooting

`trash cli not found`

- Install [walavave/trash-cli](https://www.github.com/walavave/trash-cli)
- Make sure Yazi can find `trash` in `PATH`

`trash list failed`

- Run `trash list` manually and confirm it works in the same shell environment
- Verify you are using the walavave macOS-compatible implementation

`No items found that are older than N days`

- The current trash contents do not contain entries older than the requested cutoff
