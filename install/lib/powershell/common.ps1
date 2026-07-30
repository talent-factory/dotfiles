# Common functions for dotfiles installation (PowerShell)

# Color codes for output
$script:Colors = @{
    Red     = "Red"
    Green   = "Green"
    Yellow  = "Yellow"
    Blue    = "Cyan"
    Magenta = "Magenta"
    Cyan    = "Cyan"
}

# Logging functions
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] " -ForegroundColor Green -NoNewline
    Write-Host $Message
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[WARN] " -ForegroundColor Yellow -NoNewline
    Write-Host $Message
}

function Write-ErrorMessage {
    param([string]$Message)
    Write-Host "[ERROR] " -ForegroundColor Red -NoNewline
    Write-Host $Message
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] " -ForegroundColor Cyan -NoNewline
    Write-Host $Message
}

function Write-DryRun {
    param([string]$Message)
    Write-Host "[DRY-RUN] " -ForegroundColor Magenta -NoNewline
    Write-Host $Message
}

function Write-Debug {
    param([string]$Message)
    if ($script:DebugMode) {
        Write-Host "[DEBUG] " -ForegroundColor Cyan -NoNewline
        Write-Host $Message
    }
}

# Backup existing file or directory
function Backup-Existing {
    param(
        [string]$Path,
        [string]$BackupDir = $script:BackupDir
    )

    if (Test-Path $Path -PathType Any) {
        $item = Get-Item $Path -ErrorAction SilentlyContinue

        if ($item.LinkType -ne "SymbolicLink") {
            # Regular file or directory
            if ($script:DryRun) {
                Write-DryRun "Would backup existing $Path to $BackupDir"
            } else {
                if (-not (Test-Path $BackupDir)) {
                    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
                }

                # Create unique backup name with timestamp to avoid conflicts
                $itemName = Split-Path -Leaf $Path
                $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
                $backupPath = Join-Path $BackupDir "${itemName}_${timestamp}"

                # If backup path already exists, remove it first
                if (Test-Path $backupPath) {
                    Remove-Item -Path $backupPath -Recurse -Force | Out-Null
                }

Write-Warn "Backing up existing $Path to $backupPath"
                try {
                    # First ensure parent directory exists
                    $backupParent = Split-Path -Parent $backupPath
                    if (-not (Test-Path $backupParent)) {
                        New-Item -ItemType Directory -Path $backupParent -Force | Out-Null
                    }
                    
                    # Remove existing backup if it exists
                    if (Test-Path $backupPath) {
                        Remove-Item -Path $backupPath -Recurse -Force | Out-Null
                    }
                    
                    Move-Item -Path $Path -Destination $backupPath -Force | Out-Null
                } catch {
                    Write-Warn "Failed to move $Path. Trying copy and delete approach..."
                    try {
                        Copy-Item -Path $Path -Destination $backupPath -Recurse -Force | Out-Null
                        Start-Sleep -Milliseconds 500  # Brief pause before deletion
                        Remove-Item -Path $Path -Recurse -Force | Out-Null
                    } catch {
                        Write-Warn "Failed to backup $Path. Skipping backup and proceeding with installation."
                        Write-Warn "Error: $($_.Exception.Message)"
                    }
                }
            }
            return $true
        } else {
            # Symbolic link
            if ($script:DryRun) {
                Write-DryRun "Would remove existing symlink $Path"
            } else {
                Write-Info "Removing existing symlink $Path"
                Remove-Item -Path $Path -Force | Out-Null
            }
            return $true
        }
    }

    return $false
}

