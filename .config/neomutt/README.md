---
date: 2025-12-03 16:20:24
title: NeoMutt 配置
permalink: /pages/neomutt
categories:
  - Tool
  - CLI
  - NeoMutt
---

This configuration, in essence, retrieves emails from the IMAP server and loads them into the local memory. This allows you to perform various mail operations on your computer that alter the status of these emails. While the original mail status is stored on your IMAP email server, an updated status is only stored locally after certain operations have been performed. Reading or deleting a new email, for example, changes the local status. However, if you exit NeoMutt directly, these status changes will not be reflected on the remote server. When you restart NeoMutt and reload emails from the IMAP server, any local email status updates from your previous login will be lost. To push the local status to your remote server, press the `$` key.

<!-- more -->

使用 NeoMutt 做为邮件客户端的益处：

- 使用 NeoVim 作为文本编辑器，手动编辑邮件速度飞快

使用 NeoMutt 做为邮件客户端的问题：

- 许多制作精美的 HTML 邮件可能无法完全渲染
- NeoMutt 的配置相当复杂，新手劝退

配置环境如下：

- 操作系统：macOS Tahoe 26.0.1
- 终端命令行：iTerm2 或 Kitty
- 文本编辑器：Neovim
- 邮件客户端：NeoMutt
- 管理联系人：khard
- 查看富文件格式的工具：w3m/zathura/imgcat

整个配置基于即时登录远程邮件服务器。当服务器邮件数量较多时，每次登录刷新邮件列表需要耗费一点时间，1000 封邮件的加载时间大约是几秒或十几秒的样子。

## 目录结构

为提高全套配置文件的可移植性，尽量把全部的配置文件放置在同一个目录下，主要的功能也采用模块化的配置文件。

```bash
~/.config/neomutt/
├── neomuttrc                # Main entry that sources everything else
├── options                  # General settings (editor, options, etc.)
├── mappings                 # Keybindings and macros
├── mailcap                  # External program handlers
├── accounts/                # Accounts and signatures
└── themes/                  # Theme
```

其中，`neomuttrc` 是配置主要入口，文件内部引用另外的几个独立的配置文件：

- `options`
- `mappings`
- `themes/rebelot.neomuttrc`
- `mailboxes`

配置了这四个文件之后，就可以在终端里顺畅地使用 NeoMutt 接收、查看、编辑、发送、回复、转发邮件，邮件客户端的基本功能已经具备。

最后的一个配置文件 `mailcap` 是在实现了最初的文本邮件的基本功能之后，再增加几个额外的功能，例如，在 NeoMutt 中查看 HTML 格式的邮件，查看 PDF 格式的附件，查看图片格式的附件，等等。这个配置文件是在 `options` 内部被引用。

## 安装工具

在 macOS 系统上，我们使用 Homebrew 来安装所有必要的软件。打开你的终端，比如我使用的是 iTerm2，运行以下命令：

```bash
brew install neomutt
brew install w3m zathura imgcat
```

## 配置文件

按照建议的目录结构创建相应的目录和文件。

### neomuttrc

主配置文件 `~/.config/neomutt/neomuttrc` 作为主要入口，依次引入其他几个配置文件：

```muttrc
# vim: set filetype=neomuttrc:

# Source general settings, mappings, and theme
source options
source mappings
# source themes/dracula.neomuttrc
source themes/rebelot.neomuttrc
source mailboxes
```

主文件依次分别引入基本配置、快捷键、主题颜色、邮箱帐户。子目录 `themes` 下有多个主题可选，这里设置使用了 `rebelot` 主题；子目录 `accounts` 下有包含默认帐户 `twine` 在内的其他多个邮箱帐户，切换各个帐户的快捷键 `F2`、`F3` 定义在 `mailboxes` 里面。

### options

