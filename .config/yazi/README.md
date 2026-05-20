# User Guide of Own Yazi Configuration

## Shell wrapper

We suggest using this <kbd>y</kbd> shell wrapper that provides the ability to change the current working directory when exiting Yazi.

```bash
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}
```

To use it, copy the function into the configuration file of your respective shell.

Then use <kbd>y</kbd> instead of yazi to start, and press <kbd>q</kbd> to quit, you'll see the CWD changed. Sometimes, you don't want to change, press <kbd>Q</kbd> to quit.

Read [Quick Start](https://yazi-rs.github.io/docs/quick-start) multiple times until you have tried every default keybinding.

### Preview files inside Yazi

**To preview** certain file types, you will need to install some plugins to do that.

- `.docx`, `.doc`, `.pptx`, `.ppt` with docx-preview.yazi
- `.xlsx`, `.xls`, `.csv`, `.tsv` with excel-preview.yazi
- `.zip` with ouch.yazi - you will get a tree view of the compressed archive
- `.pdf` with poppler - Yazi suggested dependency for PDF preview
- `.epub` previewed structure is like that of a compressed archive, not very useful

### Open files with external app

**To open** the various files as according to their file types, inside `yazi.toml` you will need to define a couple of "openers" under the `[opener]` layer, and then call for a specific "opener" under the `[oepn]` layer.

- `.docx`, `.doc` with Microsoft Word
- `.xlsx`, `.xls` with Microsoft Excel
- `.csv`, `.tsv` with Neovim (primary) or Microsoft Excel
- `.pptx`, `.ppt` with Keynote
- `.zip` with ouch.yazi
- `.pdf` with zathura
- `.epub` with Books

## yazi.toml

## keymap.toml

## theme.toml

## plugins and init.lua

### Install a plugin

```bash
ya pkg add wylie102/duckdb
```

### Uninstall a plugin

### Own custom plugins

`plugins/excel-preview.yazi` is a locally generated plugin folder by Gemini. There is just one `main.lua` file.
