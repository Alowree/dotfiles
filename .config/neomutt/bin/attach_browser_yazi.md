# Yazi as File Picker

This is a bash script that integrates with **yazi** (a terminal file manager) to handle file selections. Let me break it down section by section, with special attention to `attachment`.

## Overall Purpose

The script launches `yazi` as a file picker, captures the user's selected file(s), and outputs keystrokes that would simulate pasting those file paths into a text editor (likely Neovim/Vim based on the `<enter>` key syntax).

## Line-by-Line Explanation

### 1. Shebang

```bash
#!/usr/bin/env bash
```

Uses the system's `bash` interpreter to run this script.

### 2. Change Directory

```bash
cd "$HOME" || exit
```

Changes to the user's home directory. If this fails (unlikely), the script exits. This ensures yazi starts in a predictable location.

### 3. OS Detection for yazi Binary

```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
  YAZI_BIN="/opt/homebrew/bin/yazi"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  YAZI_BIN="/usr/sbin/yazi"
else
  YAZI_BIN="yazi"
fi
```

Detects the operating system and sets the correct path to the `yazi` executable:

- **macOS**: Homebrew installs it at `/opt/homebrew/bin/yazi` (Apple Silicon) or `/usr/local/bin/yazi` (Intel, though not shown here)
- **Linux (Arch)**: Installed at `/usr/sbin/yazi`
- **Other**: Falls back to looking in the system `PATH`

### 4. The Core Pipeline

```bash
$YAZI_BIN --chooser-file /dev/stdout | \
    while IFS=$'\n' read -r attachment || [[ -n "$attachment" ]]; do
        echo "push 'a$attachment<enter>'"
    done
```

This is the heart of the script:

- **`$YAZI_BIN --chooser-file /dev/stdout`**: Launches yazi in "chooser" mode, where it writes selected file paths to stdout (one per line) instead of its normal TUI interface
- **Pipe (`|`)**: Sends yazi's output to the `while` loop
- **`IFS=$'\n'`**: Sets the Internal Field Separator to newline only, preventing word splitting on spaces in filenames
- **`read -r attachment`**: Reads one line from stdin into the variable `attachment`

## The Critical Question: What is `attachment`?

**`attachment` is a plain bash variable** that gets assigned whatever `read` captures from stdin. In this context:

- Each line yazi outputs (a file path) gets stored in `attachment`
- The loop processes one file path per iteration
- The name "attachment" is descriptive—it refers to a file being "attached" to your email inside NeoMutt

## The `|| [[ -n "$attachment" ]]` Condition

This is a clever trick to handle files without trailing newlines:

- Normally, `read` returns `0` (success) when it reads a line, and `1` (failure) at EOF
- If the last line doesn't end with a newline, `read` returns `1` (failure) but still populates the variable
- The `|| [[ -n "$attachment" ]]` means: "if `read` fails, check if `attachment` is non-empty"
- If it's non-empty, the loop body still executes one more time, processing the only file path

## The Loop Body

```bash
echo "push 'a$attachment<enter>'"
```

For each selected file, this outputs a string like:

```
push 'a/path/to/file<enter>'
```

In **NeoMutt**, `push` is a command that simulates keystrokes. So:

- **`push`** = "simulate these key presses"
- **`a`** = In NeoMutt's compose mode, `a` is the **attach-file** command
- **`$attachment`** = The file path selected from yazi
- **`<enter>`** = Press Enter to confirm the attachment

So when the script outputs:

```
push 'a/Users/me/documents/report.pdf<enter>'
```

NeoMutt interprets this as: "Type 'a', then '/Users/me/documents/report.pdf', then press Enter" – which attaches that file to the email.

...

## The Big Picture

This script is part of a **NeoMutt email client** workflow. When you're composing an email and press `Ctrl+A`, it:

1. Opens `yazi` as a visual file picker
2. Lets you browse and select files to attach
3. Automatically inserts the attachment commands into NeoMutt's compose screen

The script **does NOT output to the terminal** – instead, it generates keystrokes that NeoMutt executes as if you typed them yourself.