```muttrc
# vim: set filetype=neomuttrc:

# set help
# set help = yes
#
# unset help                           # No help bar at the top of Index
# set help = no                        # No help bar at the top of Index

# Used when creating an email
set tmpdir = /tmp/$USER/neomutt       # Where to keep temp files

set editor = "nvim"

set imap_check_subscribed

# Pager View Options
set pager_index_lines = 10      # show 10 lines of Index when Pager is active
set pager_context = 5           # lines of context between pages
set pager_stop
set smart_wrap
set menu_scroll
set tilde
set markers = no                # do not show plus sign for wrapped lines in the pager
set allow_ansi

# Main options
set edit_headers                     # show headers when composing
set askcc                            # ask for CC:

set text_flowed = yes

set beep_new              # bell on new mails
set pipe_decode           # strip headers and eval mimes when piping
set envelope_from
set collapse_all
set uncollapse_jump
set sleep_time = 0
set mark_old = yes                   # marking new, unread emails as old when you exit a mailbox
set mime_forward = no                # forward attachments as part of body
set forward_attachments = yes
set wait_key = no
set fast_reply                       # skip to compose when replying
set fcc_attach                       # save attachments with the body
set forward_format = "Fwd: %s"       # format of subject when forwarding
set date_format = "%d.%m.%Y %H:%M"
set send_charset = "utf-8"
set assumed_charset = "utf-8:us-ascii"
set reply_regexp = "^(([Rr][Ee]?(\[[0-9]+\])?: *)?(\[[^]]+\] *)?)*"
set quote_regexp = "^( {0,4}[>|:#%]| {0,4}[a-z0-9]+[>|]+)+"
set forward_quote                    # include message in forwards
set reverse_name                     # reply as whomever it was to
set include                          # include message in replies
set mail_check = 10
set count_alternatives = yes
set auto_tag
set auto_subscribe
set flag_safe
set browser_sort = unsorted

### index sorting
# set use_threads = reverse
# set sort = last-date
set sort = reverse-date

### sidebar
set sidebar_format = "%B %<N?(%N)>%* %S"
set mail_check_stats = yes
set mail_check_stats_interval = 60
# set sidebar_visible
set sidebar_width = 30
set sidebar_folder_indent = no
set sidebar_next_new_wrap = yes
set sidebar_short_path = yes

### headers
ignore *
unignore from: to: cc: date: subject: x-label:
unhdr_order *
hdr_order from: to: cc: date: subject: x-label:

### Attachments
set mime_type_query_command = "file --mime-type -b %s"
# set mailcap_path = $HOME/.config/neomutt/mailcap
set mailcap_path = ~/.config/neomutt/mailcap
# set display_filter = "tac | sed '/\\\[-- Autoview/,+1d' | tac"
# auto_view application/ics
# auto_view text/calendar
# auto_view text/plain
# auto_view text/html
# auto_view application/pgp-encrypted
# alternative_order text/calendar text/html text/enriched text/plain text/*

# Set preferred view modes (used before but now replaced by the upper section)
# view html automatically
auto_view text/html text/calendar application/ics
alternative_order text/html text/plain text/enriched text/*

set timeout = 30

### These are the settings not categorized yet
set forward_decode                   # decode when forwarding
set attribution = "On %d, %n wrote:"
set reply_to                         # reply to Reply to: field


set sig_dashes = no                  # no default `-- ` dashes before signature
set sig_on_top = yes                 # signature shall always stick to your email body

set confirmappend = no      # don't ask, just do!
set quit                    # don't ask, just do!
set thorough_search         # strip headers and eval mimes before searching

# Status bar, date format, finding stuff etc.
set status_chars = " *%A"
set status_format = "[ Folder: %f ] [%r%m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)? ]%>─%?p?( %p postponed )?"
set sort_re

set charset = "utf-8"
set arrow_cursor = "no"

# set header_cache = ~/.cache/mutt
# set message_cachedir = ~/.cache/mutt

set header_cache = ~/.cache/neomutt/headers
set message_cachedir = ~/.cache/neomutt/bodies

set query_command = "khard email --parsable --search-in-source-files '%s'"
```

注意要点如下：

- `editor` 设置为调用 Neovim 用以编辑邮件头部和主体内容
- `query_command` 设置使用 `Tab` 键搜索和补全联系人的电邮地址：主要使用在当编辑邮件头部的表单区域，例如 `To:`/`Cc:`/`Bcc:` 等位置，需要添加电邮地址的时候，随便打几个你依稀记得的收件人姓名或者电邮地址的若干字母，然后按 `Tab` 键就可一键补全，非常快捷实用

### mappings

