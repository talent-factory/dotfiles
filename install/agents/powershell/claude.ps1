# Claude Code installer module (PowerShell)

# Source common functions
. "$PSScriptRoot\..\..\lib\powershell\common.ps1"

# Install Claude Code configuration
function Install-ClaudeCode {
    param(
        [string]$Mode,      # "home", "workspace", or "both"
        [string]$Method     # "symlink" or "copy"
    )

    Write-Info "Installing Claude Code..."

    $sourceDir = Join-Path $script:DotfilesDir "agents\claude"

    if (-not (Test-Path $sourceDir)) {
        Write-ErrorMessage "Claude source directory not found: $sourceDir"
        return $false
    }

    # Install to home directory
    if ($Mode -eq "home" -or $Mode -eq "both") {
        Install-ClaudeToTarget -TargetDir "$env:USERPROFILE\.claude" -SourceDir $sourceDir -Method $Method
    }

    # Install to workspace
    if ($Mode -eq "workspace" -or $Mode -eq "both") {
        Install-ClaudeToTarget -TargetDir ".\.claude" -SourceDir $sourceDir -Method $Method
    }

    Write-Success "Claude Code installation completed"
    return $true
}

# Internal function to install to specific target
function Install-ClaudeToTarget {
    param(
        [string]$TargetDir,
        [string]$SourceDir,
        [string]$Method
    )

    Write-Debug "Installing Claude to: $TargetDir (method: $Method)"

    # Backup existing installation
    Backup-Existing -Path $TargetDir

    # Create target directory
    if (-not $script:DryRun) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }

    # Install commands
    $commandsSource = Join-Path $SourceDir "commands"
    $commandsTarget = Join-Path $TargetDir "commands"

    if (Test-Path $commandsSource) {
        switch ($Method) {
            "symlink" {
                New-SymbolicLinkSafe -Source $commandsSource -Target $commandsTarget
            }
            "copy" {
                Copy-FilesSafe -Source $commandsSource -Target $commandsTarget
            }
            default {
                Write-ErrorMessage "Invalid installation method: $Method"
                return $false
            }
        }
    } else {
        Write-Warn "Commands directory not found: $commandsSource"
    }

    # Install agents
    $agentsSource = Join-Path $SourceDir "agents"
    $agentsTarget = Join-Path $TargetDir "agents"

    if (Test-Path $agentsSource) {
        switch ($Method) {
            "symlink" {
                New-SymbolicLinkSafe -Source $agentsSource -Target $agentsTarget
            }
            "copy" {
                Copy-FilesSafe -Source $agentsSource -Target $agentsTarget
            }
        }
    } else {
        Write-Warn "Agents directory not found: $agentsSource"
    }

    # Verify installation
    Test-ClaudeInstallation -TargetDir $TargetDir

    return $true
}

# Verify Claude installation
function Test-ClaudeInstallation {
    param([string]$TargetDir)

    if ($script:DryRun) {
        Write-DryRun "Would verify Claude installation at: $TargetDir"
        return $true
    }

    $errors = 0

    # Check commands directory
    $commandsDir = Join-Path $TargetDir "commands"
    if (Test-Path $commandsDir) {
        $cmdCount = (Get-ChildItem -Path $commandsDir -Filter "*.md" -Recurse -File).Count
        Write-Success "Commands directory verified ($cmdCount commands found)"
    } else {
        Write-ErrorMessage "Commands directory not found: $commandsDir"
        $errors++
    }

    # Check agents directory
    $agentsDir = Join-Path $TargetDir "agents"
    if (Test-Path $agentsDir) {
        $agentCount = (Get-ChildItem -Path $agentsDir -Filter "*.md" -Recurse -File).Count
        Write-Success "Agents directory verified ($agentCount agents found)"
    } else {
        Write-ErrorMessage "Agents directory not found: $agentsDir"
        $errors++
    }

    if ($errors -eq 0) {
        Write-Success "Claude Code installation verified at: $TargetDir"
        return $true
    } else {
        Write-ErrorMessage "Claude Code installation verification failed ($errors errors)"
        return $false
    }
}

# List available Claude commands
function Show-ClaudeCommands {
    param([string]$TargetDir)

    $commandsDir = Join-Path $TargetDir "commands"

    if (-not (Test-Path $commandsDir)) {
        Write-Warn "Commands directory not found: $commandsDir"
        return
    }

    Write-Host ""
    Write-Host "Available Claude Code commands:"
    Write-Host ""

    Get-ChildItem -Path $commandsDir -Filter "*.md" -Recurse -File | Sort-Object FullName | ForEach-Object {
        $cmdName = $_.BaseName
        $cmdPath = $_.DirectoryName.Replace($commandsDir, "").TrimStart('\')

        if ([string]::IsNullOrEmpty($cmdPath)) {
            Write-Host "  • /$cmdName"
        } else {
            $cmdPath = $cmdPath.Replace('\', ':')
            Write-Host "  • /$cmdPath`:$cmdName"
        }

        # Try to extract description from frontmatter
        $content = Get-Content $_.FullName -ErrorAction SilentlyContinue
        $inFrontmatter = $false
        foreach ($line in $content) {
            if ($line -match '^---$') {
                $inFrontmatter = -not $inFrontmatter
                continue
            }
            if ($inFrontmatter -and $line -match '^description:\s*(.+)$') {
                Write-Host "    $($matches[1].Trim())"
                break
            }
        }
    }

    Write-Host ""
}
