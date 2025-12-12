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

    # Source is agents/_shared/commands/ (not copilot/prompts/)
    # SourceDir = agents\copilot → parent = agents → agents\_shared\commands
    $sourceParent = Split-Path -Parent $SourceDir
    $sharedCommandsDir = Join-Path $sourceParent "_shared\commands"

    if (Test-Path $sharedCommandsDir) {
        switch ($Method) {
            "symlink" {
                # For Copilot, create individual symlinks with .prompt.md extension
                # Source is _shared/commands with .md files
                # Target needs .prompt.md extension for Copilot
                if (-not $script:DryRun) {
                    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
                }

                # Find all .md files in _shared/commands
                if (-not $script:DryRun) {
                    Get-ChildItem -Path $sharedCommandsDir -Filter "*.md" -Recurse -File | ForEach-Object {
                        $sourceFile = $_.FullName
                        $relativePath = $sourceFile.Substring($sharedCommandsDir.Length + 1)

                        # Count backslashes to determine depth
                        # develop\commit.md = 1 backslash = top-level → commit.prompt.md
                        # develop\commit\best-practices.md = 2 backslashes → commit\best-practices.md
                        $slashCount = ($relativePath.ToCharArray() | Where-Object { $_ -eq '\' }).Count

                        if ($slashCount -eq 1) {
                            # Top-level command: develop\commit.md → commit.prompt.md
                            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($relativePath)
                            $targetFile = Join-Path $TargetDir "$baseName.prompt.md"
                        } else {
                            # Subdirectory: develop\commit\best-practices.md → commit\best-practices.md
                            # Remove category prefix (develop\, project\, skills\)
                            $parts = $relativePath -split '\\'
                            $restOfPath = $parts[1..($parts.Length - 1)] -join '\'
                            $targetFile = Join-Path $TargetDir $restOfPath
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
                # For copy, create target directory first and copy with renaming
                if (-not $script:DryRun) {
                    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null

                    # Copy individual files with .prompt.md extension
                    Get-ChildItem -Path $sharedCommandsDir -Filter "*.md" -Recurse -File | ForEach-Object {
                        $sourceFile = $_.FullName
                        $relativePath = $sourceFile.Substring($sharedCommandsDir.Length + 1)

                        # Count backslashes to determine depth
                        $slashCount = ($relativePath.ToCharArray() | Where-Object { $_ -eq '\' }).Count

                        if ($slashCount -eq 1) {
                            # Top-level command
                            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($relativePath)
                            $targetFile = Join-Path $TargetDir "$baseName.prompt.md"
                        } else {
                            # Subdirectory: remove category prefix
                            $parts = $relativePath -split '\\'
                            $restOfPath = $parts[1..($parts.Length - 1)] -join '\'
                            $targetFile = Join-Path $TargetDir $restOfPath
                        }

                        # Create subdirectories if needed
                        $targetSubdir = Split-Path -Parent $targetFile
                        if (-not (Test-Path $targetSubdir)) {
                            New-Item -ItemType Directory -Path $targetSubdir -Force | Out-Null
                        }

                        # Copy file
                        Copy-Item -Path $sourceFile -Destination $targetFile -Force
                        Write-Debug "Copied: $(Split-Path -Leaf $targetFile)"
                    }
                    Write-Info "Copied files with .prompt.md extension"
                } else {
                    Write-DryRun "Would copy files from $sharedCommandsDir to $TargetDir"
                }
            }
            default {
                Write-ErrorMessage "Invalid installation method: $Method"
                return $false
            }
        }
    }

    # Install references (support documentation for commands)
    $sharedDir = Join-Path $sourceParent "_shared"
    $referencesSource = Join-Path $sharedDir "references"
    $referencesTarget = Join-Path (Split-Path -Parent $TargetDir) "references"

    if (Test-Path $referencesSource) {
        if ($Method -eq "symlink") {
            if (-not $script:DryRun) {
                New-Item -ItemType Directory -Path (Split-Path -Parent $referencesTarget) -Force | Out-Null
            }
            New-SymbolicLinkSafe -Source $referencesSource -Target $referencesTarget | Out-Null
        } else {
            if (-not $script:DryRun) {
                New-Item -ItemType Directory -Path (Split-Path -Parent $referencesTarget) -Force | Out-Null
            }
            Copy-FilesSafe -Source $referencesSource -Target $referencesTarget | Out-Null
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
