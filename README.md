- 目标：通过 Git 管理和备份电脑上的各种配置文件
- 系统：Windows 10, PowerShell 7.5.3 Preview
- 方法：a bare git repository

## 实现步骤

1. 创建一个新文件夹 `$HOME/dotfiles`，运行命令 `git init --bare` 将其初始化成一个（不包含工作目录的）光杆仓库，用于追踪需要管理的各个配置文件
2. 把基本的 git 命令改造为 gitbare，即当运行 gitbare 时，Git 会自动把 `$HOME/dotfiles` 当作仓库，而把整个 `$HOME` 目录作为工作区。 在 PowerShell 运行 `code $PROFILE`，使用 VS Code 打开配置文件，添加如下函数：
   ```ps1
   function gitbare {
     git --git-dir=$HOME/dotfiles --work-tree=$HOME $args
   }
   ```

## 参考资料

https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/
https://www.daytona.io/dotfiles/ultimate-guide-to-dotfiles
https://www.youtube.com/watch?v=iYElODEf6awo
https://github.com/pawelbialaszczyk/dotfiles
