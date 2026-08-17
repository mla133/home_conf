# ==============================
#  Aliases
# ==============================

Set-Alias vim "$env:LOCALAPPDATA\Programs\Vim\vim.exe"
Set-Alias du duh

# ==============================
#  Starship Init & Config
# ==============================

Invoke-Expression (&starship init powershell)
$ENV:STARSHIP_CONFIG = "$HOME\starship.toml"


# Offline GitHub Copilot Aliasing and Configuration
# Check this later for usability now --MLA 081726
Import-Module PSReadLine
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
$scriptblock = {
    param($wordToComplete, $commandAst, $cursorPosition)
    $Env:_OFFLINE_COPILOT_COMPLETE = "complete_powershell"
    $Env:_TYPER_COMPLETE_ARGS = $commandAst.ToString()
    $Env:_TYPER_COMPLETE_WORD_TO_COMPLETE = $wordToComplete
    offline-copilot | ForEach-Object {
        $commandArray = $_ -Split ":::"
        $command = $commandArray[0]
        $helpString = $commandArray[1]
        [System.Management.Automation.CompletionResult]::new(
            $command, $command, 'ParameterValue', $helpString)
    }
    $Env:_OFFLINE_COPILOT_COMPLETE = ""
    $Env:_TYPER_COMPLETE_ARGS = ""
    $Env:_TYPER_COMPLETE_WORD_TO_COMPLETE = ""
}
Register-ArgumentCompleter -Native -CommandName offline-copilot -ScriptBlock $scriptblock


# ==============================
# Disk usage functions
# ==============================

function duh {
    param(
        [string]$Path = "."
    )

    Get-ChildItem $Path -Directory | ForEach-Object {
        $size = (Get-ChildItem $_.FullName -Recurse -File |
            Measure-Object Length -Sum).Sum

        [PSCustomObject]@{
            Directory = $_.Name
            SizeMB    = "{0:N2}" -f ($size / 1MB)
        }
    } | Sort-Object { [double]$_.SizeMB } -Descending
}


# ==============================
# Reload profile after edits... 
# ==============================

. $PROFILE
