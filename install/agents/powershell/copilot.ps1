# GitHub Copilot installer module (PowerShell)
# Note: common.ps1 is sourced by install.ps1, not here

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
                # For Copilot, create individual symlinks with .prompt.md extension
                # Source is _shared/commands with .md files
                # Target needs .prompt.md extension for Copilot
                if (-not $script:DryRun) {
                    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
                }

                # Find all .md files in source (follows symlinks to _shared/commands)
                if (-not $script:DryRun) {
                    Get-ChildItem -Path $promptsSource -Filter "*.md" -Recurse -File | ForEach-Object {
                        $sourceFile = $_.FullName
                        $relativePath = $sourceFile.Substring($promptsSource.Length + 1)

                        # For top-level .md files, rename to .prompt.md
                        # For subdirectory files (like commit\best-practices.md), keep as .md
                        if ($relativePath -notmatch '\\') {
                            # Top-level file: commit.md → commit.prompt.md
                            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($relativePath)
                            $targetFile = Join-Path $TargetDir "$baseName.prompt.md"
                        } else {
                            # Subdirectory file: commit\best-practices.md → commit\best-practices.md
                            $targetFile = Join-Path $TargetDir $relativePath
                        }

                        # Create subdirectories if needed
                        $targetSubdir = Split-Path -Parent $targetFile
                        if (-not (Test-Path $targetSubdir)) {
                            New-Item -ItemType Directory -Path $targetSubdir -Force | Out-Null
                        }

                        # Create symlink
                        New-Item -ItemType SymbolicLink -Path $targetFile -Target $sourceFile -Force | Out-Null
                        Write-Debug "Created symlink: $(Split-Path -Leaf $targetFile) → $sourceFile"
                    }
                    Write-Info "Created individual symlinks with .prompt.md extension"
                } else {
                    Write-DryRun "Would create individual symlinks with .prompt.md extension in: $TargetDir"
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
