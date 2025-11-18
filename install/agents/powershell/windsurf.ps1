# Windsurf installer module (PowerShell)
# Note: common.ps1 is sourced by install.ps1, not here

function Install-Windsurf {
    param([string]$Mode, [string]$Method)

    Write-Info "Installing Windsurf..."
    $sourceDir = Join-Path $script:DotfilesDir "windsurf"

    if (-not (Test-Path $sourceDir)) {
        Write-ErrorMessage "Windsurf source directory not found: $sourceDir"
        return $false
    }

    if ($Mode -eq "home" -or $Mode -eq "both") {
        $homeDir = Join-Path $env:USERPROFILE ".codeium\windsurf\global_workflows"
        Install-WindsurfToTarget -TargetDir $homeDir -SourceDir $sourceDir -Method $Method | Out-Null
    }

    if ($Mode -eq "workspace" -or $Mode -eq "both") {
        Install-WindsurfToTarget -TargetDir ".\.windsurf\workflows" -SourceDir $sourceDir -Method $Method | Out-Null
    }

    Write-Success "Windsurf installation completed"
    return $true
}

function Install-WindsurfToTarget {
    param([string]$TargetDir, [string]$SourceDir, [string]$Method)

    Backup-Existing -Path $TargetDir | Out-Null

    $workflowsSource = Join-Path $SourceDir "workflows"

    if (Test-Path $workflowsSource) {
        if ($Method -eq "symlink") {
            # Remove empty target dir if it exists
            if ((Test-Path $TargetDir) -and (Test-EmptyDirectory -Path $TargetDir) -and -not $script:DryRun) {
                Remove-Item -Path $TargetDir -Force
            }
            New-SymbolicLinkSafe -Source $workflowsSource -Target $TargetDir | Out-Null
        } else {
            Copy-FilesSafe -Source $workflowsSource -Target $TargetDir | Out-Null
        }
    }

    return $true
}
