# NeoMutt Attachment Browser Scripts

This directory contains helper scripts for NeoMutt, specifically for attaching files in `compose` mode. There are two primary scripts configured to work seamlessly across macOS and Arch Linux:

- `attach_browser_yazi.sh`: Uses [Yazi](https://github.com/sxyazi/yazi) as the file browser.
- `attach_browser_fzf.sh`: Uses [fzf](https://github.com/junegunn/fzf) as the file browser.

Both scripts can be integrated into NeoMutt's compose mode via a macro in your `mappings` configuration:

```neomuttrc
macro compose \Ca ":source ~/.config/neomutt/bin/<script_name>.sh|<enter>"
```

## Comparison: Yazi vs. FZF

When choosing which browser to use for attaching files, **Yazi is highly recommended** over fzf for this specific use case. Below is a detailed breakdown of the features and common questions associated with each option.

## Option A: Yazi (`attach_browser_yazi.sh`)

```attach_browser_yazi.sh
#!/usr/bin/env bash

# cd to the root folder of attachments
cd "$HOME" || exit

# Detect OS to set the correct path for yazi
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS (usually installed via Homebrew)
  YAZI_BIN="/opt/homebrew/bin/yazi"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Arch Linux
  YAZI_BIN="/usr/sbin/yazi"
else
  # Fallback to PATH if neither
  YAZI_BIN="yazi"
fi

# The additional  || [[ -n "$attachment" ]]  check ensures that
# if a line is read but has no trailing newline (making `read` return `false` ),
# the loop body will still run one last time to process the content populated in $attachment
$YAZI_BIN --chooser-file /dev/stdout | \
    while IFS=$'\n' read -r attachment || [[ -n "$attachment" ]]; do
        echo "push 'a$attachment<enter>'"
    done
```

Yazi is a fast, terminal-based file manager written in Rust.

**Will Yazi work as intended, i.e., support file preview for attachment files browsing and selection process?**

**Yes, perfectly.** Yazi comes with built-in, out-of-the-box support for image previews. It natively detects and utilizes terminal graphic protocols (like Kitty, iTerm2, Sixel, and Ueberzug++ for X11/Wayland). As long as your terminal supports one of these protocols, Yazi will render high-quality previews for attachments seamlessly. Yazi also supports preview of many other file types, such as `.docx`, `.xslx`, `.pdf`, and so on.

**Does it support selecting multiple files?**

**Yes.** By passing the `--chooser-file /dev/stdout` flag to Yazi, you can select multiple files (using `Space` or `v` to highlight, `Tab` to jump select, then `Enter` to confirm). The script reads all selected files line-by-line and pushes them to NeoMutt natively.

**Navigation:** Yazi provides full directory tree navigation, making it easy to browse up and down your filesystem organically.

Let's break down each part of your script.

### The `exit` command

**What it does:**

```bash
cd "$HOME" || exit
```

- `cd "$HOME"` attempts to change the current working directory to your home folder (`~`).
- `||` means "if the previous command fails (very unlikely though), run the next command."
- `exit` terminates the entire script immediately with a non-zero (error) status.

**Is it necessary?**

- **Strictly speaking, no** — if `cd "$HOME"` succeeds, the script continues normally; if it fails, the script would continue in whatever directory it was already in (which might be unexpected).
- However, it's **good defensive programming** because:
  - The script relies on being in a predictable directory (your home folder) for Yazi to browse attachments properly.
  - If `cd` fails (e.g., `$HOME` is unset or points to a non-existent path), running Yazi from an unknown directory could cause confusion or errors.
  - Without `|| exit`, the script would silently ignore the failure and proceed, potentially causing Yazi to open in the wrong location.

**What if without it?**

- The script would attempt to `cd "$HOME"`, but if that fails, the script would keep running from the current working directory where it was invoked (likely where NeoMutt launched it). This might be anywhere (e.g., `/tmp`, `/var/mail`, etc.), and Yazi would show the wrong folder, confusing the user.

### Breakdown of the last code block

```bash
$YAZI_BIN --chooser-file /dev/stdout | \
    while IFS=$'\n' read -r attachment || [[ -n "$attachment" ]]; do
        echo "push 'a$attachment<enter>'"
    done
```

This is the heart of the script, so let's go piece by piece:

- `$YAZI_BIN`: Expands to the path to the Yazi binary (set earlier in the script). This launches the Yazi file manager.
- `--chooser-file /dev/stdout`: Yazi's `--chooser-file` option tells it to write the selected file path(s) to a specified file instead of its usual terminal output. By setting it to `/dev/stdout`, Yazi writes the chosen file path directly to the standard output (`stdout`) of the script. This allows the pipeline to capture the selection.
- `|`: Pipes the `stdout` of Yazi (which contains the selected file path(s)) to the input of the `while` loop.
  - `while IFS=$'\n' read -r attachment; do ... done`: A `while` loop that reads lines from stdin one at a time.
    - `IFS=$'\n'` sets the Internal Field Separator to only newline, so that spaces or tabs in filenames are not treated as separators.
    - `read -r` reads a line literally (backslashes are not interpreted as escape characters).
    - `attachment` stores each line (i.e., each selected file path).
  - `echo "push 'a$attachment<enter>'"`: For each selected file, this prints a string like `push 'a/path/to/file<enter>'`. This is a NeoMutt macro command:
    - `push` tells NeoMutt to simulate keystrokes.
    - `a` is the keybinding for `attach-file` command ("attach files to this message") in NeoMutt's compose view.
    - `$attachment` is the file path chosen in Yazi.
    - `<enter>` simulates pressing the Enter key, which confirms the save operation.
    - **Result:** These printed lines become commands that NeoMutt will execute to add the selected attachments to the chosen paths.

### The Critical Question: What is `attachment`?

**`attachment` is a plain bash variable** that gets assigned whatever `read` captures from stdin. In this context:

- Each line yazi outputs (a file path) gets stored in `attachment`
- The loop processes one file path per iteration
- The name "attachment" is descriptive—it refers to a file being "attached" to your email inside NeoMutt

Run `tldr read` or `man read` inside your shell for more information.

### The `|| [[ -n "$attachment" ]]` Condition

This is a clever trick to handle the file (the **single** file selection or the **last** selection of multiple file selections) without trailing newlines:

- Normally, `read` returns `0` (success) when it reads a line, and `1` (failure) at EOF
- If the last line doesn't end with a newline, `read` returns `1` (failure) but still populates the variable
- The `|| [[ -n "$attachment" ]]` means: "if `read` fails, check if `attachment` is non-empty"
- If it's non-empty, the loop body still executes one more time, processing the only file path

### What happens overall

1. Yazi opens (in your home folder) and lets you select one or more files.
2. Each selected file path is written to `stdout`, one per line.
3. The `while` loop reads each path and builds a NeoMutt `push` command that simulates pressing `a` (add attachment), the file path, and Enter.
4. These commands are printed to `stdout`, which NeoMutt captures and executes as if you typed them manually — effectively automating the "add attachment" process with a visual file picker.

### Nesting relationship

The following block diagram illustrates the nesting relationship among the shell (Zsh), NeoMutt, and Yazi, showing how commands flow between processes:

```
┌───────────────────────────────────────────────────────────────────────────────┐
│                              Zsh Shell (Parent)                               │
│                                                                               │
│  ┌─────────────────────────────────────────────────────────────────────────┐  │
│  │                      NeoMutt (Child Process)                            │  │
│  │                                                                         │  │
│  │  User presses macro: \Ca                                                │  │
│  │  ↓                                                                      │  │
│  │  NeoMutt executes: source ~/.config/neomutt/bin/attach_browser_yazi.sh  │  │
│  │  ↓                                                                      │  │
│  │  NeoMutt forks and executes the script as a subshell                    │  │
│  │                                                                         │  │
│  │  ┌───────────────────────────────────────────────────────────────┐      │  │
│  │  │           Script Subprocess (attach_browser_yazi.sh)          │      │  │
│  │  │                                                               │      │  │
│  │  │  1. cd "$HOME"                                                │      │  │
│  │  │  2. Detect OS → set YAZI_BIN path                             │      │  │
│  │  │  3. Execute: $YAZI_BIN --chooser-file /dev/stdout             │      │  │
│  │  │     ↓                                                         │      │  │
│  │  │  ┌────────────────────────────────────────────────────────┐   │      │  │
│  │  │  │              Yazi (Child of Script)                    │   │      │  │
│  │  │  │                                                        │   │      │  │
│  │  │  │  - Opens TUI file manager in home directory            │   │      │  │
│  │  │  │  - User selects files (Space/v to highlight)           │   │      │  │
│  │  │  │  - User presses Enter to confirm                       │   │      │  │
│  │  │  │  - Yazi writes selected paths to /dev/stdout           │   │      │  │
│  │  │  │    (one path per line)                                 │   │      │  │
│  │  │  │                                                        │   │      │  │
│  │  │  └────────────────────────────────────────────────────────┘   │      │  │
│  │  │                                                               │      │  │
│  │  │  Yazi's stdout is piped (|) to while loop:                    │      │  │
│  │  │  while IFS=$'\n' read -r attachment; do                       │      │  │
│  │  │      echo "push 'a$attachment<enter>'"                        │      │  │
│  │  │  done                                                         │      │  │
│  │  │     ↓                                                         │      │  │
│  │  │  Script writes keystroke commands to its stdout               │      │  │
│  │  │                                                               │      │  │
│  │  └───────────────────────────────────────────────────────────────┘      │  │
│  │                                                                         │  │
│  │  NeoMutt captures script's stdout (the echo'ed commands)                │  │
│  │  NeoMutt interprets these as keyboard input (push commands)             │  │
│  │  NeoMutt executes the push commands:                                    │  │
│  │    ↓                                                                    │  │
│  │  NeoMutt simulates keypresses: "a/path/to/file<enter>"                  │  │
│  │  NeoMutt's internal command handler processes the "attach-file"         │  │
│  │  operation (triggered by the 'a' keybinding)                            │  │
│  │                                                                         │  │
│  └─────────────────────────────────────────────────────────────────────────┘  │
│                                                                               │
└───────────────────────────────────────────────────────────────────────────────┘
```

**Explanation of command flow:**

- **What takes in the `echo`'ed command?**  
  The `echo` commands are written to the script's standard output (`stdout`). Because NeoMutt executes the script via `source` or command substitution, **NeoMutt captures the script's entire stdout stream**. The captured text is then processed as if the user had typed it directly into NeoMutt's command line. NeoMutt reads these lines as a sequence of `push` commands, which are internal NeoMutt directives to simulate keyboard input.

- **What takes in the `push`'ed command?**  
  The `push` command is a NeoMutt internal instruction. When NeoMutt encounters `push` in the captured output, it **interprets the argument as a series of keystrokes to simulate**. Specifically, `push 'a$attachment<enter>'` tells NeoMutt to:
  1. Press the `a` key (which is bound to the `attach-file` command in NeoMutt's compose view).
  2. Type the file path (`$attachment`).
  3. Press the Enter key to confirm and execute the attachment operation.

  The `push`ed command is **processed entirely within NeoMutt's own keystroke interpreter** — it is not passed back to the shell or to Yazi. This allows Yazi's graphical file selection to be translated into automated keystrokes that NeoMutt understands natively, effectively making Yazi a visual attachment picker for NeoMutt.

**Key insight:** The script generates keystroke commands that NeoMutt interprets, allowing Yazi to act as a graphical file picker for adding email attachments. The nesting relationship forms a chain: **Zsh → NeoMutt → Script → Yazi → Script → NeoMutt**, where the script acts as a bridge between Yazi's output and NeoMutt's input.

The `push` command in NeoMutt is a powerful tool for automation. It tells NeoMutt to simulate a sequence of keystrokes as if they were typed by the user. Its primary and most effective use is for **automating complex or repetitive workflows** in contexts where a simple keybinding is not flexible enough.

### Practical Use Cases for `push`

Based on community examples, here are some typical scenarios where `push` proves useful:

1. **Dynamic Macros with External Data**: This is the most common application. `push` is used to execute a macro that depends on dynamically generated data.
   - **The Problem**: A standard macro is evaluated only once when NeoMutt starts. If you need a macro to use a filename that changes (e.g., from a file picker), a simple macro won't work .
   - **The Solution with `push`**: The solution is to create a two-macro system :
     1. **Macro A**: This macro runs an external command (like `ranger`) to generate data (e.g., a file path) and saves it to a file or environment variable. It then uses `source` to reload a configuration file that defines Macro B.
     2. **Macro B**: This is a generic macro (e.g., bound to `W`) that performs the final action (like `<attach-file>`) using the newly generated data.
     3. **The Role of `push`**: The final step of Macro A is to execute Macro B. It does this by running `<enter-command>push W<enter>`. This `push` command simulates pressing the key bound to Macro B, immediately triggering it within the current context. This allows the workflow to run in a single, seamless user action.

2. **Chaining Commands**: In more advanced configurations, `push` can be used to chain several actions together. For example, a macro to schedule an email for later delivery might use `push` to postpone a message (`<postpone-message>`), change to a drafts folder (`<change-folder>`), and then pipe the message to an external script .

### When is `push` Most Useful?

The `push` command is specifically valuable in the following circumstances:

- When you need to **work around NeoMutt's static macro evaluation**. As described above, it enables macros that interact with dynamic content from external sources.
- When you want to **create multi-step "wizards" or scripts**. By simulating keystrokes, `push` allows you to execute a predefined sequence of NeoMutt commands that goes beyond what a single, static command can achieve.
- When you need to **automate interactions with NeoMutt's interface**. This is useful for piping the output of a script (like your Yazi file picker) directly into NeoMutt's command stream.

In your Yazi script example, the `echo`ed `push` commands are the final step. The `push` command tells NeoMutt to press the `a` key (for attaching files) followed by the selected file path and Enter, thus integrating the output of the external file browser directly into NeoMutt's compose process.

## Option B: FZF (`attach_browser_fzf.sh`)

`fzf` is a general-purpose command-line fuzzy finder. In this setup, it filters a predefined list of files generated by `fd`.

**Will the `fzf.sh` version be improved by fzf + ueberzug++ for supporting image preview?**

**Technically yes, but practically it is very cumbersome.** Using `fzf` with `ueberzug++` requires a complex wrapper script (often using FIFOs) to start a background server, calculate coordinate layouts dynamically, send JSON commands for image rendering, and handle cleanup upon exit. It is extremely fragile compared to Yazi's native integration. While modern `fzf` can use `chafa` for terminal previews, it still lacks native PDF and archive preview rendering out of the box.

**Why is `export FZF_DEFAULT_COMMAND` necessary if the variable is never explicitly called in the script?**

`fzf` is a generic text filter. When no text is piped into it, it automatically falls back to a standard `find` command to populate its list. However, `fzf` is hardcoded to read the `FZF_DEFAULT_COMMAND` environment variable under the hood. By `export`ing this variable, `fzf` inherits it when executed and magically replaces the default `find` with your custom `fd` command. Without `export`, the variable would not reach `fzf`'s environment, and it would display every single file in your home directory instead of filtering for specific attachment types.

**Navigation:** `fzf` flattens the output of `fd` into a single, searchable list. While fast, it lacks natural directory traversal if you aren't exactly sure what you're looking for.
