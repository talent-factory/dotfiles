# Windsurf and Antigravity installer module (PowerShell)
# Note: common.ps1 is sourced by install.ps1, not here

function Install-Windsurf {
    param([string]$Mode, [string]$Method)

    Write-Info "Installing Windsurf..."
    $sourceDir = Join-Path $script:DotfilesDir "agents\windsurf"

    if (-not (Test-Path $sourceDir)) {
        Write-ErrorMessage "Windsurf source directory not found: $sourceDir"
        return $false
    }

    # Install to home directory (global workflows) - FLAT structure required
    if ($Mode -eq "home" -or $Mode -eq "both") {
        $homeDir = Join-Path $env:USERPROFILE ".codeium\windsurf\global_workflows"
        Install-WindsurfToTarget -TargetDir $homeDir -SourceDir $sourceDir -Method $Method -Structure "flat" | Out-Null
    }

    # Install to workspace - hierarchical structure allowed
    if ($Mode -eq "workspace" -or $Mode -eq "both") {
        Install-WindsurfToTarget -TargetDir ".\.windsurf\workflows" -SourceDir $sourceDir -Method $Method -Structure "hierarchical" | Out-Null
    }

    Write-Success "Windsurf installation completed"
    return $true
}

function Install-Antigravity {
    param([string]$Mode, [string]$Method)

    Write-Info "Installing Antigravity..."
    $sourceDir = Join-Path $script:DotfilesDir "agents\windsurf"

    if (-not (Test-Path $sourceDir)) {
        Write-ErrorMessage "Antigravity source directory not found: $sourceDir"
        return $false
    }

    # Install to home directory (global workflows) - FLAT structure required
    if ($Mode -eq "home" -or $Mode -eq "both") {
        $homeDir = Join-Path $env:USERPROFILE ".gemini\windsurf\global_workflows"
        Install-WindsurfToTarget -TargetDir $homeDir -SourceDir $sourceDir -Method $Method -Structure "flat" | Out-Null
    }

    # Install to workspace - hierarchical structure allowed
    if ($Mode -eq "workspace" -or $Mode -eq "both") {
        Install-WindsurfToTarget -TargetDir ".\.windsurf\workflows" -SourceDir $sourceDir -Method $Method -Structure "hierarchical" | Out-Null
    }

    Write-Success "Antigravity installation completed"
    return $true
}

function Install-WindsurfToTarget {
    param(
        [string]$TargetDir,
        [string]$SourceDir,
        [string]$Method,
        [string]$Structure = "hierarchical"  # "flat" or "hierarchical"
    )

    Backup-Existing -Path $TargetDir | Out-Null

    $workflowsSource = Join-Path $SourceDir "workflows"

    if (Test-Path $workflowsSource) {
        if ($Structure -eq "flat") {
            # Flat installation: copy/symlink all .md files directly to target (no subdirectories)
            Install-Flat -SourceDir $workflowsSource -TargetDir $TargetDir -Method $Method
        } else {
            # Hierarchical installation: preserve directory structure
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
    }

    return $true
}

function Install-Flat {
    param(
        [string]$SourceDir,
        [string]$TargetDir,
        [string]$Method
    )

    Write-Debug "Flat installation: $SourceDir -> $TargetDir"

    # Create target directory
    if (-not $script:DryRun) {
        if (-not (Test-Path $TargetDir)) {
            New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
        }
    } else {
        Write-DryRun "Would create directory: $TargetDir"
    }

    # Find all .md files recursively
    $mdFiles = Get-ChildItem -Path $SourceDir -Filter "*.md" -Recurse -File

    if ($mdFiles.Count -eq 0) {
        Write-Warn "No .md files found in: $SourceDir"
        return
    }

    Write-Info "Installing $($mdFiles.Count) workflow files (flat)..."

    $installedFiles = @{}
    foreach ($file in $mdFiles) {
        $targetFile = Join-Path $TargetDir $file.Name

        # Check for duplicate filenames
        if ($installedFiles.ContainsKey($file.Name)) {
            Write-Warn "Duplicate filename: $($file.Name) (skipping)"
            continue
        }
        $installedFiles[$file.Name] = $true

        if ($Method -eq "symlink") {
            New-SymbolicLinkSafe -Source $file.FullName -Target $targetFile | Out-Null
        } else {
            if (-not $script:DryRun) {
                Copy-Item -Path $file.FullName -Destination $targetFile -Force
                Write-Debug "Copied: $($file.Name)"
            } else {
                Write-DryRun "Would copy: $($file.Name)"
            }
        }
    }
}