```muttrc
# vim: set filetype=neomuttrc:

# Read more at https://neomutt.org/guide/reference#4-%C2%A0functions

bind index L limit
macro index x "<limit>all\n" "show all messages (undo limit)"

bind index h noop
bind pager,attach h exit
bind index l display-message
bind pager l view-attachments
bind browser h goto-parent
bind browser l select-entry

# Sidebar
bind index,pager                B sidebar-toggle-visible
bind index,pager                \Cp sidebar-prev
bind index,pager                \Cn sidebar-next
bind index,pager                <Return> sidebar-open

# Email completion bindings
bind editor                     ^T complete
bind editor                     <Tab> complete-query
bind editor                     <space> noop
bind attach                     <space> view-mailcap

macro index,pager A "<pipe-message>khard add-email --headers=from,cc --skip-already-added<return>"

bind index,pager i noop
bind index,pager,attach,browser,query,alias,compose q exit
bind index t tag-entry
bind index T tag-thread
bind index * tag-pattern


# Moving around
bind index,pager,attach,browser g   noop
bind index,attach,browser       gg  first-entry
bind index,attach,browser       G   last-entry
bind pager                      gg  top
bind pager                      G   bottom

bind pager                      k   previous-line
bind pager                      j   next-line
bind pager                      <Up> previous-line
bind pager                      <Down> next-line

# Generic Menu
#
# The generic menu is not a real menu, but specifies common functions
# (such as movement) available in all menus except for pager and editor.
#
# bind index                      j   next-entry
# bind index                      k   previous-entry
# bind index                      <Up>   next-entry
# bind index                      <Down>   previous-entry

# Jump previous/next emails in pager view
bind pager                        J   next-entry
bind pager                        K   previous-entry

# 2025-12-02 stopped here
#
# Scrolling
bind attach,browser,pager,index \CF next-page
bind attach,browser,pager,index \CB previous-page
bind attach,browser,pager,index \Cu half-up
bind attach,browser,pager,index \Cd half-down
bind browser,pager              \Ce next-line
bind browser,pager              \Cy previous-line
bind index                      \Ce next-line
bind index                      \Cy previous-line

# Delete
bind index,pager                d   noop
bind index,pager                dd  delete-message
bind index,pager                D   purge-message
bind index                      u   undelete-message

# Mail & Reply
bind index,pager                r   noop
bind index,pager                gr  group-reply

bind index,pager                rl  list-reply
bind index,pager                ro  reply

# Threads
bind browser,pager,index        N   search-opposite
bind pager,index                dT  delete-thread
bind pager,index                dt  delete-subthread
bind pager,index                gt  next-thread
bind pager,index                gT  previous-thread
bind index                      z noop
bind index                      za  collapse-thread
bind index                      zA  collapse-all
bind index                      zz current-middle
bind index                      zt current-top
bind index                      zb current-bottom

# List files in $HOME with fzf and send them to attachments
# Use Tab to select multiple files and press Enter to confirm
macro compose \Ca ":source ~/.config/neomutt/bin/attach_browser_fzf.sh|<enter>"
```

### 配置签名

每个帐户使用独立的签名文件，在相应的帐户配置文件中通过 `set signature` 来指定。

例如，`twine` 帐户的签名在 `~/.config/neomutt/accounts/twine-signature` 中定义，并在 `~/.config/neomutt/accounts/remote-twine` 中通过以下命令引用：

```neomuttrc
set signature = "twine-signature"
```

### 管理联系人

1. 安装 khard

   ```bash
   brew install khard
   ```

2. 在 NeoMutt 配置文件内添加关于 khard 的配置：

   ```neomuttrc
   # =============================================================================
   # 通讯录 (Address Book)
   # =============================================================================
   # 设置 khard 为地址查询命令
   set query_command = "khard email --parsable --search-in-source-files '%s'"

   bind editor <Tab> complete-query

   # 在邮件列表或邮件内容界面按 "A" 键，将发件人添加到 khard
   macro index,pager A "<pipe-message>khard add-email<enter>"
   ```

   这个配置成功之后，在撰写邮件、添加收件人时，只需先简单敲入几个字符，例如 `mich`，然后使用 `Tab` 可以自动补全收件人 `Michael` 的电邮地址 `mchui@example.com`（当仅有一个搜索匹配时），或弹出下拉列表供选择多个待选电邮（当存在多个搜索匹配时）。

## FAQ

::: details How to re-edit a draft email in NeoMutt?

By default, use `R` key to recall a postponed message.

:::

::: details What is the difference between `delete-message` and `purge-message`?

a. `delete-message` delete the current entry (into Trash)
b. `purge-message` delete the current entry, bypassing the trash folder

To delete a message:

i. Navigate to the message you want to delete in the index.
ii. Press `dd`. The message will be marked with a 'D' flag.
iii. To move the message to the trash folder, you need to sync the mailbox. The default keybinding for this is `$`. After pressing `$`, the message will disappear from in inbox and be moved to the "+Trash" folder.

To undelete a message:

i. Go to the Trash folder
ii. Select the message, press `t` to tag the message
iii. Press `s` (for "save message"). At the "Save to mailbox:" prompt, type `+INBOX` and press Enter.

:::

::: details How to show your mailboxes in NeoMutt?
Method 1: Using the mailbox browser
In the index/pager view, press `c` to open the mailbox browser.
To see a list of all mailboxes, press `?`.

Method 2: These two steps are now combined into just one `y`.
Use the arrow keys to navigate the list and press `Enter` to switch to the selected mailbox.

:::

::: details How to add attachments to your email message?

- Press `a` to pull up the browser to jump among folders and select attachment, press `Tab` for multiple selections, press `Enter` to confirm selections.
- Press `C-a` to pull up `fzf` for file finding and selection.

