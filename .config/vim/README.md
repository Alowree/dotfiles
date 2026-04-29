# Vim Configuration (XDG Base Directory Compliant)

Official documentation and authoritative technical sources confirm that while `~/.vimrc` remains the standard location for user-specific Vim configuration, newer versions have added support for the XDG Base Directory Specification.

```bash
❯ vim --version
VIM - Vi IMproved 9.1 (2024 Jan 02, compiled Feb 21 2026 19:49:52)
macOS version - arm64
Included patches: 1-1752
Compiled by root@apple.com
Normal version without GUI.  Features included (+) or not (-):
+acl               +find_in_path      +multi_byte        -tcl
-arabic            +float             +multi_lang        +termguicolors
+autocmd           +folding           -mzscheme          +terminal
+autochdir         -footer            +netbeans_intg     +terminfo
-autoservername    +fork()            +num64             +termresponse
-balloon_eval      -gettext           +packages          +textobjects
-balloon_eval_term -hangul_input      +path_extra        +textprop
-browse            +iconv             -perl              +timers
++builtin_terms    +insert_expand     +persistent_undo   +title
+byte_offset       +ipv6              +popupwin          -toolbar
+channel           +job               +postscript        +user_commands
+cindent           +jumplist          +printer           -vartabs
-clientserver      -keymap            -profile           +vertsplit
+clipboard         +lambda            -python            +vim9script
+cmdline_compl     -langmap           -python3           +viminfo
+cmdline_hist      +libcall           +quickfix          +virtualedit
+cmdline_info      +linebreak         +reltime           +visual
+comments          +lispindent        -rightleft         +visualextra
+conceal           +listcmds          -ruby              +vreplace
+cryptv            +localmap          +scrollbind        -wayland
+cscope            -lua               +signs             -wayland_clipboard
+cursorbind        +menu              +smartindent       +wildignore
+cursorshape       +mksession         -socketserver      +wildmenu
+dialog_con        +modify_fname      -sodium            +windows
+diff              +mouse             -sound             +writebackup
+digraphs          -mouseshape        +spell             -X11
-dnd               +mouse_dec         +startuptime       -xattr
-ebcdic            -mouse_gpm         +statusline        -xfontset
-emacs_tags        -mouse_jsbterm     -sun_workshop      -xim
+eval              +mouse_netterm     +syntax            -xpm
+ex_extra          +mouse_sgr         -tabpanel          -xsmp
+extra_search      -mouse_sysmouse    +tag_binary        -xterm_clipboard
-farsi             +mouse_urxvt       -tag_old_static    -xterm_save
+file_in_path      +mouse_xterm       -tag_any_white
   system vimrc file: "$VIM/vimrc"
     user vimrc file: "$HOME/.vimrc"
 2nd user vimrc file: "~/.vim/vimrc"
 3rd user vimrc file: "$XDG_CONFIG_HOME/vim/vimrc"
      user exrc file: "$HOME/.exrc"
       defaults file: "$VIMRUNTIME/defaults.vim"
  fall-back for $VIM: "/usr/share/vim"
Compilation: gcc -c -I. -Iproto -DHAVE_CONFIG_H   -DMACOS_X_UNIX  -g -O2 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1
Linking: gcc   -L/usr/local/lib -o vim        -lm -lncurses  -liconv -framework Cocoa
```

## Official Configuration Locations

Vim searches for personal initialization files in a specific order and stops after finding the first one. For Unix-based systems (Linux and macOS), these locations include:

- Traditional: `~/.vimrc` or `~/.vim/vimrc`.
- Modern (Vim 9.1.0327+): `~/.config/vim/vimrc`.

Vim 9.1 officially adopted the Freedesktop XDG Base Directory Specification starting from patch 9.1.0327, allowing users to place configuration files under `~/.config/vim/` to avoid cluttering the home directory. You can verify if your installed version supports this by checking for `:help xdg-vimrc` or using the command `:version` within Vim to see the list of searched locations.

## Configuration Migration Debrief

This configuration migrates from the traditional Vim setup to an XDG Base Directory specification compliant structure to keep the home directory clean and organized.

- **Old Configuration Path:** `~/.vimrc` and `~/.vim/` (traditional Vim locations)
- **New Configuration Path:** `~/.config/vim/vimrc` (XDG compliant location, loaded automatically by Vim)
- **Old Cache Location:** `~/.viminfo` (session state in appropriate cache location)
- **New Cache Location:** `~/.cache/vim/viminfo` (session state in appropriate cache location)

## Directory Structure

```
~/.config/vim/
├── autoload/
│   └── plug.vim                    # vim-plug plugin manager
├── colors/
│   └── gruvbox.vim                 # Color scheme
├── plugged/                        # Installed plugins managed by vim-plug
│   ├── bullets.vim/
│   ├── coc-prettier/
│   ├── coc.nvim/
│   ├── ctrlp.vim/
│   ├── fountain.vim/
│   ├── gruvbox/
│   ├── lightline.vim/
│   ├── nerdtree/
│   ├── vim-airline/
│   ├── vim-css-color/
│   ├── vim-fugitive/
│   ├── vim-gitgutter/
│   └── vim-markdown/
├── tmp/
│   └── undodir/                    # Persistent undo history storage
├── vimrc                           # Main Vim configuration file
├── after/                          # After directory for extended configs
│   └── ftplugin/
│       └── markdown.vim            # Markdown-specific settings
└── .netrwhist                      # Netrw file browser history

# Cache directory (separate from config)
~/.cache/vim/
└── viminfo                         # Vim session state and history
```

## Configuration Overview

This setup includes:

- Plugin management via vim-plug
- A curated set of plugins for enhanced functionality
- Custom key mappings and settings
- Syntax highlighting and color schemes
- Persistent undo history
- File browsing capabilities

## Special Notes

- The main configuration file (`~/.vimrc`) is relocated at `~/.config/vim/vimrc`
- Vim automatically loads `~/.config/vim/vimrc` following XDG Base Directory specification
- The `~/.vim` directory has been removed and replaced with this XDG-compliant structure
- The `~/.viminfo` file has been relocated to `~/.cache/vim/viminfo` for XDG Base Directory compliance
- This keeps the home directory clean while preserving Vim session state in the appropriate cache location

## The .netrwhist File

The `.netrwhist` file is part of Vim's built-in netrw plugin (net read/write), which provides file browsing capabilities. This file stores:

- Visited directory history from using commands like `:Explore`, `:Sexplore`, `:Vexplore`
- File browser bookmarks and preferences
- Sorting preferences for different directories
- View settings for different directories

While this file is automatically generated by Vim's netrw plugin, it's worth noting that you primarily use the NERDTree plugin (accessed via `<Space>ee`) for file browsing. As a result, the netrw plugin and its history file are less important to your daily workflow, though netrw may still be used occasionally by certain Vim commands or when opening directories directly in Vim.

## Benefits

This organization follows modern standards for configuration management, keeping your home directory clean while maintaining full Vim functionality.
