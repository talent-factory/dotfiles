# Augment Code installer module (PowerShell)
# Note: common.ps1 is sourced by install.ps1, not here

function Install-AugmentCode {
    param([string]$Mode, [string]$Method)

    Write-Info "Installing Augment Code..."
    $sourceDir = Join-Path $script:DotfilesDir "agents\augment"

    if (-not (Test-Path $sourceDir)) {
        Write-ErrorMessage "Augment source directory not found: $sourceDir"
        return $false
    }

    if ($Mode -eq "home" -or $Mode -eq "both") {
        Install-AugmentToTarget -TargetDir "$env:USERPROFILE\.augment" -SourceDir $sourceDir -Method $Method | Out-Null
    }

    if ($Mode -eq "workspace" -or $Mode -eq "both") {
        Install-AugmentToTarget -TargetDir ".\.augment" -SourceDir $sourceDir -Method $Method | Out-Null
    }

    Write-Success "Augment Code installation completed"
    return $true
}

function Install-AugmentToTarget {
    param([string]$TargetDir, [string]$SourceDir, [string]$Method)

    Backup-Existing -Path $TargetDir | Out-Null

    if (-not $script:DryRun) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }

    $commandsSource = Join-Path $SourceDir "commands"
    $commandsTarget = Join-Path $TargetDir "commands"

    if (Test-Path $commandsSource) {
        if ($Method -eq "symlink") {
            New-SymbolicLinkSafe -Source $commandsSource -Target $commandsTarget | Out-Null
        } else {
            Copy-FilesSafe -Source $commandsSource -Target $commandsTarget | Out-Null
        }
    }

    return $true
}
