# Aliases
Set-Alias vi nvim
Set-Alias tr tree

# Enviromental Variables
$env:GEMINI_API_KEY="AIzaSyA-7XagPZBx6QKfmMDyR9E69mFrbQLlVng"


# Functions
function whereis ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Function to select different Neovim configurations interactively with file support
function nvims {
    param(
        [string]$filename = ""
    )

    $items = @("default", "nvim-from-scratch")
    # Icons copied here https://www.nerdfonts.com/cheat-sheet
    $config = $items | fzf --prompt="  Neovim Config " --height=50% --layout=reverse --border

    if (-not $config) {
        Write-Output "Nothing selected"
        return
    } elseif ($config -eq "default") {
        $env:NVIM_APPNAME = ""
    } else {
        $env:NVIM_APPNAME = $config
    }

    # Open Neovim with the provided file or without arguments if no file is specified
    if ($filename -ne "") {
        nvim $filename
    } else {
        nvim
    }
}

function gitbare {
git --git-dir=$HOME/dotfiles --work-tree=$HOME $args
}

# Terminal Icons
Import-Module Terminal-Icons

# PSReadLine
Import-Module PSReadLine
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -PredictionViewStyle ListView

# Setup zoxide on your shell
# Add this to the end of your config file
Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })

# This y shell wrapper provides the ability to change the current working directory when exiting Yazi.
# Use y instead of yazi to start, and press q to quit, you'll see the CWD changed.
# Sometimes, you don't want to change, press Q to quit.
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath ([System.IO.Path]::GetFullPath($cwd))
    }
    Remove-Item -Path $tmp
}
