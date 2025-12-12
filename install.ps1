<#
.SYNOPSIS
    Dotfiles Installation Script for Windows

.DESCRIPTION
    Supports shell configs, git, and AI agent configurations (Claude, Augment, Copilot, Windsurf)

.PARAMETER Interactive
    Interactive AI agent installation with prompts

.PARAMETER AgentsOnly
    Install only AI agents (skip shell/git configurations)

.PARAMETER SkipLegacy
    Skip shell/git/vim installation

.PARAMETER DryRun
    Simulation mode (no changes)

.PARAMETER Help
    Show help message

.EXAMPLE
    .\install.ps1
    Full installation (shell + git + AI agents)

.EXAMPLE
    .\install.ps1 -Interactive
    Interactive AI agent installation

.EXAMPLE
    .\install.ps1 -AgentsOnly
    Install AI agents with defaults

.EXAMPLE
    .\install.ps1 -DryRun
    Preview installation
#>

[CmdletBinding()]
param(
    [switch]$Interactive,
    [switch]$AgentsOnly,
    [switch]$SkipLegacy,
    [switch]$DryRun,
    [switch]$Help
)

# Show help
if ($Help) {
    Get-Help $MyInvocation.MyCommand.Definition -Detailed
    exit 0
}

# Initialize script variables
$script:DryRun = $DryRun.IsPresent
$script:Interactive = $Interactive.IsPresent
$script:DotfilesDir = $PSScriptRoot
$script:BackupDir = Join-Path $env:USERPROFILE ".dotfiles_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
$script:DebugMode = $false

# Source libraries
. "$PSScriptRoot\install\lib\powershell\common.ps1"
. "$PSScriptRoot\install\lib\powershell\prompts.ps1"

# Source agent installers
. "$PSScriptRoot\install\agents\powershell\claude.ps1"
. "$PSScriptRoot\install\agents\powershell\augment.ps1"
. "$PSScriptRoot\install\agents\powershell\copilot.ps1"
. "$PSScriptRoot\install\agents\powershell\windsurf.ps1"

# Main installation function
function Invoke-Main {
    Write-Header "AI Agent Dotfiles Installer"

    if ($script:DryRun) {
        Write-DryRun "═══════════════════════════════════════════════════════════"
        Write-DryRun "  SIMULATION MODE - No changes will be made"
        Write-DryRun "═══════════════════════════════════════════════════════════"
        Write-Host ""
    }

    # Legacy installations (shell, git)
    if (-not $SkipLegacy -and -not $AgentsOnly) {
        Install-LegacyDotfiles
    }

    # AI Agent installations
    if ($Interactive) {
        Install-AgentsInteractive
    } elseif ($AgentsOnly) {
        Install-AgentsDefault
    } else {
        # Default: Ask if user wants to install agents
        Write-Host ""
        if (Read-YesNo -Question "Do you want to install AI agent configurations?" -Default "y") {
            if (Read-YesNo -Question "Use interactive mode?" -Default "y") {
                Install-AgentsInteractive
            } else {
                Install-AgentsDefault
            }
        }
    }

    # Summary
    Show-Summary
}

# Configure git user information
function Initialize-GitUser {
    $gitconfigLocal = Join-Path $env:USERPROFILE ".gitconfig.local"

    Write-Info "Configuring Git user information..."

    # Check if ~/.gitconfig.local already exists with valid user data
    if (Test-Path $gitconfigLocal) {
        $currentName = git config --file $gitconfigLocal user.name 2>$null
        $currentEmail = git config --file $gitconfigLocal user.email 2>$null

        if ($currentName -and $currentEmail) {
            Write-Info "Git user already configured in ~/.gitconfig.local: $currentName <$currentEmail>"
            return
        }
    }

    # Prompt for user information
    Write-Host ""
    Write-Info "Please enter your Git user information:"

    $gitName = Read-Host "  Full Name"
    $gitEmail = Read-Host "  Email"

    # Validate input
    if (-not $gitName -or -not $gitEmail) {
        Write-Warn "Git user information not provided. Skipping git user configuration."
        Write-Warn "You can configure it later by editing: ~/.gitconfig.local"
        Write-Warn "  Example:"
        Write-Warn "    [user]"
        Write-Warn "        name = Your Name"
        Write-Warn "        email = your.email@example.com"
        return
    }

    # Create ~/.gitconfig.local with user information
    if (-not $script:DryRun) {
        $content = @"
# Local Git configuration (user-specific settings)
# This file is included by ~/.gitconfig and is NOT tracked in version control
[user]
    name = $gitName
    email = $gitEmail
"@
        Set-Content -Path $gitconfigLocal -Value $content
        Write-Success "Created ~/.gitconfig.local with your user information"
        Write-Info "Note: Edit ~/.gitconfig.local to add additional personal settings"
    } else {
        Write-DryRun "Would create ~/.gitconfig.local with: $gitName <$gitEmail>"
    }

    Write-Host ""
}

