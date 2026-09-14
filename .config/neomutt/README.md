---
date: 2026-08-25 11:45:00
title: Terminal Email System (NeoMutt + mbsync + goimapnotify + notmuch)
permalink: /pages/neomutt-imap
categories:
  - Tool
  - CLI
  - NeoMutt
---

A local-first, terminal-based email system that works identically on **macOS** and **Arch Linux**. Instead of living inside the IMAP server (slow, offline-incapable), mail is continuously mirrored into a local Maildir and indexed for instant search:

- **Fast**: everything is read from disk; no login delay, no network round-trips while browsing
- **Offline-capable**: read, write, reply, delete anywhere; changes propagate on next sync
- **Real-time**: an IMAP IDLE watcher pulls new mail within seconds of arrival
- **Searchable**: full-text index over all mail via `notmuch`
- **Keyboard-driven**: Vim-style navigation, Neovim composition, fuzzy attachment picking

<!-- more -->

## The Cast

| Utility                                                      | Role                                                       | Config                             |
| ------------------------------------------------------------ | ---------------------------------------------------------- | ---------------------------------- |
| **NeoMutt**                                                  | Mail user agent (read/send/manage)                         | `~/.config/neomutt/`               |
| **isync / mbsync**                                           | Two-way mirror: IMAP server ⇄ `~/.maildir/twine`           | `~/.config/isyncrc`                |
| **goimapnotify**                                             | Daemon watching IMAP IDLE; triggers sync on server events  | `~/.config/goimapnotify/`          |
| **notmuch**                                                  | Full-text index over the Maildir                           | `~/.config/notmuch/default/config` |
| **pass + GnuPG**                                             | Single credential source for NeoMutt, mbsync, goimapnotify | `~/.password-store/Email/*`        |
| **khard**                                                    | Address book (Tab completion, sender capture)              | `query_command` in `options`       |
| **nvim, w3m, zathura, mpv, LibreOffice, calcurse, yazi/fzf** | Editing, MIME rendering, attachments, calendars            | `options`, `mailcap`               |

## File Structure

```
~/.config/
├── neomutt/                             # THE MAIL USER AGENT
│   ├── neomuttrc                        # Entry point: account → options → mappings → theme
│   ├── options                          # Behavior, caching, mail checking, notmuch URL
│   ├── mappings                         # Keybindings & macros (hjkl everywhere)
│   ├── set_status                       # Status bar format (re-sourced by timeout-hook)
│   ├── mailcap                          # MIME handlers: HTML, PDF, media, Office, .ics
│   ├── themes/rebelot.neomuttrc         # Colors, index formats, timeout-hook
│   ├── accounts/
│   │   ├── twine                        # SELECTOR: sources twine-local (default) or twine-remote
│   │   ├── twine-local                  # Twine via local Maildir + SMTP  ← active mode
│   │   ├── twine-remote                 # Twine via direct IMAP (fallback mode)
│   │   ├── twine-signature              # Signature appended to outgoing mail
│   │   ├── biaget, remote-soundfreaq    # Other accounts (direct IMAP, switched via F3/F4)
│   │   └── maildir-twine*, remote-twine # Legacy variants kept for reference only
│   └── bin/
│       ├── last_sync                    # "synced 5m ago" widget fed by .mailsynclastrun
│       ├── attach_browser_yazi.sh       # Visual attachment picker (compose Ctrl-A)
│       ├── attach_browser_fzf.sh        # fzf fallback picker
│       ├── ghostty-image-viewer         # Inline images via Kitty graphics protocol
│       ├── mutt_viewcal                 # Pretty-print .ics meeting invitations
│       └── render_calendar_attachment   # Render invites inline in the pager
├── goimapnotify/                        # THE SYNC TRIGGER
│   ├── goimapnotify.yaml                # Watches INBOX → onNewMail → mail-sync-twine
│   └── bin/
│       ├── mail-sync-twine              # Orchestrator: lock → mbsync → timestamp → notmuch → notify
│       └── notify-mail                  # Cross-platform desktop notification helper
├── systemd/user/goimapnotify-twine.service  # Daemon autostart (Linux; LaunchAgent on macOS)
├── isyncrc                              # THE MIRROR: server ⇄ Maildir channel definitions
└── notmuch/default/config               # THE INDEX: database over ~/.maildir

Runtime artifacts:
~/.maildir/twine/{INBOX,Sent,Drafts,Trash,…}   # the local mirror (Maildir format)
~/.maildir/2025, ~/.maildir/2026               # local-only yearly archives (never synced)
~/.password-store/Email/…                      # credentials (decrypted via GnuPG)
~/.config/neomutt/.mailsynclastrun             # touched after every sync attempt
~/.cache/neomutt/                              # header & message caches
/tmp/mail-sync-twine.log                       # sync script log (stdout+stderr)
```

