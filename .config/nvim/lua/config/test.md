Step 1:

```
╭╴  alowree on Arch Linux at ~/.config/nvim/lua/config took  4m11s
╰─❯ pgrep fcitx5
791

╭╴  alowree on Arch Linux at ~/.config/nvim/lua/config
╰─❯ fcitx5-remote -n
keyboard-us

╭╴  alowree on Arch Linux at ~/.config/nvim/lua/config
╰─❯ fcitx5-remote -s keyboard-us

╭╴  alowree on Arch Linux at ~/.config/nvim/lua/config
╰─❯ fcitx5-remote -n
keyboard-us

╭╴  alowree on Arch Linux at ~/.config/nvim/lua/config
╰─❯ fcitx5-remote -s wbpy

╭╴  alowree on Arch Linux at ~/.config/nvim/lua/config
╰─❯ fcitx5-remote -n
wbpy
```

Step 2:

```
" Test 1: Can Neovim see fcitx5-remote?
:echo executable("fcitx5-remote")
1

" Test 2: Run fcitx5-remote from Neovim
:echo system("fcitx5-remote -n")
keyboard-us

" Test 3: Try switching to English from Neovim
:call system("fcitx5-remote -s keyboard-us")
[cmdline no output]

" Test 4: Verify the switch worked
:echo system("fcitx5-remote -n")
keyboard-us

" Test 5: Try switching to Wubi from Neovim
:call system("fcitx5-remote -s wbpy")
[cmdline no output, but input method indeed gets switched to Chinese Wubi.]

" Test 6: Verify the switch worked
:echo system("fcitx5-remote -n")
wbpy
```

Step 3:

This is a test.
This is another test.

I do see the echo messages when entering/leaving insert mode.

Step 4:

```
" Start with Wubi active (manually switch if needed)
:call system("fcitx5-remote -s wbpy")
[The input method indeed gets switched to Chinese Wubi.]

" Verify you're in Wubi
:echo "Current IME: " . trim(system("fcitx5-remote -n"))
Current IME: wbpy

" Now run the logic manually (as if you're leaving Insert mode)
:let english_id = "keyboard-us"
:let current_ime = trim(system("fcitx5-remote -n"))
:echo "Current: " . current_ime

:if current_ime != english_id
:  let g:last_ime = current_ime
:  echo "Saved: " . g:last_ime
:  call system("fcitx5-remote -s " . english_id)
:  echo "Switched to English"
:else
:  echo "Already in English"
:endif

" Verify switch worked
:echo "Now at: " . trim(system("fcitx5-remote -n"))

" Now simulate entering Insert mode (restore)
:if exists("g:last_ime")
:  call system("fcitx5-remote -s " . g:last_ime)
:  echo "Restored to: " . g:last_ime
:  unlet g:last_ime
:endif

" Verify restore worked
:echo "Restored to: " . trim(system("fcitx5-remote -n"))
```
