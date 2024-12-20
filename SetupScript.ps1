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
        New-Item -Path "HKCU:\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Force | Out-Null
        New-Item -Path "HKCU:\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\\InprocServer32" -Force | Out-Null
        Write-Host "Right-click menu reverted successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to revert right-click menu: $_" -ForegroundColor Red
    }
}

# Function to enable showing file extensions in File Explorer
function Invoke-ShowFileExtensions {
    Write-Host "Enabling file extensions visibility in File Explorer..." -ForegroundColor Cyan
    try {
        Set-ItemProperty -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced" -Name "HideFileExt" -Value 0
        Write-Host "File extensions are now visible." -ForegroundColor Green
    } catch {
        Write-Host "Failed to enable file extensions visibility: $_" -ForegroundColor Red
    }
}

# Function to enable showing hidden files in File Explorer
function Invoke-ShowHiddenFiles {
    Write-Host "Enabling hidden files visibility in File Explorer..." -ForegroundColor Cyan
    try {
        Set-ItemProperty -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced" -Name "Hidden" -Value 1
        Set-ItemProperty -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced" -Name "ShowSuperHidden" -Value 1
        Write-Host "Hidden files are now visible." -ForegroundColor Green
    } catch {
        Write-Host "Failed to enable hidden files visibility: $_" -ForegroundColor Red
    }
}

# Function to remove OneDrive
function Invoke-RemoveOneDrive {
    Write-Host "Removing OneDrive from the system..." -ForegroundColor Cyan
    try {
        Start-Process -FilePath "C:\\Windows\\SysWOW64\\OneDriveSetup.exe" -ArgumentList "/uninstall" -NoNewWindow -Wait
        Write-Host "OneDrive has been successfully removed." -ForegroundColor Green
    } catch {
        Write-Host "Failed to remove OneDrive: $_" -ForegroundColor Red
    }
}

# Function to disable Windows Copilot
function Invoke-DisableWindowsCopilot {
    Write-Host "Disabling Windows Copilot..." -ForegroundColor Cyan
    try {
        Set-ItemProperty -Path "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows" -Name "CopilotEnabled" -Value 0 -Force
        Write-Host "Windows Copilot has been disabled." -ForegroundColor Green
    } catch {
        Write-Host "Failed to disable Windows Copilot: $_" -ForegroundColor Red
    }
}

# Function to enable dark theme
function Invoke-EnableDarkTheme {
    Write-Host "Enabling dark theme..." -ForegroundColor Cyan
    try {
        Set-ItemProperty -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize" -Name "AppsUseLightTheme" -Value 0
        Set-ItemProperty -Path "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize" -Name "SystemUsesLightTheme" -Value 0
        Write-Host "Dark theme has been enabled." -ForegroundColor Green
    } catch {
        Write-Host "Failed to enable dark theme: $_" -ForegroundColor Red
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

# Remove OneDrive
Invoke-RemoveOneDrive

# Disable Windows Copilot
Invoke-DisableWindowsCopilot

# Enable dark theme
Invoke-EnableDarkTheme

# Define the list of programs to install
$programs = @(
    "DBBrowserForSQLite.DBBrowserForSQLite", # DB Browser for SQLite
    "Mozilla.Firefox",                       # Mozilla Firefox
    "Notepad++.Notepad++",                   # Notepad++
    "CodeSector.TeraCopy",                   # TeraCopy
    "Python.Python.3.13",                    # Python 3.13        
    "7zip.7zip"                              # 7-Zip
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

# Restart explorer.exe
Write-Host "Restarting explorer.exe to apply changes..." -ForegroundColor Cyan
Stop-Process -Name explorer -Force
Start-Process explorer

Write-Host "Script completed!" -ForegroundColor Green