## How Everything Is Wired

```
                ┌──────────────────────────────┐
                │   IMAP server (:993 IMAPS)   │
                └──────┬───────────────▲───────┘
          IDLE push    │               │ pull / push (flags, expunge)
                       ▼               │
        ┌───────────────────────────────────────────┐
        │  goimapnotify-twine.service (daemon)      │
        │  • watches INBOX via IDLE                 │
        │  • fires "fake" sync once at its own start│
        └──────────┬────────────────────────────────┘
                   │ onNewMail (1 s debounce)
                   ▼
        ┌───────────────────────────────────────────┐    async fire-and-forget trigger,
        │  mail-sync-twine (bash)                   │◀─── also fired by NeoMutt start /
        │  1. flock guard (no concurrent runs)      │    F2 account switch / F8 manual
        │  2. mbsync twine          ────────────────┼──▶ ~/.maildir/twine (Maildir)
        │  3. touch .mailsynclastrun                │         │                    │
        │  4. notmuch new                           │         ▼                    ▼
        │  5. desktop notify if INBOX/new grew      │    notmuch index       NeoMutt
        └───────────────────────────────────────────┘    (search: S key)    (reads Maildir;
                   │                                      (S key)              rescans ≤120 s
                   ▼                                                           via mail_check)
        ~/.config/neomutt/.mailsynclastrun ──▶ bin/last_sync ──▶ status bar
                                                 (timeout-hook refreshes every 30 s)
```

### The three sync triggers

New mail reaches your local mirror through **any** of these — they are mutually redundant by design, and `flock` in `mail-sync-twine` prevents them from colliding:

1. **IDLE push** — goimapnotify sees the server announce new mail and syncs immediately (primary, real-time path).
2. **Daemon start** — goimapnotify issues a synthetic event on startup, catching anything missed while it was down (boot, resume, network loss).
3. **NeoMutt start / account switch / F8** — `accounts/twine-local` fires the script asynchronously via a backgrounded backtick, guaranteeing a fetch even if the daemon is dead or stale. This is why restarting NeoMutt always pulls fresh mail.

### Life of an incoming email

1. Mail arrives at the server; goimapnotify's IDLE socket receives `EXISTS`.
2. goimapnotify schedules `onNewMail` → `mail-sync-twine`.
3. Script takes the lock, runs `mbsync twine` → message lands in `~/.maildir/twine/INBOX/new/`.
4. Script touches `.mailsynclastrun` → status bar shows "synced 0s ago" within 30 s.
5. `notmuch new` adds it to the search index; a desktop notification fires if `new/` grew.
6. NeoMutt notices the file on its next `mail_check` poll (≤120 s) or instantly when you open the mailbox.

### Outgoing path

Compose in NeoMutt → submitted via `smtps://ud.1025.hk:465` (credentials from `pass`) → FCC copy saved to `+Sent`. On the next mbsync run, both the sent copy and any server-side changes propagate bidirectionally (`Sync All`, `Expunge Both`).

### Credentials flow

One secret, three consumers — all call `pass Email/twineintl`, which GnuPG decrypts:

