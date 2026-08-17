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

# ================================
# Auto-activate venv environments 
# ================================

function Update-Venv {
    $dir = Get-Item .
    $foundVenv = $null

    # Search current directory and parents
    while ($dir) {
        foreach ($candidate in @(".venv", "venv")) {
            $venvPath = Join-Path $dir.FullName $candidate
            $activate = Join-Path $venvPath "Scripts\Activate.ps1"

            if (Test-Path $activate) {
                $foundVenv = $venvPath
                break
            }
        }

        if ($foundVenv) { break }

        $dir = $dir.Parent
    }

    # Currently active venv
    $activeVenv = $env:VIRTUAL_ENV

    if ($foundVenv) {
        # Entered a project or switched projects
        if ($activeVenv -ne $foundVenv) {

            if (Get-Command deactivate -ErrorAction SilentlyContinue) {
                deactivate
            }

            & (Join-Path $foundVenv "Scripts\Activate.ps1")
        }
    }
    else {
        # No venv found anywhere above current directory
        if ($activeVenv -and (Get-Command deactivate -ErrorAction SilentlyContinue)) {
            deactivate
        }
    }
}

# Fix for starship prompt function override
$StarshipPrompt = $function:prompt

function prompt {
	Update-Venv
	& $StarshipPrompt
}

# ==============================
#  Aliases
# ==============================

Set-Alias vim "$env:LOCALAPPDATA\Programs\Vim\vim.exe"
Set-Alias du duh
