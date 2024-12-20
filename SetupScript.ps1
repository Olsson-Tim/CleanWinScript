# Function to run a system maintenance command
function Invoke-SystemCommand {
    param (
        [string]$Command,
        [string]$Description
    )

    Write-Host "Starting: $Description..." -ForegroundColor Cyan
    Invoke-Expression $Command
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$Description completed successfully!" -ForegroundColor Green
    } else {
        Write-Host "An error occurred during: $Description. Please check the logs." -ForegroundColor Red
        exit 1
    }
}

# Function to revert right-click menu to Windows 10 style
function Invoke-Revert-RightClickMenu {
    Write-Host "Reverting right-click menu to Windows 10 style..." -ForegroundColor Cyan
    try {
        New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Force | Out-Null
        New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Force | Out-Null
        Write-Host "Right-click menu reverted successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to revert right-click menu: $_" -ForegroundColor Red
    }
}

# Function to enable showing file extensions in File Explorer
function Invoke-ShowFileExtensions {
    Write-Host "Enabling file extensions visibility in File Explorer..." -ForegroundColor Cyan
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
        Write-Host "File extensions are now visible." -ForegroundColor Green
    } catch {
        Write-Host "Failed to enable file extensions visibility: $_" -ForegroundColor Red
    }
}

# Function to enable showing hidden files in File Explorer
function Invoke-ShowHiddenFiles {
    Write-Host "Enabling hidden files visibility in File Explorer..." -ForegroundColor Cyan
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Value 1
        Write-Host "Hidden files are now visible." -ForegroundColor Green
    } catch {
        Write-Host "Failed to enable hidden files visibility: $_" -ForegroundColor Red
    }
}

# Run system maintenance commands
Invoke-SystemCommand "sfc /scannow" "System File Checker (SFC) scan"
Invoke-SystemCommand "DISM /Online /Cleanup-Image /ScanHealth" "DISM ScanHealth"
Invoke-SystemCommand "DISM /Online /Cleanup-Image /RestoreHealth" "DISM RestoreHealth"

# Revert right-click menu to Windows 10 style
Invoke-Revert-RightClickMenu

# Enable file extensions and hidden files visibility
Invoke-ShowFileExtensions
Invoke-ShowHiddenFiles

# Define the list of programs to install
$programs = @(
    "DBBrowserForSQLite.DBBrowserForSQLite", # DB Browser for SQLite
    "Mozilla.Firefox",                       # Mozilla Firefox
    "Notepad++.Notepad++",                   # Notepad++
    "CodeSector.TeraCopy",                   # TeraCopy
    "Python.Python.3.13",                   # Python 3.13        
    "7zip.7zip"        
)

# Function to check and install programs
foreach ($program in $programs) {
    Write-Host "Checking installation for $program..." -ForegroundColor Cyan

    # Check if the program is already installed
    $installed = winget list --id $program 2>&1 | Out-String
    if ($installed -match "No installed package found matching input criteria.") {
        Write-Host "Installing $program..." -ForegroundColor Green
        winget install --id $program --accept-source-agreements --accept-package-agreements
    } else {
        Write-Host "$program is already installed." -ForegroundColor Yellow
    }
}

Write-Host "Script completed!" -ForegroundColor Green