- `neomuttrc` account files: ``set imap_pass = `pass Email/twineintl` `` (backtick at parse time)
- `isyncrc`: `PassCmd "pass Email/twineintl"`
- `goimapnotify.yaml`: `passwordCmd`

> **GPG gotcha:** at boot, the systemd daemon cannot pop up a pinentry dialog, so decryption fails until `gpg-agent` has been unlocked once in a terminal (e.g., running `neomutt`). See `~/.config/goimapnotify/README.md` for the full diagnosis and fixes (terminal pinentry, shell-startup preseed, cache TTLs).

### Mode selection (twine account)

`accounts/twine` is a one-line switch:

```muttrc
source ~/.config/neomutt/accounts/twine-local    # ← default: fast, offline, synced
# source ~/.config/neomutt/accounts/twine-remote # fallback: direct IMAP
```

`twine-local` is the normal mode: NeoMutt reads the Maildir mirror, sends via SMTP, and fires the startup sync trigger. `twine-remote` bypasses the mirror entirely and speaks IMAP directly — useful for debugging whether a problem lives in the sync layer or the server.

## Frequently Used Operations

### NeoMutt

| Task                                     | Keys                                                                                  |
| ---------------------------------------- | ------------------------------------------------------------------------------------- |
| Launch                                   | `neomutt`                                                                             |
| Switch account                           | `F2` twine (local) · `F3` biaget · `F4` soundfreaq                                    |
| Force a sync now                         | `F8` (runs `mail-sync-twine` in foreground)                                           |
| Navigate / open / close                  | `j` `k` · `l` open · `h` exit (everywhere)                                            |
| Compose / reply-all / reply / list-reply | `m` · `gr` · `ro` · `rl` · `F` forward                                                |
| Attach files visually                    | `Ctrl-A` in compose → Yazi multi-select                                               |
| Postpone / recall draft                  | save via compose menu · `R` to recall                                                 |
| Delete → Trash / purge / undelete        | `dd` then `$` · `D` · `u`                                                             |
| Global full-text search                  | `S` (notmuch virtual folder)                                                          |
| Filter current folder                    | `L` pattern · `x` reset filter                                                        |
| Threads                                  | `za` collapse · `zA` collapse-all · `gt`/`gT` jump                                    |
| Address book                             | `Tab` completes recipients · `A` captures sender                                      |
| Meeting invitation                       | open message → rendered invite; `Space` on the .ics part imports it into **calcurse** |
| Archives                                 | `25` / `26` jump to local-only 2025 / 2026 folders                                    |
| Sidebar                                  | `B` toggle · `Ctrl-J`/`Ctrl-K` move · `Enter` open                                    |

### goimapnotify

```bash
systemctl --user status goimapnotify-twine.service   # running?
journalctl --user -u goimapnotify-twine.service -f   # live events ("scheduled syncing …")
systemctl --user restart goimapnotify-twine.service  # kick it (also fires a catch-up sync)
tail -f /tmp/mail-sync-twine.log                     # what the script actually did
# macOS: launchctl list | grep goimapnotify ; logs in ~/.config/goimapnotify/*.log
```

Events seen in the journal: `New Email`, `Changed Flag on Email`, `Deleted Email` — each schedules the sync script ~1 s later. The `interval` in the YAML is only a fallback poll for servers without IDLE.

### mbsync

```bash
mbsync twine              # full two-way sync (what the scripts run)
mbsync -V twine           # verbose: per-box progress, Far/Near counts
mbsync -D twine           # debug: full protocol trace
mbsync twine:INBOX        # a single mailbox only
```

Notes:

- Config lives at `~/.config/isyncrc` (isync ≥ 1.5 prefers this over `~/.mbsyncrc`).
- Channel policy: `Patterns * !Junk` (everything except Junk), `Sync All` (flags + expunge both ways), `Create Near` / `Remove Near` (mirror server-side folder changes locally).
- Per-mailbox sync state is stored in hidden `.mbsyncstate` files beside each folder.

