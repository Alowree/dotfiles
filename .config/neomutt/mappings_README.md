# NeoMutt Functions Reference — Custom Mappings Comparison

> Source: [NeoMutt Reference §4. Functions](https://neomutt.org/guide/reference#4-%C2%A0functions)
>
> The following is the list of available functions listed by the mapping in which they are available. The default key setting is given, and an explanation of what the function does. The key bindings of these functions can be changed with the `bind` command.
>
> | Column          | Meaning                                                          |
> | --------------- | ---------------------------------------------------------------- |
> | **Default key** | Original NeoMutt key binding                                     |
> | **Defined key** | Your custom binding from `mappings` (`(none)` = default applies) |

## 4.1. Generic Menu

> The generic menu is not a real menu, but specifies common functions (such as movement) available in all menus except for _pager_ and _editor_. Changing settings for this menu will affect the default bindings for all menus (except as noted).

| Function              | Default key   | Defined key         | Description                                    |
| --------------------- | ------------- | ------------------- | ---------------------------------------------- |
| `<bottom-page>`       | L             | (none)              | Move to the bottom of the page                 |
| `<check-stats>`       | (none)        | (none)              | Calculate message statistics for all mailboxes |
| `<current-bottom>`    | (none)        | zb                  | Move entry to bottom of screen                 |
| `<current-middle>`    | (none)        | zz                  | Move entry to middle of screen                 |
| `<current-top>`       | (none)        | zt                  | Move entry to top of screen                    |
| `<end-cond>`          | (none)        | (none)              | End of conditional execution (noop)            |
| `<enter-command>`     | :             | (none)              | Enter a neomuttrc command                      |
| `<exit>`              | (none)        | q, q, h             | Exit this menu                                 |
| `<first-entry>`       | <Home>        | gg                  | Move to the first entry                        |
| `<first-entry>`       | \=            | gg                  | Move to the first entry                        |
| `<half-down>`         | \]            | \CD                 | Scroll down 1/2 page                           |
| `<half-up>`           | \[            | \CU                 | Scroll up 1/2 page                             |
| `<help>`              | ?             | (none)              | This screen                                    |
| `<jump>`              | (none)        | (none)              | Jump to an index number                        |
| `<last-entry>`        | <End>         | G                   | Move to the last entry                         |
| `<last-entry>`        | \*            | G                   | Move to the last entry                         |
| `<middle-page>`       | M             | (none)              | Move to the middle of the page                 |
| `<next-entry>`        | <Down>        | j, J                | Move to the next entry                         |
| `<next-entry>`        | j             | j, J                | Move to the next entry                         |
| `<next-line>`         | \>            | \CE, \CE, j, <Down> | Scroll down one line                           |
| `<next-page>`         | <Pagedown>    | \CF                 | Move to the next page                          |
| `<next-page>`         | <Right>       | \CF                 | Move to the next page                          |
| `<next-page>`         | z             | \CF                 | Move to the next page                          |
| `<previous-entry>`    | <Up>          | k, K                | Move to the previous entry                     |
| `<previous-entry>`    | k             | k, K                | Move to the previous entry                     |
| `<previous-line>`     | <             | \CY, \CY, k, <Up>   | Scroll up one line                             |
| `<previous-page>`     | <Left>        | \CB                 | Move to the previous page                      |
| `<previous-page>`     | <Pageup>      | \CB                 | Move to the previous page                      |
| `<previous-page>`     | Z             | \CB                 | Move to the previous page                      |
| `<redraw-screen>`     | ^L            | (none)              | Clear and redraw the screen                    |
| `<search>`            | /             | (none)              | Search for a regular expression                |
| `<search-next>`       | n             | (none)              | Search for next match                          |
| `<search-opposite>`   | (none)        | N                   | Search for next match in opposite direction    |
| `<search-reverse>`    | Esc /         | (none)              | Search backwards for a regular expression      |
| `<select-entry>`      | <Enter>       | \r                  | Select the current entry                       |
| `<select-entry>`      | <Keypadenter> | \r                  | Select the current entry                       |
| `<select-entry>`      | <Return>      | \r                  | Select the current entry                       |
| `<shell-escape>`      | !             | (none)              | Invoke a command in a subshell                 |
| `<show-log-messages>` | (none)        | (none)              | Show log (and debug) messages                  |
| `<show-version>`      | V             | (none)              | Show the NeoMutt version number and date       |
| `<tag-entry>`         | t             | (none)              | Tag the current entry                          |
| `<tag-prefix>`        | ;             | (none)              | Apply next function to tagged messages         |
| `<tag-prefix-cond>`   | (none)        | (none)              | Apply next function ONLY to tagged messages    |
| `<top-page>`          | H             | (none)              | Move to the top of the page                    |
| `<what-key>`          | (none)        | (none)              | Display the keycode for a key press            |

## 4.2. Index Menu

| Function                        | Default key   | Defined key | Description                                                             |
| ------------------------------- | ------------- | ----------- | ----------------------------------------------------------------------- |
| `<alias-dialog>`                | (none)        | (none)      | Open the aliases dialog                                                 |
| `<autocrypt-acct-menu>`         | A             | (none)      | Manage autocrypt accounts                                               |
| `<bounce-message>`              | b             | (none)      | Remail a message to another user                                        |
| `<break-thread>`                | #             | (none)      | Break the thread in two                                                 |
| `<catchup>`                     | (none)        | (none)      | Mark all articles in newsgroup as read                                  |
| `<change-folder>`               | c             | (none)      | Open a different folder                                                 |
| `<change-folder-readonly>`      | Esc c         | (none)      | Open a different folder in read only mode                               |
| `<change-newsgroup>`            | i             | (none)      | Open a different newsgroup                                              |
| `<change-newsgroup-readonly>`   | Esc i         | (none)      | Open a different newsgroup in read only mode                            |
| `<change-vfolder>`              | (none)        | (none)      | Open a different virtual folder                                         |
| `<check-traditional-pgp>`       | Esc P         | (none)      | Check for classic PGP                                                   |
| `<clear-flag>`                  | W             | (none)      | Clear a status flag from a message                                      |
| `<close-all-threads>`           | (none)        | (none)      | Collapse all threads                                                    |
| `<close-thread>`                | (none)        | (none)      | Collapse current thread                                                 |
| `<collapse-all>`                | Esc V         | zA          | Collapse/uncollapse all threads                                         |
| `<collapse-thread>`             | Esc v         | za          | Collapse/uncollapse current thread                                      |
| `<compose-to-sender>`           | (none)        | (none)      | Compose new message to the current message sender                       |
| `<copy-message>`                | C             | (none)      | Copy a message to a file/mailbox                                        |
| `<create-alias>`                | a             | (none)      | Create an alias from a message sender                                   |
| `<decode-copy>`                 | Esc C         | (none)      | Make decoded (text/plain) copy                                          |
| `<decode-save>`                 | Esc s         | (none)      | Make decoded copy (text/plain) and delete                               |
| `<decrypt-copy>`                | (none)        | (none)      | Make decrypted copy                                                     |
| `<decrypt-save>`                | (none)        | (none)      | Make decrypted copy and delete                                          |
| `<delete-message>`              | d             | dd          | Delete the current entry                                                |
| `<delete-pattern>`              | D             | (none)      | Delete non-hidden messages matching a pattern                           |
| `<delete-subthread>`            | Esc d         | dt          | Delete all messages in subthread                                        |
| `<delete-thread>`               | ^D            | dT          | Delete all messages in thread                                           |
| `<display-address>`             | @             | (none)      | Display full address of sender                                          |
| `<display-message>`             | <Enter>       | l           | Display a message                                                       |
| `<display-message>`             | <Keypadenter> | l           | Display a message                                                       |
| `<display-message>`             | <Return>      | l           | Display a message                                                       |
| `<display-message>`             | <Space>       | l           | Display a message                                                       |
| `<display-toggle-weed>`         | h             | (none)      | Display message and toggle header weeding                               |
| `<edit>`                        | (none)        | (none)      | Edit the raw message (edit and edit-raw-message are synonyms)           |
| `<edit-label>`                  | Y             | (none)      | Add, change, or delete a message's label                                |
| `<edit-or-view-raw-message>`    | e             | (none)      | Edit the raw message if the mailbox is not read-only, otherwise view it |
| `<edit-raw-message>`            | (none)        | (none)      | Edit the raw message (edit and edit-raw-message are synonyms)           |
| `<edit-type>`                   | ^E            | (none)      | Edit attachment content type                                            |
| `<entire-thread>`               | (none)        | (none)      | Read entire thread of the current message                               |
| `<exit>`                        | x             | q           | Exit this menu                                                          |
| `<extract-keys>`                | ^K            | (none)      | Extract supported public keys                                           |
| `<fetch-mail>`                  | G             | (none)      | Retrieve mail from POP server                                           |
| `<flag-message>`                | F             | f           | Toggle a message's 'important' flag                                     |
| `<followup-message>`            | (none)        | (none)      | Followup to newsgroup                                                   |
| `<forget-passphrase>`           | ^F            | (none)      | Wipe passphrases from memory                                            |
| `<forward-message>`             | f             | F           | Forward a message with comments                                         |
| `<forward-to-group>`            | (none)        | (none)      | Forward to newsgroup                                                    |
| `<get-children>`                | (none)        | (none)      | Get all children of the current message                                 |
| `<get-message>`                 | (none)        | (none)      | Get message with Message-Id                                             |
| `<get-parent>`                  | (none)        | (none)      | Get parent of the current message                                       |
| `<group-chat-reply>`            | (none)        | (none)      | Reply to all recipients preserving To/Cc                                |
| `<group-reply>`                 | g             | gr          | Reply to all recipients                                                 |
| `<imap-fetch-mail>`             | (none)        | (none)      | Force retrieval of mail from IMAP server                                |
| `<imap-logout-all>`             | (none)        | (none)      | Logout from all IMAP servers                                            |
| `<limit>`                       | l             | L           | Show only messages matching a pattern                                   |
| `<limit-current-thread>`        | (none)        | (none)      | Limit view to current thread                                            |
| `<link-threads>`                | &             | (none)      | Link tagged message to the current one                                  |
| `<list-reply>`                  | L             | rl          | Reply to specified mailing list                                         |
| `<list-subscribe>`              | (none)        | (none)      | Subscribe to a mailing list                                             |
| `<list-unsubscribe>`            | (none)        | (none)      | Unsubscribe from a mailing list                                         |
| `<mail>`                        | m             | (none)      | Compose a new mail message                                              |
| `<mail-key>`                    | Esc k         | (none)      | Mail a PGP public key                                                   |
| `<mailbox-list>`                | .             | (none)      | List mailboxes with new mail                                            |
| `<mark-message>`                | ~             | (none)      | Create a hotkey macro for the current message                           |
| `<modify-labels>`               | (none)        | (none)      | Modify (notmuch/imap) tags                                              |
| `<modify-labels-then-hide>`     | (none)        | (none)      | Modify (notmuch/imap) tags and then hide message                        |
| `<modify-tags>`                 | (none)        | (none)      | Modify (notmuch/imap) tags                                              |
| `<modify-tags-then-hide>`       | (none)        | (none)      | Modify (notmuch/imap) tags and then hide message                        |
| `<next-entry>`                  | J             | j           | Move to the next entry                                                  |
| `<next-new>`                    | (none)        | (none)      | Jump to the next new message                                            |
| `<next-new-then-unread>`        | <Tab>         | (none)      | Jump to the next new or unread message                                  |
| `<next-subthread>`              | Esc n         | (none)      | Jump to the next subthread                                              |
| `<next-thread>`                 | ^N            | gt          | Jump to the next thread                                                 |
| `<next-undeleted>`              | <Down>        | (none)      | Move to the next undeleted message                                      |
| `<next-undeleted>`              | j             | (none)      | Move to the next undeleted message                                      |
| `<next-unread>`                 | (none)        | (none)      | Jump to the next unread message                                         |
| `<next-unread-mailbox>`         | (none)        | (none)      | Open next mailbox with new mail                                         |
| `<open-all-threads>`            | (none)        | (none)      | Uncollapse all threads                                                  |
| `<open-thread>`                 | (none)        | (none)      | Uncollapse current thread                                               |
| `<parent-message>`              | P             | (none)      | Jump to parent message in thread                                        |
| `<pipe-entry>`                  | \|            | (none)      | Pipe message/attachment to a shell command                              |
| `<pipe-message>`                | \|            | (none)      | Pipe message/attachment to a shell command                              |
| `<post-message>`                | (none)        | (none)      | Post message to newsgroup                                               |
| `<previous-entry>`              | K             | k           | Move to the previous entry                                              |
| `<previous-new>`                | (none)        | (none)      | Jump to the previous new message                                        |
| `<previous-new-then-unread>`    | Esc <Tab>     | (none)      | Jump to the previous new or unread message                              |
| `<previous-subthread>`          | Esc p         | (none)      | Jump to previous subthread                                              |
| `<previous-thread>`             | ^P            | gT          | Jump to previous thread                                                 |
| `<previous-undeleted>`          | <Up>          | (none)      | Move to the previous undeleted message                                  |
| `<previous-undeleted>`          | k             | (none)      | Move to the previous undeleted message                                  |
| `<previous-unread>`             | (none)        | (none)      | Jump to the previous unread message                                     |
| `<print-message>`               | p             | (none)      | Print the current entry                                                 |
| `<purge-message>`               | (none)        | D           | Delete the current entry, bypassing the trash folder                    |
| `<purge-thread>`                | (none)        | (none)      | Delete the current thread, bypassing the trash folder                   |
| `<quasi-delete>`                | (none)        | (none)      | Delete from NeoMutt, don't touch on disk                                |
| `<query>`                       | Q             | (none)      | Query external program for addresses                                    |
| `<quit>`                        | q             | (none)      | Save changes to mailbox and quit                                        |
| `<read-subthread>`              | Esc r         | (none)      | Mark the current subthread as read                                      |
| `<read-thread>`                 | ^R            | (none)      | Mark the current thread as read                                         |
| `<recall-message>`              | R             | (none)      | Recall a postponed message                                              |
| `<reconstruct-thread>`          | (none)        | (none)      | Reconstruct thread containing current message                           |
| `<reply>`                       | r             | ro          | Reply to a message                                                      |
| `<resend-message>`              | Esc e         | (none)      | Use the current message as a template for a new one                     |
| `<root-message>`                | (none)        | (none)      | Jump to root message in thread                                          |
| `<save-message>`                | s             | (none)      | Save message/attachment to a mailbox/file                               |
| `<set-flag>`                    | w             | (none)      | Set a status flag on a message                                          |
| `<show-limit>`                  | Esc l         | (none)      | Show currently active limit pattern                                     |
| `<show-log-messages>`           | M             | (none)      | Show log (and debug) messages                                           |
| `<sort-mailbox>`                | o             | (none)      | Sort messages                                                           |
| `<sort-reverse>`                | O             | (none)      | Sort messages in reverse order                                          |
| `<sync-mailbox>`                | $             | (none)      | Save changes to mailbox                                                 |
| `<tag-pattern>`                 | T             | (none)      | Tag non-hidden messages matching a pattern                              |
| `<tag-subthread>`               | (none)        | (none)      | Tag the current subthread                                               |
| `<tag-thread>`                  | Esc t         | (none)      | Tag the current thread                                                  |
| `<toggle-new>`                  | N             | (none)      | Toggle a message's 'new' flag                                           |
| `<toggle-read>`                 | (none)        | (none)      | Toggle view of read messages                                            |
| `<toggle-write>`                | %             | (none)      | Toggle whether the mailbox will be rewritten                            |
| `<undelete-message>`            | u             | u           | Undelete the current entry                                              |
| `<undelete-pattern>`            | U             | (none)      | Undelete non-hidden messages matching a pattern                         |
| `<undelete-subthread>`          | Esc u         | (none)      | Undelete all messages in subthread                                      |
| `<undelete-thread>`             | ^U            | (none)      | Undelete all messages in thread                                         |
| `<untag-pattern>`               | ^T            | (none)      | Untag non-hidden messages matching a pattern                            |
| `<vfolder-from-query>`          | (none)        | (none)      | Generate virtual folder from query                                      |
| `<vfolder-from-query-readonly>` | (none)        | (none)      | Generate a read-only virtual folder from query                          |
| `<vfolder-window-backward>`     | (none)        | (none)      | Shifts virtual folder time window backwards                             |
| `<vfolder-window-forward>`      | (none)        | (none)      | Shifts virtual folder time window forwards                              |
| `<vfolder-window-reset>`        | (none)        | (none)      | Resets virtual folder time window to the present                        |
| `<view-attachments>`            | v             | (none)      | Show MIME attachments                                                   |
| `<view-raw-message>`            | (none)        | (none)      | Show the raw message                                                    |

## 4.3. Pager Menu

| Function                        | Default key   | Defined key    | Description                                                             |
| ------------------------------- | ------------- | -------------- | ----------------------------------------------------------------------- |
| `<bottom>`                      | <End>         | G              | Jump to the bottom of the message                                       |
| `<bounce-message>`              | b             | (none)         | Remail a message to another user                                        |
| `<break-thread>`                | #             | (none)         | Break the thread in two                                                 |
| `<change-folder>`               | c             | (none)         | Open a different folder                                                 |
| `<change-folder-readonly>`      | Esc c         | (none)         | Open a different folder in read only mode                               |
| `<change-newsgroup>`            | (none)        | (none)         | Open a different newsgroup                                              |
| `<change-newsgroup-readonly>`   | (none)        | (none)         | Open a different newsgroup in read only mode                            |
| `<change-vfolder>`              | (none)        | (none)         | Open a different virtual folder                                         |
| `<check-stats>`                 | (none)        | (none)         | Calculate message statistics for all mailboxes                          |
| `<check-traditional-pgp>`       | Esc P         | (none)         | Check for classic PGP                                                   |
| `<clear-flag>`                  | W             | (none)         | Clear a status flag from a message                                      |
| `<compose-to-sender>`           | (none)        | (none)         | Compose new message to the current message sender                       |
| `<copy-message>`                | C             | (none)         | Copy a message to a file/mailbox                                        |
| `<create-alias>`                | a             | (none)         | Create an alias from a message sender                                   |
| `<decode-copy>`                 | Esc C         | (none)         | Make decoded (text/plain) copy                                          |
| `<decode-save>`                 | Esc s         | (none)         | Make decoded copy (text/plain) and delete                               |
| `<decrypt-copy>`                | (none)        | (none)         | Make decrypted copy                                                     |
| `<decrypt-save>`                | (none)        | (none)         | Make decrypted copy and delete                                          |
| `<delete-message>`              | d             | dd             | Delete the current entry                                                |
| `<delete-subthread>`            | Esc d         | dt             | Delete all messages in subthread                                        |
| `<delete-thread>`               | ^D            | dT             | Delete all messages in thread                                           |
| `<display-address>`             | @             | (none)         | Display full address of sender                                          |
| `<display-toggle-weed>`         | h             | H              | Display message and toggle header weeding                               |
| `<edit>`                        | (none)        | (none)         | Edit the raw message (edit and edit-raw-message are synonyms)           |
| `<edit-label>`                  | Y             | (none)         | Add, change, or delete a message's label                                |
| `<edit-or-view-raw-message>`    | e             | (none)         | Edit the raw message if the mailbox is not read-only, otherwise view it |
| `<edit-raw-message>`            | (none)        | (none)         | Edit the raw message (edit and edit-raw-message are synonyms)           |
| `<edit-type>`                   | ^E            | (none)         | Edit attachment content type                                            |
| `<enter-command>`               | :             | (none)         | Enter a neomuttrc command                                               |
| `<entire-thread>`               | (none)        | (none)         | Read entire thread of the current message                               |
| `<exit>`                        | q             | q, h           | Exit this menu                                                          |
| `<exit>`                        | x             | q, h           | Exit this menu                                                          |
| `<extract-keys>`                | ^K            | (none)         | Extract supported public keys                                           |
| `<flag-message>`                | F             | f              | Toggle a message's 'important' flag                                     |
| `<followup-message>`            | (none)        | (none)         | Followup to newsgroup                                                   |
| `<forget-passphrase>`           | ^F            | (none)         | Wipe passphrases from memory                                            |
| `<forward-message>`             | f             | F              | Forward a message with comments                                         |
| `<forward-to-group>`            | (none)        | (none)         | Forward to newsgroup                                                    |
| `<group-chat-reply>`            | (none)        | (none)         | Reply to all recipients preserving To/Cc                                |
| `<group-reply>`                 | g             | gr             | Reply to all recipients                                                 |
| `<half-down>`                   | (none)        | \CD            | Scroll down 1/2 page                                                    |
| `<half-up>`                     | (none)        | \CU            | Scroll up 1/2 page                                                      |
| `<help>`                        | ?             | (none)         | This screen                                                             |
| `<imap-fetch-mail>`             | (none)        | (none)         | Force retrieval of mail from IMAP server                                |
| `<imap-logout-all>`             | (none)        | (none)         | Logout from all IMAP servers                                            |
| `<jump>`                        | (none)        | (none)         | Jump to an index number                                                 |
| `<link-threads>`                | &             | (none)         | Link tagged message to the current one                                  |
| `<list-reply>`                  | L             | rl             | Reply to specified mailing list                                         |
| `<list-subscribe>`              | (none)        | (none)         | Subscribe to a mailing list                                             |
| `<list-unsubscribe>`            | (none)        | (none)         | Unsubscribe from a mailing list                                         |
| `<mail>`                        | m             | (none)         | Compose a new mail message                                              |
| `<mail-key>`                    | Esc k         | (none)         | Mail a PGP public key                                                   |
| `<mailbox-list>`                | .             | (none)         | List mailboxes with new mail                                            |
| `<mark-as-new>`                 | N             | (none)         | Toggle a message's 'new' flag                                           |
| `<modify-labels>`               | (none)        | (none)         | Modify (notmuch/imap) tags                                              |
| `<modify-labels-then-hide>`     | (none)        | (none)         | Modify (notmuch/imap) tags and then hide message                        |
| `<modify-tags>`                 | (none)        | (none)         | Modify (notmuch/imap) tags                                              |
| `<modify-tags-then-hide>`       | (none)        | (none)         | Modify (notmuch/imap) tags and then hide message                        |
| `<next-entry>`                  | J             | J              | Move to the next entry                                                  |
| `<next-line>`                   | <Enter>       | \CE, j, <Down> | Scroll down one line                                                    |
| `<next-line>`                   | <Keypadenter> | \CE, j, <Down> | Scroll down one line                                                    |
| `<next-line>`                   | <Return>      | \CE, j, <Down> | Scroll down one line                                                    |
| `<next-new>`                    | (none)        | (none)         | Jump to the next new message                                            |
| `<next-new-then-unread>`        | <Tab>         | (none)         | Jump to the next new or unread message                                  |
| `<next-page>`                   | <Pagedown>    | \CF            | Move to the next page                                                   |
| `<next-page>`                   | <Space>       | \CF            | Move to the next page                                                   |
| `<next-subthread>`              | Esc n         | (none)         | Jump to the next subthread                                              |
| `<next-thread>`                 | ^N            | gt             | Jump to the next thread                                                 |
| `<next-undeleted>`              | <Down>        | (none)         | Move to the next undeleted message                                      |
| `<next-undeleted>`              | <Right>       | (none)         | Move to the next undeleted message                                      |
| `<next-undeleted>`              | j             | (none)         | Move to the next undeleted message                                      |
| `<next-unread>`                 | (none)        | (none)         | Jump to the next unread message                                         |
| `<next-unread-mailbox>`         | (none)        | (none)         | Open next mailbox with new mail                                         |
| `<parent-message>`              | P             | (none)         | Jump to parent message in thread                                        |
| `<pipe-entry>`                  | \|            | (none)         | Pipe message/attachment to a shell command                              |
| `<pipe-message>`                | \|            | (none)         | Pipe message/attachment to a shell command                              |
| `<post-message>`                | (none)        | (none)         | Post message to newsgroup                                               |
| `<previous-entry>`              | K             | K              | Move to the previous entry                                              |
| `<previous-line>`               | <Backspace>   | \CY, k, <Up>   | Scroll up one line                                                      |
| `<previous-new>`                | (none)        | (none)         | Jump to the previous new message                                        |
| `<previous-new-then-unread>`    | (none)        | (none)         | Jump to the previous new or unread message                              |
| `<previous-page>`               | <Pageup>      | \CB            | Move to the previous page                                               |
| `<previous-page>`               | \-            | \CB            | Move to the previous page                                               |
| `<previous-subthread>`          | Esc p         | (none)         | Jump to previous subthread                                              |
| `<previous-thread>`             | ^P            | gT             | Jump to previous thread                                                 |
| `<previous-undeleted>`          | <Left>        | (none)         | Move to the previous undeleted message                                  |
| `<previous-undeleted>`          | <Up>          | (none)         | Move to the previous undeleted message                                  |
| `<previous-undeleted>`          | k             | (none)         | Move to the previous undeleted message                                  |
| `<previous-unread>`             | (none)        | (none)         | Jump to the previous unread message                                     |
| `<print-entry>`                 | (none)        | (none)         | Print the current entry                                                 |
| `<print-message>`               | p             | (none)         | Print the current entry                                                 |
| `<purge-message>`               | (none)        | D              | Delete the current entry, bypassing the trash folder                    |
| `<purge-thread>`                | (none)        | (none)         | Delete the current thread, bypassing the trash folder                   |
| `<quasi-delete>`                | (none)        | (none)         | Delete from NeoMutt, don't touch on disk                                |
| `<quit>`                        | Q             | (none)         | Save changes to mailbox and quit                                        |
| `<read-subthread>`              | Esc r         | (none)         | Mark the current subthread as read                                      |
| `<read-thread>`                 | ^R            | (none)         | Mark the current thread as read                                         |
| `<recall-message>`              | R             | (none)         | Recall a postponed message                                              |
| `<reconstruct-thread>`          | (none)        | (none)         | Reconstruct thread containing current message                           |
| `<redraw-screen>`               | ^L            | (none)         | Clear and redraw the screen                                             |
| `<reply>`                       | r             | ro             | Reply to a message                                                      |
| `<resend-message>`              | Esc e         | (none)         | Use the current message as a template for a new one                     |
| `<root-message>`                | (none)        | (none)         | Jump to root message in thread                                          |
| `<save-entry>`                  | (none)        | (none)         | Save message/attachment to a mailbox/file                               |
| `<save-message>`                | s             | (none)         | Save message/attachment to a mailbox/file                               |
| `<search>`                      | /             | (none)         | Search for a regular expression                                         |
| `<search-next>`                 | n             | (none)         | Search for next match                                                   |
| `<search-opposite>`             | (none)        | N              | Search for next match in opposite direction                             |
| `<search-reverse>`              | Esc /         | (none)         | Search backwards for a regular expression                               |
| `<search-toggle>`               | \\\\          | (none)         | Toggle search pattern coloring                                          |
| `<set-flag>`                    | w             | (none)         | Set a status flag on a message                                          |
| `<shell-escape>`                | !             | (none)         | Invoke a command in a subshell                                          |
| `<show-log-messages>`           | (none)        | (none)         | Show log (and debug) messages                                           |
| `<show-version>`                | V             | (none)         | Show the NeoMutt version number and date                                |
| `<skip-headers>`                | H             | (none)         | Jump to first line after headers                                        |
| `<skip-quoted>`                 | S             | (none)         | Skip beyond quoted text                                                 |
| `<sort-mailbox>`                | o             | (none)         | Sort messages                                                           |
| `<sort-reverse>`                | O             | (none)         | Sort messages in reverse order                                          |
| `<sync-mailbox>`                | $             | (none)         | Save changes to mailbox                                                 |
| `<tag-message>`                 | t             | (none)         | Tag the current entry                                                   |
| `<toggle-quoted>`               | T             | (none)         | Toggle display of quoted text                                           |
| `<toggle-write>`                | %             | (none)         | Toggle whether the mailbox will be rewritten                            |
| `<top>`                         | <Home>        | gg             | Jump to the top of the message                                          |
| `<top>`                         | ^             | gg             | Jump to the top of the message                                          |
| `<undelete-message>`            | u             | (none)         | Undelete the current entry                                              |
| `<undelete-subthread>`          | Esc u         | (none)         | Undelete all messages in subthread                                      |
| `<undelete-thread>`             | ^U            | (none)         | Undelete all messages in thread                                         |
| `<vfolder-from-query>`          | (none)        | (none)         | Generate virtual folder from query                                      |
| `<vfolder-from-query-readonly>` | (none)        | (none)         | Generate a read-only virtual folder from query                          |
| `<view-attachments>`            | v             | l              | Show MIME attachments                                                   |
| `<view-raw-message>`            | (none)        | (none)         | Show the raw message                                                    |
| `<what-key>`                    | (none)        | (none)         | Display the keycode for a key press                                     |

## 4.4. Alias Menu

| Function               | Default key | Defined key | Description                                  |
| ---------------------- | ----------- | ----------- | -------------------------------------------- |
| `<delete-entry>`       | d           | (none)      | Delete the current entry                     |
| `<exit>`               | q           | q, h        | Exit this menu                               |
| `<limit>`              | l           | (none)      | Show only messages matching a pattern        |
| `<mail>`               | m           | (none)      | Compose a new mail message                   |
| `<sort-alias>`         | o           | (none)      | Sort messages                                |
| `<sort-alias-reverse>` | O           | (none)      | Sort messages in reverse order               |
| `<tag-entry>`          | <Space>     | (none)      | Tag the current entry                        |
| `<tag-pattern>`        | T           | (none)      | Tag non-hidden messages matching a pattern   |
| `<undelete-entry>`     | u           | (none)      | Undelete the current entry                   |
| `<untag-pattern>`      | ^T          | (none)      | Untag non-hidden messages matching a pattern |

## 4.5. Query Menu

| Function          | Default key | Defined key | Description                                  |
| ----------------- | ----------- | ----------- | -------------------------------------------- |
| `<create-alias>`  | a           | (none)      | Create an alias from a message sender        |
| `<exit>`          | q           | q           | Exit this menu                               |
| `<limit>`         | l           | (none)      | Show only messages matching a pattern        |
| `<mail>`          | m           | (none)      | Compose a new mail message                   |
| `<query>`         | Q           | (none)      | Query external program for addresses         |
| `<query-append>`  | A           | (none)      | Append new query results to current results  |
| `<sort>`          | o           | (none)      | Sort messages                                |
| `<sort-reverse>`  | O           | (none)      | Sort messages in reverse order               |
| `<tag-entry>`     | <Space>     | (none)      | Tag the current entry                        |
| `<tag-pattern>`   | T           | (none)      | Tag non-hidden messages matching a pattern   |
| `<untag-pattern>` | ^T          | (none)      | Untag non-hidden messages matching a pattern |

## 4.6. Attach Menu

| Function                  | Default key   | Defined key      | Description                                          |
| ------------------------- | ------------- | ---------------- | ---------------------------------------------------- |
| `<bounce-message>`        | b             | (none)           | Remail a message to another user                     |
| `<check-traditional-pgp>` | Esc P         | (none)           | Check for classic PGP                                |
| `<collapse-parts>`        | v             | (none)           | Toggle display of subparts                           |
| `<compose-to-sender>`     | (none)        | (none)           | Compose new message to the current message sender    |
| `<delete-entry>`          | d             | (none)           | Delete the current entry                             |
| `<display-toggle-weed>`   | h             | (none)           | Display message and toggle header weeding            |
| `<edit-type>`             | ^E            | (none)           | Edit attachment content type                         |
| `<exit>`                  | q             | q, h             | Exit this menu                                       |
| `<extract-keys>`          | ^K            | (none)           | Extract supported public keys                        |
| `<followup-message>`      | (none)        | (none)           | Followup to newsgroup                                |
| `<forget-passphrase>`     | ^F            | (none)           | Wipe passphrases from memory                         |
| `<forward-message>`       | f             | F                | Forward a message with comments                      |
| `<forward-to-group>`      | (none)        | (none)           | Forward to newsgroup                                 |
| `<group-chat-reply>`      | (none)        | (none)           | Reply to all recipients preserving To/Cc             |
| `<group-reply>`           | g             | (none)           | Reply to all recipients                              |
| `<list-reply>`            | L             | (none)           | Reply to specified mailing list                      |
| `<list-subscribe>`        | (none)        | (none)           | Subscribe to a mailing list                          |
| `<list-unsubscribe>`      | (none)        | (none)           | Unsubscribe from a mailing list                      |
| `<pipe-entry>`            | \|            | (none)           | Pipe message/attachment to a shell command           |
| `<pipe-message>`          | \|            | (none)           | Pipe message/attachment to a shell command           |
| `<print-entry>`           | p             | (none)           | Print the current entry                              |
| `<reply>`                 | r             | (none)           | Reply to a message                                   |
| `<resend-message>`        | Esc e         | (none)           | Use the current message as a template for a new one  |
| `<save-entry>`            | s             | (none)           | Save message/attachment to a mailbox/file            |
| `<undelete-entry>`        | u             | (none)           | Undelete the current entry                           |
| `<view-attach>`           | <Enter>       | l                | View attachment using mailcap entry if necessary     |
| `<view-attach>`           | <Keypadenter> | l                | View attachment using mailcap entry if necessary     |
| `<view-attach>`           | <Return>      | l                | View attachment using mailcap entry if necessary     |
| `<view-mailcap>`          | m             | <space>, <space> | Force viewing of attachment using mailcap            |
| `<view-pager>`            | (none)        | (none)           | View attachment in pager using copiousoutput mailcap |
| `<view-text>`             | T             | (none)           | View attachment as text                              |

## 4.7. Compose Menu

| Function                | Default key   | Defined key | Description                                          |
| ----------------------- | ------------- | ----------- | ---------------------------------------------------- |
| `<attach-file>`         | a             | (none)      | Attach files to this message                         |
| `<attach-key>`          | Esc k         | (none)      | Attach a PGP public key                              |
| `<attach-message>`      | A             | (none)      | Attach messages to this message                      |
| `<attach-news-message>` | (none)        | (none)      | Attach news articles to this message                 |
| `<autocrypt-menu>`      | o             | (none)      | Show autocrypt compose menu options                  |
| `<copy-file>`           | C             | (none)      | Save message/attachment to a mailbox/file            |
| `<detach-file>`         | D             | (none)      | Delete the current entry                             |
| `<display-toggle-weed>` | h             | (none)      | Display message and toggle header weeding            |
| `<edit-bcc>`            | b             | (none)      | Edit the BCC list                                    |
| `<edit-cc>`             | c             | (none)      | Edit the CC list                                     |
| `<edit-content-id>`     | Esc i         | (none)      | Edit the 'Content-ID' of the attachment              |
| `<edit-description>`    | d             | (none)      | Edit attachment description                          |
| `<edit-encoding>`       | ^E            | (none)      | Edit attachment transfer-encoding                    |
| `<edit-fcc>`            | f             | (none)      | Enter a file to save a copy of this message in       |
| `<edit-file>`           | Esc e         | (none)      | Edit the file to be attached                         |
| `<edit-followup-to>`    | (none)        | (none)      | Edit the Followup-To field                           |
| `<edit-from>`           | Esc f         | (none)      | Edit the from field                                  |
| `<edit-headers>`        | E             | (none)      | Edit the message with headers                        |
| `<edit-language>`       | ^L            | (none)      | Edit the 'Content-Language' of the attachment        |
| `<edit-message>`        | e             | (none)      | Edit the message                                     |
| `<edit-mime>`           | m             | (none)      | Edit attachment using mailcap entry                  |
| `<edit-newsgroups>`     | (none)        | (none)      | Edit the newsgroups list                             |
| `<edit-reply-to>`       | r             | (none)      | Edit the Reply-To field                              |
| `<edit-subject>`        | s             | (none)      | Edit the subject of this message                     |
| `<edit-to>`             | t             | (none)      | Edit the TO list                                     |
| `<edit-type>`           | ^T            | (none)      | Edit attachment content type                         |
| `<edit-x-comment-to>`   | (none)        | (none)      | Edit the X-Comment-To field                          |
| `<exit>`                | q             | q           | Exit this menu                                       |
| `<filter-entry>`        | F             | (none)      | Filter attachment through a shell command            |
| `<forget-passphrase>`   | ^F            | (none)      | Wipe passphrases from memory                         |
| `<get-attachment>`      | G             | (none)      | Get a temporary copy of an attachment                |
| `<group-alternatives>`  | &             | (none)      | Group tagged attachments as 'multipart/alternative'  |
| `<group-multilingual>`  | ^             | (none)      | Group tagged attachments as 'multipart/multilingual' |
| `<group-related>`       | %             | (none)      | Group tagged attachments as 'multipart/related'      |
| `<ispell>`              | i             | (none)      | Run ispell on the message                            |
| `<move-down>`           | +             | (none)      | Move an attachment down in the attachment list       |
| `<move-up>`             | \-            | (none)      | Move an attachment up in the attachment list         |
| `<new-mime>`            | n             | (none)      | Compose new attachment using mailcap entry           |
| `<pgp-menu>`            | p             | (none)      | Show PGP options                                     |
| `<pipe-entry>`          | \|            | (none)      | Pipe message/attachment to a shell command           |
| `<pipe-message>`        | \|            | (none)      | Pipe message/attachment to a shell command           |
| `<postpone-message>`    | P             | (none)      | Save this message to send later                      |
| `<preview-page-down>`   | <Pagedown>    | (none)      | Show the next page of the message                    |
| `<preview-page-up>`     | <Pageup>      | (none)      | Show the previous page of the message                |
| `<print-entry>`         | l             | (none)      | Print the current entry                              |
| `<rename-attachment>`   | ^O            | (none)      | Send attachment with a different name                |
| `<rename-file>`         | R             | (none)      | Rename/move an attached file                         |
| `<send-message>`        | y             | (none)      | Send the message                                     |
| `<smime-menu>`          | S             | (none)      | Show S/MIME options                                  |
| `<tag-entry>`           | T             | (none)      | Tag the current entry                                |
| `<toggle-disposition>`  | ^D            | (none)      | Toggle disposition between inline/attachment         |
| `<toggle-recode>`       | (none)        | (none)      | Toggle recoding of this attachment                   |
| `<toggle-unlink>`       | u             | (none)      | Toggle whether to delete file after sending it       |
| `<ungroup-attachment>`  | #             | (none)      | Ungroup 'multipart' attachment                       |
| `<update-encoding>`     | U             | (none)      | Update an attachment's encoding info                 |
| `<view-attach>`         | <Enter>       | (none)      | View attachment using mailcap entry if necessary     |
| `<view-attach>`         | <Keypadenter> | (none)      | View attachment using mailcap entry if necessary     |
| `<view-attach>`         | <Return>      | (none)      | View attachment using mailcap entry if necessary     |
| `<view-mailcap>`        | (none)        | (none)      | Force viewing of attachment using mailcap            |
| `<view-pager>`          | (none)        | (none)      | View attachment in pager using copiousoutput mailcap |
| `<view-text>`           | (none)        | (none)      | View attachment as text                              |
| `<write-fcc>`           | w             | (none)      | Write the message to a folder                        |

## 4.8. Postpone Menu

| Function           | Default key | Defined key | Description                |
| ------------------ | ----------- | ----------- | -------------------------- |
| `<delete-entry>`   | d           | (none)      | Delete the current entry   |
| `<exit>`           | q           | (none)      | Exit this menu             |
| `<undelete-entry>` | u           | (none)      | Undelete the current entry |

## 4.9. Browser Menu

| Function                | Default key | Defined key | Description                                                |
| ----------------------- | ----------- | ----------- | ---------------------------------------------------------- |
| `<catchup>`             | (none)      | (none)      | Mark all articles in newsgroup as read                     |
| `<change-dir>`          | c           | (none)      | Change directories                                         |
| `<check-new>`           | (none)      | (none)      | Check mailboxes for new mail                               |
| `<create-mailbox>`      | C           | (none)      | Create a new mailbox (IMAP only)                           |
| `<delete-mailbox>`      | d           | (none)      | Delete the current mailbox (IMAP only)                     |
| `<descend-directory>`   | (none)      | l           | Descend into a directory                                   |
| `<display-filename>`    | @           | (none)      | Display the currently selected file's name                 |
| `<enter-mask>`          | m           | (none)      | Enter a file mask                                          |
| `<exit>`                | q           | q, h        | Exit this menu                                             |
| `<goto-folder>`         | \=          | (none)      | Swap the current folder position with $folder if it exists |
| `<goto-parent>`         | p           | h           | Go to parent directory                                     |
| `<mailbox-list>`        | .           | (none)      | List mailboxes with new mail                               |
| `<reload-active>`       | (none)      | (none)      | Load list of all newsgroups from NNTP server               |
| `<rename-mailbox>`      | r           | (none)      | Rename the current mailbox (IMAP only)                     |
| `<select-new>`          | N           | (none)      | Select a new file in this directory                        |
| `<sort>`                | o           | (none)      | Sort messages                                              |
| `<sort-reverse>`        | O           | (none)      | Sort messages in reverse order                             |
| `<subscribe>`           | s           | (none)      | Subscribe to current mbox (IMAP/NNTP only)                 |
| `<subscribe-pattern>`   | (none)      | (none)      | Subscribe to newsgroups matching a pattern                 |
| `<toggle-mailboxes>`    | <Tab>       | (none)      | Toggle whether to browse mailboxes or all files            |
| `<toggle-subscribed>`   | T           | (none)      | Toggle view all/subscribed mailboxes (IMAP only)           |
| `<uncatchup>`           | (none)      | (none)      | Mark all articles in newsgroup as unread                   |
| `<unsubscribe>`         | u           | (none)      | Unsubscribe from current mbox (IMAP/NNTP only)             |
| `<unsubscribe-pattern>` | (none)      | (none)      | Unsubscribe from newsgroups matching a pattern             |
| `<view-file>`           | <Space>     | (none)      | View file                                                  |

## 4.10. Pgp Menu

| Function       | Default key | Defined key | Description            |
| -------------- | ----------- | ----------- | ---------------------- |
| `<exit>`       | q           | (none)      | Exit this menu         |
| `<verify-key>` | c           | (none)      | Verify a public key    |
| `<view-name>`  | %           | (none)      | View the key's user id |

## 4.11. Smime Menu

| Function       | Default key | Defined key | Description            |
| -------------- | ----------- | ----------- | ---------------------- |
| `<exit>`       | q           | (none)      | Exit this menu         |
| `<verify-key>` | c           | (none)      | Verify a public key    |
| `<view-name>`  | %           | (none)      | View the key's user id |

## 4.12. Editor Menu

| Function            | Default key | Defined key | Description                                         |
| ------------------- | ----------- | ----------- | --------------------------------------------------- |
| `<backspace>`       | <Backspace> | (none)      | Delete the char in front of the cursor              |
| `<backspace>`       | <Delete>    | (none)      | Delete the char in front of the cursor              |
| `<backward-char>`   | <Left>      | (none)      | Move the cursor one character to the left           |
| `<backward-char>`   | ^B          | (none)      | Move the cursor one character to the left           |
| `<backward-word>`   | Esc b       | (none)      | Move the cursor to the beginning of the word        |
| `<bol>`             | <Home>      | (none)      | Jump to the beginning of the line                   |
| `<bol>`             | ^A          | (none)      | Jump to the beginning of the line                   |
| `<capitalize-word>` | Esc c       | (none)      | Capitalize the word                                 |
| `<complete>`        | <Tab>       | ^T          | Complete filename or alias                          |
| `<complete-query>`  | ^T          | <tab>       | Complete address with query                         |
| `<delete-char>`     | <Delete>    | (none)      | Delete the char under the cursor                    |
| `<delete-char>`     | ^D          | (none)      | Delete the char under the cursor                    |
| `<downcase-word>`   | Esc l       | (none)      | Convert the word to lower case                      |
| `<eol>`             | <End>       | (none)      | Jump to the end of the line                         |
| `<eol>`             | ^E          | (none)      | Jump to the end of the line                         |
| `<forward-char>`    | <Right>     | (none)      | Move the cursor one character to the right          |
| `<forward-char>`    | ^F          | (none)      | Move the cursor one character to the right          |
| `<forward-word>`    | Esc f       | (none)      | Move the cursor to the end of the word              |
| `<help>`            | Esc ?       | (none)      | This screen                                         |
| `<history-down>`    | <Down>      | (none)      | Scroll down through the history list                |
| `<history-down>`    | ^N          | (none)      | Scroll down through the history list                |
| `<history-search>`  | ^R          | (none)      | Search through the history list                     |
| `<history-up>`      | <Up>        | (none)      | Scroll up through the history list                  |
| `<history-up>`      | ^P          | (none)      | Scroll up through the history list                  |
| `<kill-eol>`        | ^K          | (none)      | Delete chars from cursor to end of line             |
| `<kill-eow>`        | Esc d       | (none)      | Delete chars from the cursor to the end of the word |
| `<kill-line>`       | ^U          | (none)      | Delete chars from cursor to beginning the line      |
| `<kill-whole-line>` | (none)      | (none)      | Delete all chars on the line                        |
| `<kill-word>`       | ^W          | (none)      | Delete the word in front of the cursor              |
| `<mailbox-cycle>`   | <Space>     | (none)      | Cycle among incoming mailboxes                      |
| `<quote-char>`      | ^V          | (none)      | Quote the next typed key                            |
| `<redraw-screen>`   | ^L          | (none)      | Clear and redraw the screen                         |
| `<transpose-chars>` | (none)      | (none)      | Transpose character under cursor with previous      |
| `<upcase-word>`     | Esc u       | (none)      | Convert the word to upper case                      |

## 4.13. Sidebar Menu

| Function                   | Default key | Defined key | Description                                          |
| -------------------------- | ----------- | ----------- | ---------------------------------------------------- |
| `<sidebar-abort-search>`   | (none)      | (none)      | Close the sidebar search                             |
| `<sidebar-first>`          | (none)      | (none)      | Move the highlight to the first mailbox              |
| `<sidebar-last>`           | (none)      | (none)      | Move the highlight to the last mailbox               |
| `<sidebar-next>`           | (none)      | \Cj         | Move the highlight to next mailbox                   |
| `<sidebar-next-new>`       | (none)      | (none)      | Move the highlight to next mailbox with new mail     |
| `<sidebar-open>`           | (none)      | <Return>    | Open highlighted mailbox                             |
| `<sidebar-page-down>`      | (none)      | (none)      | Scroll the sidebar down 1 page                       |
| `<sidebar-page-up>`        | (none)      | (none)      | Scroll the sidebar up 1 page                         |
| `<sidebar-prev>`           | (none)      | \Ck         | Move the highlight to previous mailbox               |
| `<sidebar-prev-new>`       | (none)      | (none)      | Move the highlight to previous mailbox with new mail |
| `<sidebar-start-search>`   | (none)      | (none)      | Fuzzy search the sidebar                             |
| `<sidebar-toggle-virtual>` | (none)      | (none)      | Toggle between mailboxes and virtual mailboxes       |
| `<sidebar-toggle-visible>` | (none)      | B           | Make the sidebar (in)visible                         |

## 4.14. Autocrypt Account Menu

| Function                  | Default key | Defined key | Description                                    |
| ------------------------- | ----------- | ----------- | ---------------------------------------------- |
| `<create-account>`        | c           | (none)      | Create a new autocrypt account                 |
| `<delete-account>`        | D           | (none)      | Delete the current account                     |
| `<exit>`                  | q           | (none)      | Exit this menu                                 |
| `<toggle-active>`         | a           | (none)      | Toggle the current account active/inactive     |
| `<toggle-prefer-encrypt>` | p           | (none)      | Toggle the current account prefer-encrypt flag |

## Custom Macros (from `mappings`)

| Context + Key  | Sequence / Description                                                       |
| -------------- | ---------------------------------------------------------------------------- |
| `compose: \Ca` | :source ~/.config/neomutt/bin/attach_browser_yazi.sh\|<enter>                |
| `index: A`     | <pipe-message>khard add-email --headers=from,cc --skip-already-added<return> |
| `index: S`     | Notmuch Global Search                                                        |
| `index: x`     | show all messages (undo limit)                                               |
| `pager: A`     | <pipe-message>khard add-email --headers=from,cc --skip-already-added<return> |

## Analysis & Vim-Style Workflow Recommendations

### Current Mapping Audit

**Total functions with custom bindings:** 47
**Menu contexts with bindings:** alias, attach, browser, compose, editor, index, pager, query

### Overrides by Menu

**Generic Menu:**

- `<current-bottom>`: `(none)` → `zb` (in `index`)
- `<current-middle>`: `(none)` → `zz` (in `index`)
- `<current-top>`: `(none)` → `zt` (in `index`)
- `<exit>`: `(none)` → `q` (in `index`)
- `<exit>`: `(none)` → `q, h` (in `pager`)
- `<exit>`: `(none)` → `q, h` (in `attach`)
- `<exit>`: `(none)` → `q, h` (in `browser`)
- `<exit>`: `(none)` → `q, h` (in `alias`)
- `<exit>`: `(none)` → `q` (in `query`)
- `<exit>`: `(none)` → `q` (in `compose`)
- `<first-entry>`: `<Home>` → `gg` (in `index`)
- `<first-entry>`: `<Home>` → `gg` (in `attach`)
- `<first-entry>`: `<Home>` → `gg` (in `browser`)
- `<first-entry>`: `\=` → `gg` (in `index`)
- `<first-entry>`: `\=` → `gg` (in `attach`)
- `<first-entry>`: `\=` → `gg` (in `browser`)
- `<half-down>`: `\]` → `\CD` (in `index`)
- `<half-down>`: `\]` → `\CD` (in `pager`)
- `<half-down>`: `\]` → `\CD` (in `browser`)
- `<half-up>`: `\[` → `\CU` (in `index`)
- `<half-up>`: `\[` → `\CU` (in `pager`)
- `<half-up>`: `\[` → `\CU` (in `browser`)
- `<last-entry>`: `<End>` → `G` (in `index`)
- `<last-entry>`: `<End>` → `G` (in `attach`)
- `<last-entry>`: `<End>` → `G` (in `browser`)
- `<last-entry>`: `\*` → `G` (in `index`)
- `<last-entry>`: `\*` → `G` (in `attach`)
- `<last-entry>`: `\*` → `G` (in `browser`)
- `<next-entry>`: `<Down>` → `j` (in `index`)
- `<next-entry>`: `<Down>` → `J` (in `pager`)
- `<next-entry>`: `j` → `j` (in `index`)
- `<next-entry>`: `j` → `J` (in `pager`)
- `<next-line>`: `\>` → `\CE` (in `index`)
- `<next-line>`: `\>` → `\CE, j, <Down>` (in `pager`)
- `<next-line>`: `\>` → `\CE` (in `browser`)
- `<next-page>`: `<Pagedown>` → `\CF` (in `index`)
- `<next-page>`: `<Pagedown>` → `\CF` (in `pager`)
- `<next-page>`: `<Pagedown>` → `\CF` (in `browser`)
- `<next-page>`: `<Right>` → `\CF` (in `index`)
- `<next-page>`: `<Right>` → `\CF` (in `pager`)
- `<next-page>`: `<Right>` → `\CF` (in `browser`)
- `<next-page>`: `z` → `\CF` (in `index`)
- `<next-page>`: `z` → `\CF` (in `pager`)
- `<next-page>`: `z` → `\CF` (in `browser`)
- `<previous-entry>`: `<Up>` → `k` (in `index`)
- `<previous-entry>`: `<Up>` → `K` (in `pager`)
- `<previous-entry>`: `k` → `k` (in `index`)
- `<previous-entry>`: `k` → `K` (in `pager`)
- `<previous-line>`: `<` → `\CY` (in `index`)
- `<previous-line>`: `<` → `\CY, k, <Up>` (in `pager`)
- `<previous-line>`: `<` → `\CY` (in `browser`)
- `<previous-page>`: `<Left>` → `\CB` (in `index`)
- `<previous-page>`: `<Left>` → `\CB` (in `pager`)
- `<previous-page>`: `<Left>` → `\CB` (in `browser`)
- `<previous-page>`: `<Pageup>` → `\CB` (in `index`)
- `<previous-page>`: `<Pageup>` → `\CB` (in `pager`)
- `<previous-page>`: `<Pageup>` → `\CB` (in `browser`)
- `<previous-page>`: `Z` → `\CB` (in `index`)
- `<previous-page>`: `Z` → `\CB` (in `pager`)
- `<previous-page>`: `Z` → `\CB` (in `browser`)
- `<search-opposite>`: `(none)` → `N` (in `index`)
- `<search-opposite>`: `(none)` → `N` (in `pager`)
- `<search-opposite>`: `(none)` → `N` (in `browser`)
- `<select-entry>`: `<Enter>` → `\r` (in `browser`)
- `<select-entry>`: `<Enter>` → `\r` (in `alias`)
- `<select-entry>`: `<Keypadenter>` → `\r` (in `browser`)
- `<select-entry>`: `<Keypadenter>` → `\r` (in `alias`)
- `<select-entry>`: `<Return>` → `\r` (in `browser`)
- `<select-entry>`: `<Return>` → `\r` (in `alias`)

**Index Menu:**

- `<collapse-all>`: `Esc V` → `zA` (in `index`)
- `<collapse-thread>`: `Esc v` → `za` (in `index`)
- `<delete-message>`: `d` → `dd` (in `index`)
- `<delete-subthread>`: `Esc d` → `dt` (in `index`)
- `<delete-thread>`: `^D` → `dT` (in `index`)
- `<display-message>`: `<Enter>` → `l` (in `index`)
- `<display-message>`: `<Keypadenter>` → `l` (in `index`)
- `<display-message>`: `<Return>` → `l` (in `index`)
- `<display-message>`: `<Space>` → `l` (in `index`)
- `<exit>`: `x` → `q` (in `index`)
- `<flag-message>`: `F` → `f` (in `index`)
- `<forward-message>`: `f` → `F` (in `index`)
- `<group-reply>`: `g` → `gr` (in `index`)
- `<limit>`: `l` → `L` (in `index`)
- `<list-reply>`: `L` → `rl` (in `index`)
- `<next-entry>`: `J` → `j` (in `index`)
- `<next-thread>`: `^N` → `gt` (in `index`)
- `<previous-entry>`: `K` → `k` (in `index`)
- `<previous-thread>`: `^P` → `gT` (in `index`)
- `<purge-message>`: `(none)` → `D` (in `index`)
- `<reply>`: `r` → `ro` (in `index`)
- `<undelete-message>`: `u` → `u` (in `index`)

**Pager Menu:**

- `<bottom>`: `<End>` → `G` (in `pager`)
- `<delete-message>`: `d` → `dd` (in `pager`)
- `<delete-subthread>`: `Esc d` → `dt` (in `pager`)
- `<delete-thread>`: `^D` → `dT` (in `pager`)
- `<display-toggle-weed>`: `h` → `H` (in `pager`)
- `<exit>`: `q` → `q, h` (in `pager`)
- `<exit>`: `x` → `q, h` (in `pager`)
- `<flag-message>`: `F` → `f` (in `pager`)
- `<forward-message>`: `f` → `F` (in `pager`)
- `<group-reply>`: `g` → `gr` (in `pager`)
- `<half-down>`: `(none)` → `\CD` (in `pager`)
- `<half-up>`: `(none)` → `\CU` (in `pager`)
- `<list-reply>`: `L` → `rl` (in `pager`)
- `<next-entry>`: `J` → `J` (in `pager`)
- `<next-line>`: `<Enter>` → `\CE, j, <Down>` (in `pager`)
- `<next-line>`: `<Keypadenter>` → `\CE, j, <Down>` (in `pager`)
- `<next-line>`: `<Return>` → `\CE, j, <Down>` (in `pager`)
- `<next-page>`: `<Pagedown>` → `\CF` (in `pager`)
- `<next-page>`: `<Space>` → `\CF` (in `pager`)
- `<next-thread>`: `^N` → `gt` (in `pager`)
- `<previous-entry>`: `K` → `K` (in `pager`)
- `<previous-line>`: `<Backspace>` → `\CY, k, <Up>` (in `pager`)
- `<previous-page>`: `<Pageup>` → `\CB` (in `pager`)
- `<previous-page>`: `\-` → `\CB` (in `pager`)
- `<previous-thread>`: `^P` → `gT` (in `pager`)
- `<purge-message>`: `(none)` → `D` (in `pager`)
- `<reply>`: `r` → `ro` (in `pager`)
- `<search-opposite>`: `(none)` → `N` (in `pager`)
- `<top>`: `<Home>` → `gg` (in `pager`)
- `<top>`: `^` → `gg` (in `pager`)
- `<view-attachments>`: `v` → `l` (in `pager`)

**Alias Menu:**

- `<exit>`: `q` → `q, h` (in `alias`)

**Query Menu:**

- `<exit>`: `q` → `q` (in `query`)

**Attach Menu:**

- `<exit>`: `q` → `q, h` (in `attach`)
- `<forward-message>`: `f` → `F` (in `attach`)
- `<view-attach>`: `<Enter>` → `l` (in `attach`)
- `<view-attach>`: `<Keypadenter>` → `l` (in `attach`)
- `<view-attach>`: `<Return>` → `l` (in `attach`)
- `<view-mailcap>`: `m` → `<space>, <space>` (in `attach`)

**Compose Menu:**

- `<exit>`: `q` → `q` (in `compose`)

**Browser Menu:**

- `<descend-directory>`: `(none)` → `l` (in `browser`)
- `<exit>`: `q` → `q, h` (in `browser`)
- `<goto-parent>`: `p` → `h` (in `browser`)

**Editor Menu:**

- `<complete>`: `<Tab>` → `^T` (in `editor`)
- `<complete-query>`: `^T` → `<tab>` (in `editor`)

**Sidebar Menu:**

- `<sidebar-next>`: `(none)` → `\Cj` (in `index`)
- `<sidebar-next>`: `(none)` → `\Cj` (in `pager`)
- `<sidebar-open>`: `(none)` → `<Return>` (in `index`)
- `<sidebar-open>`: `(none)` → `<Return>` (in `pager`)
- `<sidebar-prev>`: `(none)` → `\Ck` (in `index`)
- `<sidebar-prev>`: `(none)` → `\Ck` (in `pager`)
- `<sidebar-toggle-visible>`: `(none)` → `B` (in `index`)
- `<sidebar-toggle-visible>`: `(none)` → `B` (in `pager`)

### Key Bindings Still Using Defaults (Potential Vim Candidates)

The following commonly-used functions still rely on NeoMutt defaults and could benefit from Vim-style remapping:

#### index menu

- `<next-entry>` — default: `j` — Move down (✓ already mapped)
- `<previous-entry>` — default: `k` — Move up (✓ already mapped)
- `<display-message>` — default: `l` — Open message (✓ already mapped)
- `<exit>` — default: `q` — Exit/quit (✓ already mapped)
- `<first-entry>` — default: `gg` — Go to top (✓ already mapped via gg)
- `<last-entry>` — default: `G` — Go to bottom (✓ already mapped)
- `<next-page>` — default: `<Space>/<C-F>` — Page down (✓ mapped to C-F)
- `<previous-page>` — default: `<C-B>/<b>` — Page up (✓ mapped to C-B)
- `<flag-message>` — default: `F` — Flag (mapped to f)
- `<delete-message>` — default: `d` — Delete (mapped via dd/D)
- `<undelete-message>` — default: `u` — Undelete (✓ mapped)
- `<reply>` — default: `r` — Reply (remapped via ro/gr/rl)
- `<change-folder>` — default: `c` — Switch folder
- `<limit>` — default: `l / \` — Filter messages (mapped to L)
- `<tag-entry>` — default: `T` — Tag message
- `<next-thread>` — default: `}` — Next thread (mapped via gt)
- `<previous-thread>` — default: `{` — Previous thread (mapped via gT)
- `<collapse-thread>` — default: `zv` — Collapse thread (mapped via za/zA)

#### pager menu

- `<next-line>` — default: `j` — Scroll down (✓ mapped)
- `<previous-line>` — default: `k` — Scroll up (✓ mapped)
- `<next-page>` — default: `<Space>/<C-F>` — Page down (✓ mapped)
- `<previous-page>` — default: `b/<C-B>` — Page up (✓ mapped)
- `<exit>` — default: `q` — Exit pager (mapped to h)
- `<view-attachments>` — default: `v` — View attachments (✓ mapped to l)
- `<half-down>` — default: `<C-D>` — Half page down (✓ mapped)
- `<half-up>` — default: `<C-U>` — Half page up (✓ mapped)
- `<top>` — default: `H` — Go to top (mapped via gg)
- `<bottom>` — default: `L` — Go to bottom (mapped via G)

### Recommendations for Vim-Style Workflow

Your current mappings are already very well aligned with a Vim-style workflow. Here are additional suggestions:

#### 1. Thread Navigation (`{` / `}`)

Should I consider adding `{` and `}` for thread navigation to match Vim's paragraph navigation?

```
bind index    {   previous-thread
bind index    }   next-thread
```

No need. I sort my mails list by date and time, so the newest mail stays on the top. I don't manage mails by thread at all.

#### 2. Search with `/` and `?` in Index

Should I map `/` and `?` for forward/backward search (standard Vim pattern)?

```
bind index    /   search
bind index    ?   search-reverse
```

No need. Better keep `?` for pulling up the help list. Even in Vim/Neovim, I rarely search backwards.

#### 3. Visual Mode / Tagging with `V`

Use `v` (lowercase) to tag messages (like Vim visual mode), and `V` for tag-pattern:

```
bind index    v   tag-entry
bind index    V   tag-pattern
```

#### 4. Undo with `u`

You already have `u` for undelete — perfect. If you want `.` (dot) for repeat:

```
bind index    .   last-entry    # or a macro that repeats last action
```

I'm not sure what `last-entry` does.

#### 5. Page Navigation with `CTRL-d` / `CTRL-u`

Already mapped (\CD, \CU) — excellent Vim convention.

#### 6. Sidebar Navigation (Buffer-style)

Consider making the sidebar feel more like Vim's buffer list:

```
bind index,pager    BB   sidebar-toggle-visible    # toggle (already B)
bind index,pager    C-k  sidebar-prev              # (already mapped)
bind index,pager    C-j  sidebar-next              # (already mapped)
bind index,pager    <CR> sidebar-open              # (already mapped)
```

#### 7. Compose Menu — Save & Send

No recommendations.

#### 8. Pager — Next/Prev Message from within Pager

Already well covered with `J`/`K`. Consider adding `]`/`[` for consistency with Vim's `]` bracket navigation:

```
bind pager    ]   next-entry
bind pager    [   previous-entry
```

#### 9. Macro: Quick Save & Archive Pattern

```
# Archive current message: mark as read, move to archive, go to next
macro index    a   "<pipe-message>mairix-archive\n<tag-prefix><next-entry>" "Archive message"
```

#### 10. Editor Mode — Insert Mode

For the editor (compose body), consider mapping `<Esc>` and `i`:

```
bind editor    <Esc>   exit
bind editor    i       noop    # reserve for potential insert-mode macro
```

### Summary

| Principle                          | Status                                                 |
| ---------------------------------- | ------------------------------------------------------ |
| `hjkl` navigation                  | ✅ Fully implemented across index/pager/attach/browser |
| `gg`/`G` top/bottom                | ✅ Implemented everywhere                              |
| `C-f`/`C-b`/`C-d`/`C-u` scrolling  | ✅ Implemented everywhere                              |
| `q` to quit                        | ✅ Universal exit key                                  |
| `dd`/`D` delete pattern            | ✅ Matches Vim delete (dd=D, D=dt)                     |
| `gr`/`ro`/`rl` reply variants      | ✅ Excellent: group/list/single reply                  |
| `J`/`K` next/prev message in pager | ✅ Great for browsing threads                          |
| `gg`/`G` in pager                  | ✅ Top/bottom of message                               |
| Sidebar `C-k`/`C-j`                | ✅ Vim-like buffer navigation                          |
| `{`/`}` thread navigation          | ❌ Suggest adding                                      |
| `/`/`?` search                     | ❌ Suggest adding                                      |
| `v`/`V` tag messages               | ❌ Suggest adding                                      |
| `]`/`[` bracket navigation         | ❌ Suggest adding in pager                             |