:::

::: details After adding attachments, what if you added some files by mistake and you want to delete certain attachments from `attach` view?

In the `attach` menu, navigate to the attachment you want to remove using the arrow keys or `j`/`k`. Then press `D` (for `delete-attachment`) to mark it for deletion. The attachment will be removed from the list immediately. If you have multiple attachments to delete, you can tag them first by pressing `T` on each one, then press `D` to delete all tagged attachments at once.

:::

::: details Is it possible to revise an email's headers when you are already in `attach` status?

The email has been composed ready, and the UI has moved from `compose` to `attach`. Now what if we want to add additional contacts to either `To:` or `Cc:` field?

Yes, you can edit the email headers at any time before sending. Press `e` (for `edit-headers`) in the attach menu to reopen the header editor. This allows you to modify the `To:`, `Cc:`, `Bcc:`, `Subject:`, and other header fields. After making your changes, save and exit the editor to return to the attach menu.

:::

::: details What separator should I use when adding multiple email addresses to headers such as `To:` or `Cc:`?

When you have `edit_headers` enabled in NeoMutt, you should use a comma (`,`) to separate multiple email addresses within headers like `To:`, `Cc:`, and `Bcc:`.

How to Format Multiple Recipients

You can list recipients as plain email addresses or include names for better readability:

- Plain addresses:
  `To: alice@example.com, bob@example.com, carol@example.com`
- With names (RFC822 style):
  `To: Alice <alice@example.com>, Bob <bob@example.com>`

Key Rules for Editing Headers

- Comma is required: NeoMutt follows the [RFC recommendation](https://support.litera.com/article/Why-Commas-Are-Used-to-Separate-Email-Addresses-in-Campaign-Links) of using commas for address separation.
- No spaces before colons: Ensure there is no space between the header name and the colon (e.g., use `To:`, not `To :`), as NeoMutt enforces this standard strictly.
- Line continuation: If your list of recipients is very long, you can continue it on the next line by starting the new line with at least one space or tab (this is known as "header folding").

Alternative: Using Aliases

If you frequently email the same group, you can define an alias in your `~/.neomuttrc` using the same comma separator:

```bash
alias theguys alice@example.com, bob@example.com, carol@example.com
```

Then, in your editor, you can simply type `To: theguys` and NeoMutt will expand it when you send.

:::

## Core Interface Components

These are the NeoMutt terminologies when describing the various and different UI components and when navigating inside the NeoMutt application.

### 1. **index**

The main message list showing your mailbox contents. It displays headers (sender, subject, date, flags) in a tabular format.

**Purpose**: Navigation and management of email messages.

### 2. **pager**

The message viewer that displays the full content of a selected email, including headers, body, and attachments.

**Purpose**: Reading email content without opening external applications.

### 3. **attach**

The attachment menu that appears when viewing messages with MIME attachments. Allows you to save, view, or pipe attachments to external programs.

**Purpose**: Managing email attachments directly within NeoMutt.

### 4. **browser**

The file browser used for selecting mailboxes (folders), files for attaching, or directories when saving attachments.

**Purpose**: Filesystem navigation within NeoMutt.

### 5. **query**

The interface for querying external address books (LDAP, query_command, etc.) when addressing emails.

**Purpose**: Searching for contacts/addresses.

### 6. **alias**

The alias menu for selecting from your configured email aliases (often used as an address book).

**Purpose**: Quick addressing using predefined contact aliases.

### 7. **compose**

The composition screen where you write new emails, replies, or forwards. Includes editor, header fields, and attachment management.

NeoMutt creates temporary files for composition (e.g., `neomutt-hostname-PID-XXXXXX`), and Neovim is pre-configured to detect these as the `mail` filetype.

- Automatic Triggering: Neovim's default filetype detection recognizes the `neomutt-*` prefix and sets `filetype=mail`.
- Mail-Specific Defaults: The `mail` filetype comes with useful defaults like `textwidth=72` and proper quote-prefix handling (the `>` character).

Run `set filetype=?` to verify.

## Keybinding Syntax Components

```neomuttrc
bind [mode] [keysequence] [function] [description]
macro [mode] [keysequence] [actionstring] [description]
```

## 参考

- [NeoMutt Reference: Configuration Variables](https://neomutt.org/guide/reference)
- [NeoMutt: introduction to CLI email](https://www.futurile.net/2025/05/17/neomutt-email-mailbox-tutorial/)
- [NeoMutt: using IMAP and SMTP](https://www.futurile.net/2025/05/18/neomutt-email-native-imap-tutorial/)
- [NeoMutt configuration from SeniorMars](https://seniormars.com/posts/neomutt/)