# Install legacy dotfiles (shell, git)
function Install-LegacyDotfiles {
    Write-Section "Legacy Dotfiles Installation"

    Write-Info "Setting up git configurations..."

    # Configure git user if ~/.gitconfig.local doesn't exist
    $gitconfigLocal = Join-Path $env:USERPROFILE ".gitconfig.local"
    if (-not (Test-Path $gitconfigLocal)) {
        Initialize-GitUser
    } else {
        Write-Info "Found existing ~/.gitconfig.local - skipping user configuration"
    }

    $gitConfigTarget = "$env:USERPROFILE\.gitconfig"
    $gitConfigSource = Join-Path $script:DotfilesDir "git\gitconfig"
    $gitIgnoreSource = Join-Path $script:DotfilesDir "git\gitignore_global"

    if (Test-Path $gitConfigSource) {
        New-SymbolicLinkSafe -Source $gitConfigSource -Target $gitConfigTarget | Out-Null
    }
    if (Test-Path $gitIgnoreSource) {
        New-SymbolicLinkSafe -Source $gitIgnoreSource -Target "$env:USERPROFILE\.gitignore_global" | Out-Null
    }

    Write-Host ""
}

# Interactive AI agent installation
function Install-AgentsInteractive {
    Write-Section "Interactive AI Agent Installation"

    # Prompt for installation target
    $target = Read-InstallationTarget
    Write-Debug "Selected target: $target"

    # Prompt for agent selection
    $agents = Read-AgentSelection
    Write-Debug "Selected agents: $($agents -join ', ')"

    if ($agents.Count -eq 0) {
        Write-Warn "No agents selected. Skipping agent installation."
        return
    }

    # Prompt for installation method
    $method = Read-InstallationMethod
    Write-Debug "Selected method: $method"

    # Display installation plan
    Show-InstallationPlan -Target $target -Agents $agents -Method $method

    # Confirm installation
    if (-not (Confirm-Installation)) {
        Write-Warn "Installation cancelled by user"
        return
    }

    # Perform installation
    foreach ($agent in $agents) {
        switch ($agent) {
            "augment" {
                Install-AugmentCode -Mode $target -Method $method | Out-Null
            }
            "claude" {
                Install-ClaudeCode -Mode $target -Method $method | Out-Null
            }
            "copilot" {
                Install-GitHubCopilot -Mode $target -Method $method | Out-Null
            }
            "windsurf" {
                Install-Windsurf -Mode $target -Method $method | Out-Null
            }
            "antigravity" {
                Install-Antigravity -Mode $target -Method $method | Out-Null
            }
            default {
                Write-ErrorMessage "Unknown agent: $agent"
            }
        }
    }

    Write-Host ""
}

# Default AI agent installation (non-interactive)
function Install-AgentsDefault {
    Write-Section "AI Agent Installation (Default)"

    Write-Info "Installing Claude Code to home directory..."
    Install-ClaudeCode -Mode "home" -Method "symlink"

    Write-Host ""
}

# Print installation summary
function Show-Summary {
    $width = 60
    $textWidth = $width - 2

    Write-Host ""
    if ($script:DryRun) {
        Write-DryRun "╔$('═' * $width)╗"
        Write-DryRun "║  $('Simulation completed - No changes were made'.PadRight($textWidth))║"
        Write-DryRun "╚$('═' * $width)╝"
        Write-Host ""
        Write-Info "To perform the actual installation, run: .\install.ps1"
    } else {
        Write-Success "╔$('═' * $width)╗"
        Write-Success "║  $('Installation completed successfully! 🎉'.PadRight($textWidth))║"
        Write-Success "╚$('═' * $width)╝"
        Write-Host ""

        if (Test-Path $script:BackupDir) {
            Write-Info "Backup files stored in: $script:BackupDir"
        }

        Write-Host ""
        Write-Info "Next steps:"
        Write-Info "  1. Restart your terminal"
        Write-Info "  2. Verify AI agent configurations are available"
        Write-Info "  3. Customize local configs as needed"
    }

    # Show brief installation summary
    $claudeHome = Join-Path $env:USERPROFILE ".claude"
    $claudeWorkspace = ".\.claude"

    $installedLocations = @()
    if (Test-Path (Join-Path $claudeHome "commands")) {
        $installedLocations += "home directory"
    }
    if (Test-Path (Join-Path $claudeWorkspace "commands")) {
        $installedLocations += "workspace"
    }

    if ($installedLocations.Count -gt 0) {
        Write-Host ""
        Write-Info "Claude Code installed in: $($installedLocations -join ', ')"
        Write-Info "Use /help to see available commands"
    }

    Write-Host ""
}

# Run main installation
Invoke-Main
