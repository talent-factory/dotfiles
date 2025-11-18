# GitHub Copilot installer module (PowerShell)

. "$PSScriptRoot\..\..\lib\powershell\common.ps1"

function Install-GitHubCopilot {
    param([string]$Mode, [string]$Method)

    Write-Info "Installing GitHub Copilot..."
    $sourceDir = Join-Path $script:DotfilesDir "agents\copilot"

    if (-not (Test-Path $sourceDir)) {
        Write-ErrorMessage "Copilot source directory not found: $sourceDir"
        return $false
    }

    if ($Mode -eq "home" -or $Mode -eq "both") {
        $homeDir = Join-Path $env:APPDATA "Code\User\prompts"
        Install-CopilotToTarget -TargetDir $homeDir -SourceDir $sourceDir -Method $Method
    }

    if ($Mode -eq "workspace" -or $Mode -eq "both") {
        Install-CopilotToTarget -TargetDir ".\.github\prompts" -SourceDir $sourceDir -Method $Method
        Show-CopilotActivationInstructions
    }

    Write-Success "GitHub Copilot installation completed"
    return $true
}

function Install-CopilotToTarget {
    param([string]$TargetDir, [string]$SourceDir, [string]$Method)

    Backup-Existing -Path $TargetDir

    if (-not $script:DryRun) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }

    $promptsSource = Join-Path $SourceDir "prompts"

    if (Test-Path $promptsSource) {
        if ($Method -eq "symlink") {
            New-SymbolicLinkSafe -Source $promptsSource -Target $TargetDir
        } else {
            if (-not $script:DryRun) {
                Get-ChildItem -Path $promptsSource -Filter "*.prompt.md" | ForEach-Object {
                    Copy-Item -Path $_.FullName -Destination $TargetDir -Force
                    Write-Info "Copied: $($_.Name)"
                }
            } else {
                Write-DryRun "Would copy prompt files from $promptsSource to $TargetDir"
            }
        }
    }

    return $true
}

function Show-CopilotActivationInstructions {
    if ($script:DryRun) { return }

    Write-Host ""
    Write-Info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Info "  GitHub Copilot Activation Required"
    Write-Info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host ""
    Write-Host "To enable prompt files in your workspace, add to .vscode\settings.json:"
    Write-Host ""
    Write-Host '  {'
    Write-Host '    "chat.promptFiles": true'
    Write-Host '  }'
    Write-Host ""
    Write-Info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    Write-Host ""
}
