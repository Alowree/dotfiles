---
date: 2026-03-31 11:30:00
title: Auto Sync (Local ←→ Remote)
permalink: /pages/neomutt-goimapnotify
categories:
  - Tool
  - NeoMutt
---

This folder contains the configuration and scripts for `goimapnotify`, a tool that monitors your IMAP server for new emails and triggers synchronization automatically.

## Table of Contents

1. [Overview](#overview)
2. [Visual Workflow](#visual-workflow)
3. [Prerequisites](#prerequisites)
4. [Local Configuration](#local-configuration)
5. [Setup Auto-Start (macOS & Arch Linux)](#setup-auto-start)
6. [Verification & Troubleshooting](#verification--troubleshooting)

## Overview

### What is goimapnotify?

`goimapnotify` is a lightweight daemon that:

- Connects to your IMAP server and monitors specified mailboxes
- Triggers commands when new mail arrives or existing mail changes
- Runs continuously in the background
- Automatically starts at system login via macOS LaunchAgent or systemd

### Why Use goimapnotify?

| Without goimapnotify             | With goimapnotify                        |
| -------------------------------- | ---------------------------------------- |
| Manual `mbsync` execution needed | Automatic sync when new mail arrives     |
| Emails only updated on demand    | Near real-time email synchronization     |
| No notifications for new mail    | Can trigger notifications and UI updates |
| NeoMutt shows stale inbox        | NeoMutt always shows latest emails       |

## Visual Workflow

```
┌──────────────────────────────────────────────────────────────────────────┐
│                     AUTOMATIC EMAIL SYNC WORKFLOW                        │
└──────────────────────────────────────────────────────────────────────────┘

 ┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
 │   IMAP Server    │───▶│  goimapnotify    │───▶│     mbsync       │
 │                  │    │    (monitor)     │    │     (sync)       │
 │ • New email      │    │ • Detects new    │    │ • Downloads      │
 │   arrives        │    │   mail event     │    │   emails to      │
 │                  │    │ • Triggers       │    │   ~/.maildir     │
 │                  │    │   mbsync cmd     │    │                  │
 └──────────────────┘    └─────────┬────────┘    └─────────┬────────┘
                                   │                       │
                                   │                       ▼
                                   │             ┌──────────────────┐
                                   │             │    notmuch       │
                                   │             │    (index)       │
                                   │             │                  │
                                   │             │ • Indexes new    │
                                   │             │   emails for     │
                                   │             │   search         │
                                   │             └─────────┬────────┘
                                   │                       │
                                   ▼                       ▼
                         ┌──────────────────┐    ┌──────────────────┐
                         │    notify-mail   │    │    NeoMutt       │
                         │      script      │    │                  │
                         │                  │    │ • Shows new      │
                         │ • Desktop        │    │   emails         │
                         │   notification   │    │ • Searchable     │
                         │ • Sketchybar     │    │   via notmuch    │
                         │   trigger        │    │                  │
                         └──────────────────┘    └──────────────────┘
```

## Prerequisites

1. **Install goimapnotify:**

   ```bash
   go install github.com/soenggam/goimapnotify@latest
   ```

   The binary will be installed to `~/go/bin/goimapnotify`.

2. **Working mbsync setup:** Ensure your `~/.config/isyncrc` is properly configured.

3. **Dependencies:**
   - `notmuch` for email indexing
   - `terminal-notifier` (macOS) or `libnotify`/`dunst` (Linux) for notifications
   - `pass` for secure password management

## Local Configuration

### goimapnotify.yaml

Location: `~/.config/goimapnotify/goimapnotify.yaml`

This file configures the IMAP connection and the commands to run on events. Note that it uses OS-specific logic to call the correct scripts.

```yaml
configurations:
  - host: twineintlcom.securemail.hk
    port: 993
    tls: true
    username: alowree@twineintl.com
    alias: twineintl
    boxes:
      - mailbox: INBOX
        onNewMail: /Users/alowree/.config/goimapnotify/bin/mail-sync-twine
        onNewMailPost: /Users/alowree/.config/goimapnotify/bin/notify-mail 'Twine Mail' 'New email received in Twine'
```

There is already a notification function inside `mail-sync-twine`, so with the current setting inside `~/.config/goimapnotify/goimapnotify.yaml`, when new mails arrive, there will be a double-notify, one by `mail-sync-twine`, and the other by `notify-mail`. This needs to be optimized.

### Scripts (bin/)

- **`mail-sync-twine`**: A robust, cross-platform bash script that:
  1. Detects the OS (macOS or Linux)
  2. Locates `mbsync` and `notmuch`
  3. Executes the sync and indexing
  4. Triggers a desktop notification if new mail is found
- **`notify-mail`**: A cross-platform notification wrapper that supports `terminal-notifier` and `osascript` on macOS, and `notify-send` or `dunstify` on Linux

## Setup Auto-Start

### macOS (LaunchAgent)

Create `~/Library/LaunchAgents/com.user.goimapnotify.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.goimapnotify</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/alowree/go/bin/goimapnotify</string>
        <string>-conf</string>
        <string>/Users/alowree/.config/goimapnotify/goimapnotify.yaml</string>
    </array>
    <key>RunAtLoad</key><true/>
    <key>KeepAlive</key><true/>
    <key>StandardOutPath</key><string>/Users/alowree/.config/goimapnotify/stdout.log</string>
    <key>StandardErrorPath</key><string>/Users/alowree/.config/goimapnotify/stderr.log</string>
</dict>
</plist>
```

Load it with: `launchctl load ~/Library/LaunchAgents/com.user.goimapnotify.plist`

`stdout.log` and `stderr.log` in the current directory on your macOS are automatically generated by the LaunchAgent. You can add them both into the `.gitignore`, so they don't get included in the dotfiles and pushed to the remote repository.

### Arch Linux (systemd)

Create `~/.config/systemd/user/goimapnotify-twine.service`:

```ini
[Unit]
Description=goimapnotify for Twine account
After=network.target

[Service]
Type=simple
ExecStart=/usr/sbin/goimapnotify -conf /home/alowree/.config/goimapnotify/goimapnotify.yaml -log-level info
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=default.target
```

Enable it with: `systemctl --user enable --now goimapnotify-twine.service`

## Verification & Troubleshooting

### Is goimapnotify Running?

- **macOS**: `launchctl list | grep goimapnotify`
- **Linux**: `systemctl --user status goimapnotify-twine.service`
- **General**: `pgrep -x goimapnotify`

### Review Logs

On macOS:

```bash
tail -f ~/.config/goimapnotify/stdout.log
tail -f ~/.config/goimapnotify/stderr.log
```

On Arch Linux:

### How do I know if the notification daemon is currently running?

On Linux, notifications require a running daemon (like `dunst`, `mako`, or the one built into GNOME/KDE). To check if one is active:

1. **Check for known processes:**

   ```bash
   pgrep -a "dunst|mako|xfce4-notifyd"
   ```

2. **Check DBus registration:**

   Notifications use the `org.freedesktop.Notifications` name on the session bus.

   ```bash
   dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames | grep Notifications
   ```

3. **Test directly:**

   ```bash
   notify-send "Test" "Is this working?"
   ```

   If the command hangs or returns an error like "Basename: notify-send: command not found" or "GDBus.Error...NameHasNoOwner", no daemon is listening.

## Passphrase

On each restart of the computer and the terminal, `goimapnotify` is unable to connect to the twine email server, this is due to the command behind field `passwordCmd` is not properly executed. But after you run `neomutt` and key in the passphrase in the pop up terminal, the entire pipe is then fully connected. See below interactions with the shell:

```
╭╴  alowree on Arch Linux at ~ took  7s
╰─❯ systemctl --user status goimapnotify-twine.service
● goimapnotify-twine.service - goimapnotify for Twine account
     Loaded: loaded (/home/alowree/.config/systemd/user/goimapnotify-twine.service; enabled; preset: enabled)
     Active: activating (auto-restart) (Result: exit-code) since Sat 2026-06-06 16:02:08 HKT; 8s ago
 Invocation: 4b74ebd1b0fb40c4b9079c0c432b1fc6
    Process: 1464 ExecStart=/usr/sbin/goimapnotify -conf /home/alowree/.config/goimapnotify/goimapnotify.yaml -log-level info (code=exited, status=1/FAILURE)
   Main PID: 1464 (code=exited, status=1/FAILURE)
   Mem peak: 11.9M
        CPU: 43ms

╭╴  alowree on Arch Linux at ~
╰─❯ nm  # key in passphrase

╭╴  alowree on Arch Linux at ~ took  14s
╰─❯ systemctl --user status goimapnotify-twine.service
● goimapnotify-twine.service - goimapnotify for Twine account
     Loaded: loaded (/home/alowree/.config/systemd/user/goimapnotify-twine.service; enabled; preset: enabled)
     Active: active (running) since Sat 2026-06-06 16:02:29 HKT; 14s ago
 Invocation: 36b22b6611d6478cb74db1d2e2504f30
   Main PID: 1870 (goimapnotify)
      Tasks: 11 (limit: 16317)
     Memory: 13.5M (peak: 15.8M)
        CPU: 175ms
     CGroup: /user.slice/user-1000.slice/user@1000.service/app.slice/goimapnotify-twine.service
             ├─1870 /usr/sbin/goimapnotify -conf /home/alowree/.config/goimapnotify/goimapnotify.yaml -log-level info
             ├─2028 sh -c "# Detect OS and use appropriate unified script path\nif [[ \"\$(uname)\" == \"Darwin\" ]]; then\n  /Users/alowree/.config/goimapnotify/bin/mail-sync-twine\nelse\n  /home/alowree/.config/goimapnotify/bin/mail-sync-twine\nfi\n"
             ├─2030 /bin/bash /home/alowree/.config/goimapnotify/bin/mail-sync-twine
             └─2043 /usr/sbin/mbsync twine

Jun 06 16:02:29 alowree-arch-pro16 systemd[641]: goimapnotify-twine.service: Scheduled restart job, restart counter is at 4.
Jun 06 16:02:29 alowree-arch-pro16 systemd[641]: Started goimapnotify for Twine account.
Jun 06 16:02:29 alowree-arch-pro16 goimapnotify[1870]: time="2026-06-06T16:02:29+08:00" level=info msg="ℹ Running commit , tag , branch "
Jun 06 16:02:36 alowree-arch-pro16 goimapnotify[1870]: time="2026-06-06T16:02:36+08:00" level=info msg="issuing fake IMAP Event for first time sync" alias=twineintl mailbox=INBOX
Jun 06 16:02:36 alowree-arch-pro16 goimapnotify[1870]: time="2026-06-06T16:02:36+08:00" level=info msg="Watching mailbox" alias=twineintl mailbox=INBOX
Jun 06 16:02:36 alowree-arch-pro16 goimapnotify[1870]: time="2026-06-06T16:02:36+08:00" level=info msg="scheduled syncing \"New Email\" for Saturday, 06-Jun-26 16:02:37 HKT (1s in the future)" alias=twineintl mailbox=INBOX
```

Now that `pass` is able to view all your passwords inside the `.password-store` already, why `neomutt` does not login automatically but pops up a terminal asking for passphrase? Is there an option that I can possibly skip the pop up terminal and key-in of passphrase?

You have identified the core issue correctly: `pass` works in the terminal, but `goimapnotify` and `neomutt` are failing to access it automatically.

The problem isn't that `pass` is broken, but rather that **`pass` uses GnuPG (gpg) to decrypt your passwords, and GnuPG requires access to a `pinentry` program to get the passphrase for your GPG key**.

Here is what is happening step-by-step:

1. **On system startup**: `goimapnotify` tries to run your `passwordCmd` (likely something like `pass show Email/twineintl`). This command fires up `gpg` to decrypt the password file.
2. **GPG looks for `pinentry`**: `gpg` sees that your private GPG key is encrypted and needs a passphrase to unlock it. By default, it tries to launch a graphical `pinentry` program (like `pinentry-gnome3`, `pinentry-qt`, etc.).
3. **`pinentry` Fails**: Because this is happening from a systemd service or a headless context (no graphical session available or the necessary environment variables like `DISPLAY`, `DBUS_SESSION_BUS_ADDRESS` are not set correctly), the `pinentry` program fails to launch. `gpg` then returns an error, and `goimapnotify` fails to get the password.
4. **You run `neomutt`**: When you type `nm`, your terminal session has the correct environment variables. `neomutt` (or more likely, a command within it) calls `pass` or `gpg`, which this time successfully launches a `pinentry` dialog _inside your terminal_ (using `pinentry-curses` or `pinentry-tty`).
5. **The "pipe" is connected**: Once you successfully unlock your GPG key in the terminal, `gpg-agent` caches the passphrase for a certain time. Now, when `goimapnotify`'s auto-restart kicks in and runs the `passwordCmd` again, the `gpg` command finds the already-unlocked key in the agent and succeeds, providing the password without any prompt.

### The Solution: Force `gpg` to Use a Terminal `pinentry` at the System Level

The fix is to configure GnuPG globally to use a `pinentry` program that works from anywhere, not just in a full desktop session. The best option is `pinentry-curses` or `pinentry-tty`, which work in any terminal environment.

However, since `goimapnotify` is running as a systemd **user** service, it might still lack a terminal. A more robust method is to use the `loopback` mode, which allows `gpg` to get the passphrase directly from the calling program's standard input. But because `passwordCmd` doesn't allow passing arguments, that's not directly possible.

Thus, the most practical solution is to **preseed the GPG key cache** on boot.

**Here is the recommended workflow to fix your issue for good:**

1. **Set `pinentry-program` to a terminal-based version** in `~/.gnupg/gpg-agent.conf`:

   ```bash
   # ~/.gnupg/gpg-agent.conf
   pinentry-program /usr/bin/pinentry-curses
   ```

   Then restart the agent with `gpg-connect-agent reloadagent /bye`.

2. **Unlock your key on login** by adding a simple command to your shell's startup file (e.g., `~/.bashrc`, `~/.zshrc`):

   ```bash
   # At the end of your ~/.zshrc or ~/.bashrc
   pass show Email/twineintl > /dev/null 2>&1 &
   ```

   This runs `pass` in the background on every new terminal you open. It will trigger the `pinentry` prompt once, and afterward, your key is cached for the session's duration. Since you run `nm` in a terminal anyway, this step effectively makes the requirement explicit rather than implicit.

3. **Increase the cache timeout** (optional) in `~/.gnupg/gpg-agent.conf`:

   ```
   default-cache-ttl 28800
   max-cache-ttl 86400
   ```

   This keeps the passphrase cached for a longer period (8 hours and 24 hours respectively), so you won't be prompted again on every `goimapnotify` restart.

### Alternative: Configure NeoMutt to Use `pass` Directly

You mentioned that NeoMutt pops up a prompt. You can configure NeoMutt to use your `pass` credentials automatically, which might bypass the issue.

In your `neomuttrc`, you can set the IMAP password directly from the `pass` command using backticks:

```bash
# In your .neomuttrc or account-specific config file
set imap_pass=`pass show Email/twineintl`
```

This method may still trigger the `pinentry` prompt when NeoMutt first needs the password, but it will happen in a terminal context (which works) rather than a systemd service context (which fails). This could be a simpler solution than modifying `goimapnotify`, as NeoMutt is already being launched from your terminal where the environment is correct.

### Key Takeaway

You are dealing with two separate contexts: the **systemd service context** (where `goimapnotify` runs) and your **user terminal context** (where `neomutt` runs). The systemd service lacks the graphical environment to show a password prompt, causing it to fail. Running `neomutt` from your terminal unlocks the GPG key in an environment that _can_ show the prompt, and that unlocked key is then available to the systemd service when it restarts. The solution is to ensure your GPG key gets unlocked in a user context that persists, either by using terminal-based `pinentry` programs or by unlocking it automatically at shell startup.
