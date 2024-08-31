# Transform basic git into gitbare with two positional parameters
function gitbare {
  git --git-dir=$HOME/dotfiles --work-tree=$HOME $args
}

# Functions to launch different Neovim configurations in PowerShell
function kv {
  $env:NVIM_APPNAME = "nvim-kickstart"
  nvim
} 
function lv {
  $env:NVIM_APPNAME = "nvim-lazyvim"
  nvim
} 
# Function to select different Neovim configurations interactively
function nvims {
    $items = @("default", "nvim-lazyvim", "nvim-kickstart")
    $config = $items | fzf --prompt=" Neovim Config  " --height=50% --layout=reverse --border
    if (-not $config) {
        Write-Output "Nothing selected"
        return
    } elseif ($config -eq "default") {
        $env:NVIM_APPNAME = ""
    } else {
        $env:NVIM_APPNAME = $config
    }
    nvim
}

#Prompt

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\clean-detailed.omp.json" | Invoke-Expression

#Functions
function whereis ($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue |
	Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
} 

#Terminal Icons
Import-Module Terminal-Icons

#PSReadLine
Import-Module PSReadLine
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineOption -PredictionViewStyle ListView

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
