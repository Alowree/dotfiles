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
ExecStart=/usr/sbin/goimapnotify -conf %h/.config/goimapnotify/goimapnotify.yaml
Restart=always
RestartSec=10

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

---

_Generated based on local configuration files on 2026-06-05._
