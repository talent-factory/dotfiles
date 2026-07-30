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

    # Install agents (OpenCode-specific AI agents)
    $agentSource = Join-Path $sourceDir "agent"
    $agentTarget = Join-Path $TargetDir "agent"

    if (Test-Path $agentSource) {
        if ($Method -eq "symlink") {
            New-SymbolicLinkSafe -Source $agentSource -Target $agentTarget | Out-Null
        } else {
            Copy-FilesSafe -Source $agentSource -Target $agentTarget | Out-Null
        }
        Write-Debug "OpenCode agent source: $agentSource"
    } else {
        Write-Warn "OpenCode agent directory not found: $agentSource"
        Get-ChildItem $sourceDir -ErrorAction SilentlyContinue | ForEach-Object { Write-Debug "Found in source: $($_.FullName)" }
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
        Write-Debug "Commands source: $sharedCommands"
    } else {
        Write-Warn "Shared commands directory not found: $sharedCommands"
        Get-ChildItem $sharedDir -ErrorAction SilentlyContinue | ForEach-Object { Write-Debug "Found in shared: $($_.FullName)" }
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
        Write-Debug "References source: $referencesSource"
    } else {
        Write-Warn "References directory not found: $referencesSource"
        Get-ChildItem $sharedDir -ErrorAction SilentlyContinue | ForEach-Object { Write-Debug "Found in shared: $($_.FullName)" }
    }

    return $true
}