**Repairing a corrupt `.mbsyncstate`** (symptom: `Error: unterminated sync state header …`, mbsync exits 1). Do **not** just delete the file — mbsync would treat already-mirrored messages as new on both sides and duplicate them. Instead rebuild from the authoritative side:

```bash
mv ~/.maildir/twine/Sent ~/mail-backups/twine-Sent-$(date +%Y%m%d)
mkdir -p ~/.maildir/twine/Sent/{cur,new,tmp}
mbsync -V twine                                  # pulls a pristine copy + fresh state
diff <(ls backup) <(ls new)                      # sanity-check, then drop the backup
```

(Keep backups outside `~/.maildir/twine/` — the `*` pattern would otherwise try to sync them.)

### notmuch

```bash
notmuch new                    # incremental index (run automatically after every sync)
notmuch count tag:unread
notmuch search from:boss date:30d..
notmuch search --output=files subject:"invoice"
```

Inside NeoMutt, `S` gives you the same query language interactively. `synchronize_flags=true` maps Maildir flags ⇄ tags both ways (`unread`↔new, `replied`, `flagged`), so flagging in NeoMutt updates tags and vice versa. Virtual mailboxes (saved searches pinned to the sidebar) are prepared-but-commented in `options`.

### pass / GnuPG

```bash
pass Email/twineintl           # decrypt a credential (all three tools do exactly this)
pass edit Email/twineintl      # rotate a password after a server-side change
gpg-connect-agent reloadagent /bye   # after touching ~/.gnupg/gpg-agent.conf
```

If daemons fail right after reboot: unlock the key once in a terminal (any `pass` call), then `systemctl --user restart goimapnotify-twine.service`.

### mailcap-driven viewers

Open any attachment from the attachment menu (`l` plain view, `Space` mailcap view):

| Type            | Handler                                                  |
| --------------- | -------------------------------------------------------- |
| HTML body       | `w3m -dump` rendered inline in the pager                 |
| PDF / EPUB      | `zathura`                                                |
| Images          | `ghostty-image-viewer` (Kitty graphics protocol, inline) |
| Video / audio   | `mpv`                                                    |
| Excel / ODS     | LibreOffice Calc (macOS: default app via `open`)         |
| Word            | `pandoc` (.docx) / `antiword` (.doc) as text             |
| RAR             | `lsar -l` listing                                        |
| .ics invitation | imported into `calcurse` + desktop confirmation          |

## Troubleshooting Cheat Sheet

| Symptom                                | Check                                       | Likely fix                                                                  |
| -------------------------------------- | ------------------------------------------- | --------------------------------------------------------------------------- |
| No new mail after NeoMutt restart      | `tail /tmp/mail-sync-twine.log`             | Startup trigger runs the sync — see log for mbsync errors                   |
| Status bar shows "never"               | `ls -la ~/.config/neomutt/.mailsynclastrun` | Script never completed; inspect `/tmp/mail-sync-twine.log`                  |
| Log shows `mbsync exited with code: 1` | grep log for `Error:` lines                 | Corrupt `.mbsyncstate` → repair recipe above                                |
| Daemon flapping after boot             | `journalctl --user -u goimapnotify-twine`   | GPG locked; unlock via any `pass` call, then restart                        |
| Search misses recent mail              | `notmuch count *` vs file count             | `notmuch new` manually; check DB path in `~/.config/notmuch/default/config` |
| Wrong account settings active          | `cat ~/.config/neomutt/accounts/twine`      | Selector sources the wrong mode file                                        |

## References

- [NeoMutt Reference](https://neomutt.org/guide/reference) · [isync/mbsync man page](https://man.archlinux.org/man/mbsync.1) · [goimapnotify](https://github.com/shibumi/go-imapnotify) · [notmuch](https://notmuchmail.org/) · [khard](https://github.com/lucc/khard)
- Deeper dives in sibling docs: `~/.config/goimapnotify/README.md` (daemon workflow, GPG/passphrase) and `~/.config/neomutt/bin/README.md` (attachment-picker internals)