# Create symbolic link
function New-SymbolicLinkSafe {
    param(
        [string]$Source,
        [string]$Target
    )

    if (-not (Test-Path $Source)) {
        Write-ErrorMessage "Source not found: $Source"
        return $false
    }

    Backup-Existing -Path $Target | Out-Null

    if ($script:DryRun) {
        Write-DryRun "Would create symlink: $Target -> $Source"
        return $true
    }

    # Create parent directory if needed
    $parentDir = Split-Path -Parent $Target
    if ($parentDir -and -not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    try {
        # Check if we have admin rights for symlinks
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

        if (-not $isAdmin) {
            # Check if Developer Mode is enabled (allows symlinks without admin)
            $devModeEnabled = $false
            try {
                # Check both system and user registry for Developer Mode
                $regPaths = @(
                    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock",
                    "HKCU:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock"
                )

                foreach ($regPath in $regPaths) {
                    if (Test-Path $regPath) {
                        $value = Get-ItemProperty -Path $regPath -Name "AllowDevelopmentWithoutDevLicense" -ErrorAction SilentlyContinue
                        if ($value.AllowDevelopmentWithoutDevLicense -eq 1) {
                            $devModeEnabled = $true
                            break
                        }
                    }
                }
            } catch {
                # Ignore registry errors
            }

            if (-not $devModeEnabled) {
                Write-Warn "Symlinks require Administrator rights or Developer Mode"
                Write-Warn "Falling back to copy instead of symlink for: $Target"
                return Copy-FilesSafe -Source $Source -Target $Target
            }
        }

        try {
            New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force -ErrorAction Stop 2>$null | Out-Null
            Write-Info "Created symlink: $Target -> $Source"
            return $true
        } catch {
            # If symlink creation fails even with admin rights, fall back to copy
            Write-Warn "Falling back to copy instead of symlink for: $Target"
            return Copy-FilesSafe -Source $Source -Target $Target
        }
    } catch {
        Write-ErrorMessage "Failed to create symlink: $_"
        Write-Warn "Falling back to copy instead"
        return Copy-FilesSafe -Source $Source -Target $Target
    }
}

# Copy files or directories
function Copy-FilesSafe {
    param(
        [string]$Source,
        [string]$Target
    )

    if (-not (Test-Path $Source)) {
        Write-ErrorMessage "Source not found: $Source"
        return $false
    }

    Backup-Existing -Path $Target | Out-Null

    if ($script:DryRun) {
        Write-DryRun "Would copy: $Source -> $Target"
        return $true
    }

    # Create parent directory if needed
    $parentDir = Split-Path -Parent $Target
    if ($parentDir -and -not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    try {
        Copy-Item -Path $Source -Destination $Target -Recurse -Force | Out-Null
        Write-Info "Copied: $Source -> $Target"
        return $true
    } catch {
        Write-ErrorMessage "Failed to copy: $_"
        return $false
    }
}

# Check if command exists
function Test-Command {
    param([string]$Command)

    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Check if directory is empty
function Test-EmptyDirectory {
    param([string]$Path)

    if (Test-Path $Path -PathType Container) {
        $items = Get-ChildItem -Path $Path -Force
        return ($items.Count -eq 0)
    }
    return $false
}

# Print header
function Write-Header {
    param([string]$Title)

    $width = 66
    $textWidth = $width - 2

    Write-Host ""
    Write-Host "+$('=' * $width)+"
    Write-Host "|  $($Title.PadRight($textWidth))|"
    Write-Host "+$('=' * $width)+"
    Write-Host ""
}

# Print section
function Write-Section {
    param([string]$Title)

    Write-Host ""
    Write-Host "> " -ForegroundColor Cyan -NoNewline
    Write-Host $Title -ForegroundColor Cyan
    Write-Host ""
}

# Ask yes/no question
function Read-YesNo {
    param(
        [string]$Question,
        [string]$Default = "n"
    )

    $prompt = if ($Default -eq "y") { "[Y/n]" } else { "[y/N]" }

    while ($true) {
        $answer = Read-Host "$Question $prompt"

        if ([string]::IsNullOrWhiteSpace($answer)) {
            $answer = $Default
        }

        if ($answer -match '^[Yy]') {
            return $true
        } elseif ($answer -match '^[Nn]') {
            return $false
        } else {
            Write-Host "Please answer yes or no."
        }
    }
}

# Validate installation target
function Test-InstallationTarget {
    param([string]$Target)

    if ($Target -eq "home") {
        return $true
    } elseif ($Target -eq "workspace") {
        if (-not (Test-Path ".git" -PathType Container)) {
            Write-Warn "Current directory is not a git repository"
            Write-Warn "Workspace installation is recommended for project directories"
            return Read-YesNo -Question "Continue anyway?"
        }
        return $true
    } else {
        Write-ErrorMessage "Invalid installation target: $Target"
        return $false
    }
}

# Export script-level variables for use in other scripts
# Note: PowerShell doesn't export functions automatically like bash
# Functions need to be dot-sourced to be available