## Complete Workflow

```
User presses Ctrl+A in NeoMutt compose mode
    ↓
NeoMutt runs: :source ~/.config/neomutt/bin/attach_browser_yazi.sh
    ↓
Script executes and outputs attachment commands
    ↓
NeoMutt "types" these commands into the compose buffer
    ↓
Files get attached to the email
```

## Detailed Explanation

### 1. NeoMutt Macro Definition

```vim
macro compose \Ca ":source ~/.config/neomutt/bin/attach_browser_yazi.sh|<enter>"
```

- **`macro compose \Ca`**: Defines a macro for the **compose** mode triggered by `Ctrl+A`
- **`:source <script>`**: Executes the bash script
- **`<enter>`**: Presses Enter to run the command

### 2. The Script's Output Format

Now we understand what the output means:

```bash
echo "push 'a$attachment<enter>'"
```

In **NeoMutt**, `push` is a command that simulates keystrokes. So:

- **`push`** = "simulate these key presses"
- **`a`** = In NeoMutt's compose mode, `a` is the **attach file** command
- **`$attachment`** = The file path selected from yazi
- **`<enter>`** = Press Enter to confirm the attachment

So when the script outputs:

```
push 'a/Users/me/documents/report.pdf<enter>'
```

NeoMutt interprets this as: "Type 'a', then '/Users/me/documents/report.pdf', then press Enter" – which attaches that file to the email.

### 3. Why the Script Does It This Way

NeoMutt's `:source` command executes the script and **reads its stdout as NeoMutt commands**. So:

- The script's `echo` statements become NeoMutt commands
- Each `push` command attaches one file
- Multiple files = multiple `push` commands = multiple attachments

### 4. What `attachment` Actually Is

In this NeoMutt context, `attachment` is **a bash variable** that stores:

- One file path from yazi's output
- Each selected file becomes one attachment
- The variable name is descriptive – it literally represents a file being attached to the email

## Complete Example

**User action:** Press `Ctrl+A` while composing an email

**What happens:**

1. NeoMutt runs the script
2. The script launches yazi, showing a file browser
3. User selects two files: `invoice.pdf` and `contract.docx`
4. yazi outputs:

   ```
   /home/user/documents/invoice.pdf
   /home/user/documents/contract.docx
   ```

5. The `while` loop processes each line:
   - First iteration: `attachment="/home/user/documents/invoice.pdf"`
     - Outputs: `push 'a/home/user/documents/invoice.pdf<enter>'`
   - Second iteration: `attachment="/home/user/documents/contract.docx"`
     - Outputs: `push 'a/home/user/documents/contract.docx<enter>'`
6. NeoMutt receives these as commands and executes them
7. Both files are now attached to the email

## Why This Approach?

**Alternative 1 (fzf):** Command-line fuzzy finder – text-based file selection  
**Alternative 2 (yazi):** Graphical terminal file manager – visual browsing with previews

The yazi approach is more user-friendly for people who prefer visual file selection with folder navigation, previews, and keyboard shortcuts.

## The `|| [[ -n "$attachment" ]]` Trick

This is especially important here because:

- If yazi outputs a file path without a trailing newline (possible with single-file selections)
- The `read` command would "fail" but still populate the variable
- This check ensures that file still gets attached, even without a newline

## Summary

| Component                 | Role                                                         |
| ------------------------- | ------------------------------------------------------------ |
| **NeoMutt macro**         | Triggers the script on `Ctrl+A` in compose mode              |
| **yazi**                  | Visual file picker – user selects files to attach            |
| **`attachment` variable** | Stores one selected file path per loop iteration             |
| **`push` command**        | NeoMutt's keystroke simulator – "types" the attach command   |
| **`a` command**           | NeoMutt's "attach file" command                              |
| **`<enter>`**             | Confirms the attachment                                      |
| **The script**            | Bridge between yazi's file list and NeoMutt's command syntax |

The script effectively translates "files selected in yazi" into "NeoMutt attach commands" – making email file attachments visual and intuitive!
