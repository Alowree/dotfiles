---
title: Backup dotfiles on GitHub
date: 2024-09-03 11:14:30
permalink: /pages/b6e997/
categories:
  - editor
tags:
  - editor
  - Neovim
---

There might be many tools installed on your computer; each has a config file, stored at different locations. What if you just purchased a new computer, or simply re-installed OS on your existing computer? Do you want to set up your config files from scratch all over again?

## Goal

- Manage and backup various configuration files on your computer through Git
- Share the same set of dotfiles between two different machines
- System:
  - Windows 10, Windows Terminal, Zsh, Neovim
  - MacOS, iTerm2, Zsh, Neovim
- Method:
  - A bare Git repository `dotfiles` in the home directory on my primary machine

## Tracked files

- `.zshrc`
- `.vimrc`
- `README.md`
- `AppData/Local/nvim`

## Backup

1. Create a new folder `$HOME/dotfiles` and run `git init --bare` to initialize it as a bare repository (without a working directory) to track the configuration files you need to manage
2. Transform the basic git command into the gitbare command, i.e. when running gitbare in Windows Terminal instead of basic git, Git automatically treats `$HOME/dotfiles` as the repository and the entire `$HOME` directory as the working directory. To accomplish this substitution, simply run `code $PROFILE` in Windows Terminal, open the configuration file using VS Code, and add the following function:

   ```ps1
   function gitbare {
   git --git-dir=$HOME/dotfiles --work-tree=$HOME $args
   }
   ```

3. After step 2, when we need to work on our dotfiles repository, we can use the retrofit `gitbare add`, `gitbare commit`, and `gitbare remote` instead of the original `git add`, `git commit`, and `git remote`
4. Create a new repository on GitHub, https://github.com/user-name/dotfiles
   ```pwsh
   gitbare remote add origin https://github.com/user-name/dotfiles.git
   gitbare branch -M main
   gitbare push -u origin main
   ```
5. Now you can selectively add, commit, and push your configuration files from your `$HOME` directory to your remote GitHub repository for backup

## 本地仓库从零重建

远程仓库已经存在，也包含之前推送过的仓库文件夹和文件。现在本地仓库删除，完全从零开始重建。当尝试运行 `gitbare push` 触发以下报错：

```
fatal: The current branch main has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin main

To have this happen automatically for branches without a tracking
upstream, see 'push.autoSetupRemote' in 'git help config'.
```

根据提示，运行 `gitbare push --set-upstream origin main` 之后，旋即触发以下报错：

```
error: src refspec main does not match any
error: failed to push some refs to 'https://github.com/alowree/dotfiles.git'
```

没有更好的办法，只好手动删除运程仓库，再重新推送。

## git clone

Now I'm on my macOS home folder.

```
git clone https://github.com/Alowree/dotfiles.git
```

If the internet connection is good (and you are not blocked by the GFW), the above command would clone the `dotfiles` folder from your remote repository to your home directory.

## git push

I've done some editing in the README.md file on the macOS.

```
git add .
git commit -m "Updated the README.md from macOS"
git push origin main
```

Push success!

## Pull

How can I pull the update from remote repository onto my Windows machine?

Will all updates be made automatically to each file and each folder, as originally organized on the home directory, using the same file structure?

Switch to the Windows machine and enter the home directory.

```
gitbare pull
```

We can see both changes made to the `README.md` and to the `AppData/Local/nvim/` are successfully updated to the local Windows machine. Note the Git user from two machines are of the same user. What about two different users?

Affirmative. `git pull` works just fine on the Windows machine.

## Reference

- https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/
- https://www.daytona.io/dotfiles/ultimate-guide-to-dotfiles
- https://www.youtube.com/watch?v=iYElODEf6awo
- https://github.com/pawelbialaszczyk/dotfiles
