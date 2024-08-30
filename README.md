- Goal: Manage and backup various configuration files on your computer through Git.
- System: Windows 10, PowerShell 7.5.3 Preview
- Method: Through a bare Git repository

## Backup

1. Create a new folder `$HOME/dotfiles` and run `git init --bare` to initialize it as a bare repository (without a working directory) to track the configuration files you need to manage
2. Transform the basic git command into the gitbare command, i.e. when running gitbare in PowerShell instead of basic git, Git automatically treats `$HOME/dotfiles` as the repository and the entire `$HOME` directory as the workspace. To accomplish this substitution, simply run `code $PROFILE` in PowerShell, open the configuration file using VS Code, and add the following function:

   ```ps1
   function gitbare {
   git --git-dir=$HOME/dotfiles --work-tree=$HOME $args
   }

   ```

3. After step 2, when we need to work on our dotfiles repository, we can use the retrofit `gitbare add`, `gitbare commit`, and `gitbare remote` instead of the original `git add`, `git commit`, and `git remote`
4. Create a new repository on Github, https://github.com/user-name/dotfiles
   ```ps
   gitbare remote add origin https://github.com/user-name/dotfiles.git
   gitbare branch -M main
   gitbare push -u origin main
   ```
5. Now you can selectively add, commit, and push configuration files from your `$HOME` directory to your remote Github repository for backup

## Pull

To be tested...

## Reference

- https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/
- https://www.daytona.io/dotfiles/ultimate-guide-to-dotfiles
- https://www.youtube.com/watch?v=iYElODEf6awo
- https://github.com/pawelbialaszczyk/dotfiles
