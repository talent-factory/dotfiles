# GitHub Copilot installer module (PowerShell)
# Note: common.ps1 is sourced by install.ps1, not here

function Install-GitHubCopilot {
    param([string]$Mode, [string]$Method)

    Write-Info "Installing GitHub Copilot..."
    $sourceDir = Join-Path $script:DotfilesDir "copilot"

    if (-not (Test-Path $sourceDir)) {
        Write-ErrorMessage "Copilot source directory not found: $sourceDir"
        return $false
    }

    if ($Mode -eq "home" -or $Mode -eq "both") {
        $homeDir = Join-Path $env:APPDATA "Code\User\prompts"
        Install-CopilotToTarget -TargetDir $homeDir -SourceDir $sourceDir -Method $Method | Out-Null
    }

    if ($Mode -eq "workspace" -or $Mode -eq "both") {
        Install-CopilotToTarget -TargetDir ".\.github\prompts" -SourceDir $sourceDir -Method $Method | Out-Null
        Show-CopilotActivationInstructions
    }

    Write-Success "GitHub Copilot installation completed"
    return $true
}

function Install-CopilotToTarget {
    param([string]$TargetDir, [string]$SourceDir, [string]$Method)

    Backup-Existing -Path $TargetDir | Out-Null

    $promptsSource = Join-Path $SourceDir "prompts"

    if (Test-Path $promptsSource) {
        switch ($Method) {
            "symlink" {
                # For symlink, don't create target directory - symlink will replace it
                $result = New-SymbolicLinkSafe -Source $promptsSource -Target $TargetDir
                if (-not $result) {
                    Write-Warn "Symlink creation failed, falling back to copy method"
                    # Fallback to copy if symlink fails
                    if (-not $script:DryRun) {
                        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
                    }
                    Copy-FilesSafe -Source $promptsSource -Target $TargetDir | Out-Null
                }
            }
            "copy" {
                # For copy, create target directory first
                if (-not $script:DryRun) {
                    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
                }
                Copy-FilesSafe -Source $promptsSource -Target $TargetDir | Out-Null
            }
            default {
                Write-ErrorMessage "Invalid installation method: $Method"
                return $false
            }
        }
    }

    return $true
}

function Show-CopilotActivationInstructions {
    if ($script:DryRun) { return }

    Write-Host ""
    Write-Info "================================================================"
    Write-Info "  GitHub Copilot Activation Required"
    Write-Info "================================================================"
    Write-Host ""
    Write-Host "To enable prompt files in your workspace, add to .vscode\settings.json:"
    Write-Host ""
    Write-Host '  {'
    Write-Host '    "chat.promptFiles": true'
    Write-Host '  }'
    Write-Host ""
    Write-Info "================================================================"
    Write-Host ""
}
