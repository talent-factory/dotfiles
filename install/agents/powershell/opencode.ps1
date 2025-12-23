# OpenCode installer module (PowerShell)
# Note: common.ps1 is sourced by install.ps1, not here

function Install-OpenCode {
    param([string]$Mode, [string]$Method)

    Write-Info "Installing OpenCode..."
    $sourceDir = Join-Path $script:DotfilesDir "agents\opencode"

    if (-not (Test-Path $sourceDir)) {
        Write-ErrorMessage "OpenCode source directory not found: $sourceDir"
        return $false
    }

    if ($Mode -eq "home" -or $Mode -eq "both") {
        Install-OpenCodeToTarget -TargetDir "$env:USERPROFILE\.config\opencode" -SourceDir $sourceDir -Method $Method | Out-Null
    }

    if ($Mode -eq "workspace" -or $Mode -eq "both") {
        Install-OpenCodeToTarget -TargetDir ".\.opencode" -SourceDir $sourceDir -Method $Method | Out-Null
    }

    Write-Success "OpenCode installation completed"
    return $true
}

function Install-OpenCodeToTarget {
    param([string]$TargetDir, [string]$SourceDir, [string]$Method)

    $sharedDir = Join-Path $script:DotfilesDir "agents\_shared"

    Backup-Existing -Path $TargetDir | Out-Null

    if (-not $script:DryRun) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }

    # OpenCode uses "command" (singular) instead of "commands"
    $sharedCommands = Join-Path $sharedDir "commands"
    $commandTarget = Join-Path $TargetDir "command"

    if (Test-Path $sharedCommands) {
        if ($Method -eq "symlink") {
            New-SymbolicLinkSafe -Source $sharedCommands -Target $commandTarget | Out-Null
        } else {
            Copy-FilesSafe -Source $sharedCommands -Target $commandTarget | Out-Null
        }
    }

    # Install references (support documentation for commands)
    $referencesSource = Join-Path $sharedDir "references"
    $referencesTarget = Join-Path $TargetDir "references"

    if (Test-Path $referencesSource) {
        if ($Method -eq "symlink") {
            New-SymbolicLinkSafe -Source $referencesSource -Target $referencesTarget | Out-Null
        } else {
            Copy-FilesSafe -Source $referencesSource -Target $referencesTarget | Out-Null
        }
    }

    return $true
}
