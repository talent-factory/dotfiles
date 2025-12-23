# Interactive prompts for dotfiles installation (PowerShell)

# Source common functions
. "$PSScriptRoot\common.ps1"

# Prompt for installation target (home vs workspace)
function Read-InstallationTarget {
    Write-Section "Installation Target"

    Write-Host @"
Where do you want to install AI agent configurations?

  1) Home directory (%USERPROFILE%\.claude, %USERPROFILE%\.augment, etc.)
     * Available globally for all projects
     * Persists across terminal sessions

  2) Current workspace (project-specific)
     * Only available in this project
     * Can be committed to version control

  3) Both
     * Install in both locations

"@

    while ($true) {
        $choice = Read-Host "Select option [1-3]"
        switch ($choice) {
            "1" { return "home" }
            "2" { return "workspace" }
            "3" { return "both" }
            default { Write-Host "Invalid choice. Please select 1, 2, or 3." }
        }
    }
}

# Prompt for AI agents to install
function Read-AgentSelection {
    Write-Section "AI Agent Selection"

    Write-Host "Which AI agents do you use?"
    Write-Host ""

    $agents = @("augment", "claude", "copilot", "windsurf", "antigravity", "opencode")
    $agentNames = @("Augment Code", "Claude Code", "GitHub Copilot", "Windsurf", "Antigravity", "OpenCode")
    $selected = @($false, $true, $false, $false, $false, $false)  # Default: Claude is pre-selected

    Write-Host "Instructions: Toggle by number (comma-separated, e.g., 1,2,5)"
    Write-Host ""

    for ($i = 0; $i -lt $agents.Length; $i++) {
        $mark = if ($selected[$i]) { "[X]" } else { "[ ]" }
        Write-Host "  $mark $($i+1)) $($agentNames[$i])"
    }
    Write-Host ""

    $choices = Read-Host "Toggle selections"

    if (-not [string]::IsNullOrWhiteSpace($choices)) {
        $choiceArray = $choices -split ',' | ForEach-Object { $_.Trim() }

        foreach ($choice in $choiceArray) {
            if ($choice -match '^\d+$') {
                $idx = [int]$choice - 1
                if ($idx -ge 0 -and $idx -lt $agents.Length) {
                    $selected[$idx] = -not $selected[$idx]
                }
            }
        }
    }

    # Return selected agents
    $result = @()
    for ($i = 0; $i -lt $agents.Length; $i++) {
        if ($selected[$i]) {
            $result += $agents[$i]
        }
    }

    return $result
}

# Prompt for installation method (symlink vs copy)
function Read-InstallationMethod {
    Write-Section "Installation Method"

    Write-Host @"
How do you want to install?

  1) Symlink (recommended)
     * Changes to dotfiles repository immediately reflected
     * Requires Administrator rights or Developer Mode
     * Best for active development

  2) Copy files
     * Independent copy of configurations
     * No special permissions required
     * Safer for production use

"@

    while ($true) {
        $choice = Read-Host "Select option [1-2]"
        switch ($choice) {
            "1" { return "symlink" }
            "2" { return "copy" }
            default { Write-Host "Invalid choice. Please select 1 or 2." }
        }
    }
}

# Display installation plan
function Show-InstallationPlan {
    param(
        [string]$Target,
        [string[]]$Agents,
        [string]$Method
    )

    Write-Section "Installation Plan"

    Write-Host "Target: $Target"
    Write-Host "Method: $Method"
    Write-Host "Agents: $($Agents -join ', ')"
    Write-Host ""

    foreach ($agent in $Agents) {
        switch ($agent) {
            "augment" {
                if ($Target -eq "home" -or $Target -eq "both") {
                    Write-Host "  [+] Augment Code -> %USERPROFILE%\.augment\commands\"
                }
                if ($Target -eq "workspace" -or $Target -eq "both") {
                    Write-Host "  [+] Augment Code -> .\.augment\commands\"
                }
            }
            "claude" {
                if ($Target -eq "home" -or $Target -eq "both") {
                    Write-Host "  [+] Claude Code -> %USERPROFILE%\.claude\commands\ & agents\"
                }
                if ($Target -eq "workspace" -or $Target -eq "both") {
                    Write-Host "  [+] Claude Code -> .\.claude\commands\ & agents\"
                }
            }
            "copilot" {
                if ($Target -eq "home" -or $Target -eq "both") {
                    Write-Host "  [+] GitHub Copilot -> %APPDATA%\Code\User\prompts"
                }
                if ($Target -eq "workspace" -or $Target -eq "both") {
                    Write-Host "  [+] GitHub Copilot -> .\.github\prompts\"
                }
            }
            "windsurf" {
                if ($Target -eq "home" -or $Target -eq "both") {
                    Write-Host "  [+] Windsurf -> %USERPROFILE%\.codeium\windsurf\global_workflows"
                }
                if ($Target -eq "workspace" -or $Target -eq "both") {
                    Write-Host "  [+] Windsurf -> .\.windsurf\workflows\"
                }
            }
            "antigravity" {
                if ($Target -eq "home" -or $Target -eq "both") {
                    Write-Host "  [+] Antigravity -> %USERPROFILE%\.gemini\windsurf\global_workflows"
                }
                if ($Target -eq "workspace" -or $Target -eq "both") {
                    Write-Host "  [+] Antigravity -> .\.windsurf\workflows\"
                }
            }
            "opencode" {
                if ($Target -eq "home" -or $Target -eq "both") {
                    Write-Host "  [+] OpenCode -> %USERPROFILE%\.config\opencode\command\"
                }
                if ($Target -eq "workspace" -or $Target -eq "both") {
                    Write-Host "  [+] OpenCode -> .\.opencode\command\"
                }
            }
        }
    }

    Write-Host ""
}

# Confirm installation
function Confirm-Installation {
    return Read-YesNo -Question "Proceed with installation?" -Default "y"
}
