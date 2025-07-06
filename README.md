# Dotfiles Management with Bare Git Repo and Symlinks

This guide explains how to manage and share your configuration files (dotfiles) across Windows and macOS using a bare Git repository and symbolic links (symlinks).

<!-- more -->

## 1. Choose a Canonical Config Folder

Use `~/.config/nvim` as the canonical Neovim config folder (tracked in your dotfiles repo).

## 2. Initial Setup on macOS

1. **Move your Neovim config to the canonical location:**

   ```sh
   mkdir -p ~/.config
   mv ~/AppData/Local/nvim ~/.config/nvim  # Only if you have config in the Windows path on macOS
   ```

2. **Initialize the bare repo (if not already done):**

   ```sh
   git init --bare $HOME/dotfiles
   ```

3. **Add the alias to your shell config:**

   ```sh
   echo "alias gitbare='git --git-dir=\$HOME/dotfiles --work-tree=\$HOME'" >> ~/.zshrc
   source ~/.zshrc
   ```

4. **Ignore the bare repo folder:**

   ```sh
   echo "dotfiles" >> ~/.gitignore
   gitbare config --local core.excludesfile ~/.gitignore
   ```

5. **Add and commit your config:**
   ```sh
   gitbare add .config/nvim
   gitbare commit -m "Add Neovim config"
   gitbare remote add origin https://github.com/yourusername/dotfiles.git
   gitbare branch -M main
   gitbare push -u origin main
   ```

## 3. Setup on Windows

1. **Clone the bare repo:**

   ```powershell
   git clone --bare https://github.com/yourusername/dotfiles.git $HOME\dotfiles
   ```

2. **Add the function to your PowerShell profile:**

   ```powershell
   code $PROFILE
   # Add:
   function gitbare {
     git --git-dir=$HOME/dotfiles --work-tree=$HOME $args
   }
   ```

3. **Ignore the bare repo folder:**

   ```powershell
   echo "dotfiles" >> $HOME\.gitignore
   gitbare config --local core.excludesfile $HOME\.gitignore
   ```

4. **Pull your dotfiles:**

   ```powershell
   gitbare checkout
   ```

5. **Remove the old Neovim config folder if it exists:**

   ```powershell
   Remove-Item "$HOME\AppData\Local\nvim" -Recurse -Force
   ```

6. **Create a symlink from the Windows path to the canonical folder:**

   ```powershell
   New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Local\nvim" -Target "$HOME\.config\nvim"
   ```

   ::: details The system cannot find the path specified

   ```sh
   New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Roaming\yazi\config" -Target "$HOME\.config\yazi"
   ```

   The warning "The system cannot find the path specified" means that either the target or the parent directory of the link does not exist. Here are the most common issues to check:

   1. Parent Directory Must Exist:

      - The parent directory of the link (everything before the last `\` in `-Path`) must already exist. PowerShell will not create intermediate directories.

   2. Target Directory Must Exist:

      - The target directory (`$HOME\.config\yazi`) must exist for a directory symlink.

   :::

## 4. Daily Usage

- Edit your Neovim config in `~/.config/nvim` (macOS) or via the symlinked path on Windows.
- Use `gitbare add`, `gitbare commit`, `gitbare push` and `gitbare pull` to sync changes.

## 5. Notes

- Only `~/.config/nvim` is tracked in your dotfiles repo.
- On Windows, `~/AppData/Local/nvim` is just a symlink (pointer) to `~/.config/nvim`.
- On macOS, Neovim reads from `~/.config/nvim` directly.

## 6. Comparison Table: Common Config Paths in $HOME

| Software      | Canonical Folder               | macOS Path                                                | Windows Path                         |
| ------------- | ------------------------------ | --------------------------------------------------------- | ------------------------------------ |
| Vim           | `~/.vimrc`                     | `~/.vimrc`                                                | `~/.vimrc`                           |
| Zsh           | `~/.zshrc`                     | `~/.zshrc`                                                | `~/.zshrc`                           |
| Git Config    | `~/.gitconfig`                 | `~/.gitconfig`                                            | `~/.gitconfig`                       |
| Neovim        | `~/.config/nvim`               | `~/.config/nvim`                                          | `~/AppData/Local/nvim`               |
| Neovim (alt)  | `~/.config/nvim-from-scratch/` | `~/.config/nvim-from-scratch/`                            | `~/AppData/Local/nvim-from-scratch/` |
| Yazi          | `~/.config/yazi/`              | `~/.config/yazi/`                                         | `~/AppData/Roaming/yazi/config`      |
| Typora Themes | `~/.config/typora-themes/`     | `~/Library/Application Support/abnerworks.Typora/themes/` | `~/AppData/Roaming/Typora/themes/`   |
| Bash          | `~/.bashrc`                    | `~/.bashrc`                                               | `~/.bashrc` or `~/.bash_profile`     |
| VS Code User  | `~/.config/vscode-user/`       | `~/Library/Application Support/Code/User`                 | `~/AppData/Roaming/Code/User`        |
| PowerShell    | `~/Documents/PowerShell`       | N/A                                                       | `~/Documents/PowerShell`             |
| SSH Config    | `~/.ssh/config`                | `~/.ssh/config`                                           | `~/.ssh/config`                      |

**Tip:** For true cross-platform sharing, use symlinks to point platform-specific config paths to a single canonical folder tracked in your dotfiles repo.
