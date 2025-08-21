<#
.SYNOPSIS
    Windows System Optimization Script
.DESCRIPTION
    This script optimizes and customizes your Windows system by automating tasks such as 
    enabling/disabling features, removing unnecessary software, and running essential 
    system maintenance commands.
.PARAMETER ConfigPath
    Path to the configuration JSON file
.PARAMETER DryRun
    Shows what would be changed without actually making changes
.PARAMETER LogPath
    Path to the log file
.EXAMPLE
    .\SetupScript.ps1
    Runs the script with default settings
.EXAMPLE
    .\SetupScript.ps1 -ConfigPath ".\custom-config.json" -DryRun
    Runs the script with a custom configuration in dry-run mode
#>

param(
    [string]$ConfigPath = "$PSScriptRoot\config.json",
    [switch]$DryRun,
    [string]$LogPath = "$env:TEMP\windows-optimization.log"
)

# Initialize logging
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    Add-Content -Path $LogPath -Value $logEntry
    
    switch ($Level) {
        "INFO" { Write-Host $Message -ForegroundColor Cyan }
        "SUCCESS" { Write-Host $Message -ForegroundColor Green }
        "WARNING" { Write-Host $Message -ForegroundColor Yellow }
        "ERROR" { Write-Host $Message -ForegroundColor Red }
    }
}

# Function to run a system maintenance command
function Invoke-SystemCommand {
    param (
        [string]$Command,
        [string]$Description
    )

    Write-Log "Starting: $Description..."
    
    if ($DryRun) {
        Write-Log "[DRY RUN] Would execute: $Command" "WARNING"
        return
    }
    
    try {
        Invoke-Expression $Command
        if ($LASTEXITCODE -eq 0) {
            Write-Log "$Description completed successfully!" "SUCCESS"
        } else {
            Write-Log "An error occurred during: $Description. Exit code: $LASTEXITCODE" "ERROR"
        }
    } catch {
        Write-Log "Failed to execute $Description : $_" "ERROR"
    }
}

# Function to set registry values with error handling
function Set-RegistryValue {
    param(
        [string]$Path,
        [string]$Name,
        [object]$Value,
        [string]$Type = "DWord"
    )
    
    if ($DryRun) {
        Write-Log "[DRY RUN] Would set registry value: Path=$Path, Name=$Name, Value=$Value" "WARNING"
        return
    }
    
    try {
        # Ensure the registry key exists
        $key = $Path.Split('\')[-1]
        $parentPath = $Path.Substring(0, $Path.LastIndexOf('\'))
        
        if (!(Test-Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }
        
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type
        Write-Log "Set registry value: $Name = $Value" "SUCCESS"
    } catch {
        Write-Log "Failed to set registry value $Name : $_" "ERROR"
    }
}

# Function to revert right-click menu to Windows 10 style
function Invoke-RevertRightClickMenu {
    Write-Log "Reverting right-click menu to Windows 10 style..."
    
    if ($DryRun) {
        Write-Log "[DRY RUN] Would revert right-click menu" "WARNING"
        return
    }
    
    try {
        New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Name "InprocServer32" -force -value "" | Out-Null
        Write-Log "Right-click menu reverted successfully." "SUCCESS"
    } catch {
        Write-Log "Failed to revert right-click menu: $_" "ERROR"
    }
}

# Function to enable showing file extensions in File Explorer
function Invoke-ShowFileExtensions {
    Write-Log "Enabling file extensions visibility in File Explorer..."
    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
}

# Function to enable showing hidden files in File Explorer
function Invoke-ShowHiddenFiles {
    Write-Log "Enabling hidden files visibility in File Explorer..."
    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1
    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Value 1
}

# Function to remove OneDrive
function Invoke-RemoveOneDrive {
    if ($DryRun) {
        Write-Log "[DRY RUN] Would remove OneDrive" "WARNING"
        return
    }
    
    $OneDrivePath = $($env:OneDrive)
    Write-Log "Removing OneDrive"
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe"
    
    if (Test-Path $regPath) {
        try {
            $OneDriveUninstallString = Get-ItemPropertyValue "$regPath" -Name "UninstallString"
            $OneDriveExe, $OneDriveArgs = $OneDriveUninstallString.Split(" ")
            Start-Process -FilePath $OneDriveExe -ArgumentList "$OneDriveArgs /silent" -NoNewWindow -Wait
            
            # Check if OneDrive got Uninstalled
            if (-not (Test-Path $regPath)) {
                Write-Log "Copy downloaded Files from the OneDrive Folder to Root UserProfile"
                Start-Process -FilePath powershell -ArgumentList "robocopy '$($OneDrivePath)' '$($env:USERPROFILE.TrimEnd())\' /mov /e /xj" -NoNewWindow -Wait

                Write-Log "Removing OneDrive leftovers"
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\OneDrive"
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\OneDrive"
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:programdata\Microsoft OneDrive"
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:systemdrive\OneDriveTemp"
                reg delete "HKEY_CURRENT_USER\Software\Microsoft\OneDrive" -f 2>&1 | Out-Null
                
                # check if directory is empty before removing:
                If ((Get-ChildItem "$OneDrivePath" -Recurse | Measure-Object).Count -eq 0) {
                    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$OneDrivePath"
                }

                Write-Log "Remove Onedrive from explorer sidebar"
                Set-ItemProperty -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Name "System.IsPinnedToNameSpaceTree" -Value 0 -ErrorAction SilentlyContinue
                Set-ItemProperty -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Name "System.IsPinnedToNameSpaceTree" -Value 0 -ErrorAction SilentlyContinue

                Write-Log "Removing run hook for new users"
                reg load "hku\Default" "C:\Users\Default\NTUSER.DAT" 2>&1 | Out-Null
                reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f 2>&1 | Out-Null
                reg unload "hku\Default" 2>&1 | Out-Null

                Write-Log "Removing startmenu entry"
                Remove-Item -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

                Write-Log "Removing scheduled task"
                Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ea SilentlyContinue | Unregister-ScheduledTask -Confirm:$false

                # Add Shell folders restoring default locations
                Write-Log "Shell Fixing"
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "AppData" -Value "$env:userprofile\AppData\Roaming" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Cache" -Value "$env:userprofile\AppData\Local\Microsoft\Windows\INetCache" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Cookies" -Value "$env:userprofile\AppData\Local\Microsoft\Windows\INetCookies" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Favorites" -Value "$env:userprofile\Favorites" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "History" -Value "$env:userprofile\AppData\Local\Microsoft\Windows\History" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Local AppData" -Value "$env:userprofile\AppData\Local" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Music" -Value "$env:userprofile\Music" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Video" -Value "$env:userprofile\Videos" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "NetHood" -Value "$env:userprofile\AppData\Roaming\Microsoft\Windows\Network Shortcuts" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "PrintHood" -Value "$env:userprofile\AppData\Roaming\Microsoft\Windows\Printer Shortcuts" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Programs" -Value "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Recent" -Value "$env:userprofile\AppData\Roaming\Microsoft\Windows\Recent" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "SendTo" -Value "$env:userprofile\AppData\Roaming\Microsoft\Windows\SendTo" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Start Menu" -Value "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Startup" -Value "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Templates" -Value "$env:userprofile\AppData\Roaming\Microsoft\Windows\Templates" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}" -Value "$env:userprofile\Downloads" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Desktop" -Value "$env:userprofile\Desktop" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Pictures" -Value "$env:userprofile\Pictures" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "Personal" -Value "$env:userprofile\Documents" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{F42EE2D3-909F-4907-8871-4C22FC0BF756}" -Value "$env:userprofile\Documents" -Type ExpandString
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{0DDD015D-B06C-45D5-8C4C-F59713854639}" -Value "$env:userprofile\Pictures" -Type ExpandString
                
                Write-Log "Restarting explorer"
                taskkill.exe /F /IM "explorer.exe" 2>&1 | Out-Null
                Start-Process "explorer.exe"

                Write-Log "Waiting for explorer to complete loading"
                Write-Log "Please Note - The OneDrive folder at $OneDrivePath may still have items in it. You must manually delete it, but all the files should already be copied to the base user folder."
                Write-Log "If there are Files missing afterwards, please Login to Onedrive.com and Download them manually" "WARNING"
                Start-Sleep 5
            } else {
                Write-Log "Something went Wrong during the Uninstallation of OneDrive" "ERROR"
            }
        } catch {
            Write-Log "Failed to remove OneDrive: $_" "ERROR"
        }
    } else {
        Write-Log "OneDrive doesn't seem to be installed anymore" "WARNING"
    }
}

# Function to disable Windows Copilot
function Invoke-DisableWindowsCopilot {
    Write-Log "Disabling Windows Copilot..."
    
    if ($DryRun) {
        Write-Log "[DRY RUN] Would disable Windows Copilot" "WARNING"
        return
    }
    
    try {
        dism /online /remove-package /package-name:Microsoft.Windows.Copilot 2>&1 | Out-Null
        Write-Log "Windows Copilot has been disabled." "SUCCESS"
    } catch {
        Write-Log "Failed to disable Windows Copilot: $_" "ERROR"
    }
}

# Function to enable dark theme
function Invoke-EnableDarkTheme {
    Write-Log "Enabling dark theme..."
    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
}

function Invoke-DisableBingSearch {
    Write-Log "Disabling Bing Search..."
    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0
}

function Invoke-DisableTaskbarSearchBTN {
    Write-Log "Disabling Taskbar Search Button..."
    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0
}

function Invoke-DisableTaskbarWidget {
    Write-Log "Disabling Taskbar Widget..."
    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarData" -Value 0
}

function Invoke-DisableTelemetry {
    Write-Log "Disabling telemetry..."
    
    if ($DryRun) {
        Write-Log "[DRY RUN] Would disable telemetry" "WARNING"
        return
    }
    
    try {
        bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
        If ((get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name CurrentBuild).CurrentBuild -lt 22557) {
            $taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
            Do {
                Start-Sleep -Milliseconds 100
                $preferences = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -ErrorAction SilentlyContinue
            } Until ($preferences)
            Stop-Process $taskmgr
            $preferences.Preferences[28] = 0
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager" -Name "Preferences" -Type Binary -Value $preferences.Preferences
        }
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recurse -ErrorAction SilentlyContinue

        # Fix Managed by your organization in Edge if registry path exists then remove it
        If (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge") {
            Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Recurse -ErrorAction SilentlyContinue
        }

        # Group svchost.exe processes
        $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $ram -Force

        $autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
        If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
            Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
        }
        icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null

        # Disable Defender Auto Sample Submission
        Set-MpPreference -SubmitSamplesConsent 2 -ErrorAction SilentlyContinue | Out-Null
        Write-Log "Telemetry has been disabled." "SUCCESS"
    } catch {
        Write-Log "Failed to disable telemetry: $_" "ERROR"
    }
}

function Invoke-EnableTaskbarEndTask {
    Write-Log "Enabling Taskbar End Task..."
    Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" -Name "TaskbarEndTask" -Value 1
}

function Invoke-SqliteToPath {
    Write-Log "Downloading and installing SQLite tools..."
    
    if ($DryRun) {
        Write-Log "[DRY RUN] Would download and install SQLite tools" "WARNING"
        return
    }
    
    try {
        #Download the SQLite tools to the specified path
        $sourceUrl = "https://www.sqlite.org/2024/sqlite-tools-win-x64-3470200.zip"
        $destinationPath = "C:\sqlite\sqlite-tmp.zip"
        $folderToAdd = "C:\sqlite"
        
        # Create directory if it doesn't exist
        if (!(Test-Path "C:\sqlite")) {
            New-Item -Path "C:\sqlite" -ItemType Directory -Force | Out-Null
        }
        
        Invoke-WebRequest -Uri $sourceUrl -OutFile $destinationPath
        Expand-Archive -Path $destinationPath -DestinationPath "C:\sqlite" -Force
        Remove-Item -Path $destinationPath -Force
        
        Write-Log "SQLite tools downloaded and extracted to $folderToAdd" "SUCCESS"
        
        # Add to PATH if not already there
        $currentPathUser = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($currentPathUser -notlike "*$folderToAdd*") {
            [Environment]::SetEnvironmentVariable("Path", "$currentPathUser;$folderToAdd", "User")
            Write-Log "Added SQLite to user PATH" "SUCCESS"
        } else {
            Write-Log "SQLite already in PATH" "WARNING"
        }
    } catch {
        Write-Log "Failed to download or install SQLite: $_" "ERROR"
    }
}

# Function to install applications via winget
function Invoke-InstallApplications {
    param(
        [array]$Programs
    )
    
    Write-Log "Installing applications..."
    
    if ($DryRun) {
        Write-Log "[DRY RUN] Would install applications: $($Programs -join ', ')" "WARNING"
        return
    }
    
    foreach ($program in $Programs) {
        Write-Log "Checking installation for $program..."
        
        try {
            # Check if the program is already installed
            $installed = winget list --id $program 2>&1 | Out-String
            if ($installed -match "No installed package found matching input criteria.") {
                Write-Log "Installing $program..."
                winget install --id $program --accept-source-agreements --accept-package-agreements
                Write-Log "$program installed successfully" "SUCCESS"
            } else {
                Write-Log "$program is already installed." "WARNING"
            }
        } catch {
            Write-Log "Failed to install $program: $_" "ERROR"
        }
    }
}

# Function to restart explorer
function Restart-Explorer {
    Write-Log "Restarting explorer.exe to apply changes..."
    
    if ($DryRun) {
        Write-Log "[DRY RUN] Would restart explorer.exe" "WARNING"
        return
    }
    
    try {
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
        Start-Process explorer
        Write-Log "Explorer restarted successfully" "SUCCESS"
    } catch {
        Write-Log "Failed to restart explorer: $_" "ERROR"
    }
}

# Function to show progress
function Show-Progress {
    param(
        [int]$Current,
        [int]$Total,
        [string]$Activity
    )
    
    $percent = [math]::Round(($Current / $Total) * 100)
    Write-Progress -Activity $Activity -PercentComplete $percent -Status "$Current of $Total completed"
}

# Main execution
try {
    Write-Log "Starting Windows Optimization Script" "INFO"
    Write-Log "Log file: $LogPath" "INFO"
    Write-Log "Dry Run Mode: $($DryRun.IsPresent)" "INFO"
    
    # Load configuration
    if (Test-Path $ConfigPath) {
        $config = Get-Content -Path $ConfigPath | ConvertFrom-Json
        Write-Log "Configuration loaded from $ConfigPath" "SUCCESS"
    } else {
        Write-Log "Configuration file not found at $ConfigPath. Using defaults." "WARNING"
        $config = @{
            SystemSettings = @{
                RevertRightClickMenu = $true
                ShowFileExtensions = $true
                ShowHiddenFiles = $true
                EnableDarkTheme = $true
                EnableTaskbarEndTask = $true
            }
            PrivacySettings = @{
                DisableBingSearch = $true
                DisableTaskbarSearchButton = $true
                DisableTaskbarWidget = $true
                DisableWindowsCopilot = $true
                DisableTelemetry = $true
            }
            Maintenance = @{
                RunSFC = $true
                RunDISM = $true
            }
            Software = @{
                RemoveOneDrive = $true
                InstallApplications = $true
                InstallSQLite = $true
            }
            Applications = @(
                "DBBrowserForSQLite.DBBrowserForSQLite"
                "Mozilla.Firefox"
                "Notepad++.Notepad++"
                "CodeSector.TeraCopy"
                "Python.Python.3.13"
                "7zip.7zip"
            )
        }
    }
    
    # Calculate total steps for progress tracking
    $totalSteps = 0
    if ($config.SystemSettings.RevertRightClickMenu) { $totalSteps++ }
    if ($config.SystemSettings.ShowFileExtensions) { $totalSteps++ }
    if ($config.SystemSettings.ShowHiddenFiles) { $totalSteps++ }
    if ($config.Software.RemoveOneDrive) { $totalSteps++ }
    if ($config.PrivacySettings.DisableWindowsCopilot) { $totalSteps++ }
    if ($config.SystemSettings.EnableDarkTheme) { $totalSteps++ }
    if ($config.PrivacySettings.DisableBingSearch) { $totalSteps++ }
    if ($config.PrivacySettings.DisableTaskbarSearchButton) { $totalSteps++ }
    if ($config.PrivacySettings.DisableTaskbarWidget) { $totalSteps++ }
    if ($config.PrivacySettings.DisableTelemetry) { $totalSteps++ }
    if ($config.SystemSettings.EnableTaskbarEndTask) { $totalSteps++ }
    if ($config.Software.InstallSQLite) { $totalSteps++ }
    if ($config.Maintenance.RunSFC) { $totalSteps++ }
    if ($config.Maintenance.RunDISM) { $totalSteps++ }
    if ($config.Software.InstallApplications) { $totalSteps++ }
    
    $currentStep = 0
    
    # System Settings
    if ($config.SystemSettings.RevertRightClickMenu) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "System Settings"
        Invoke-RevertRightClickMenu
    }
    
    if ($config.SystemSettings.ShowFileExtensions) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "System Settings"
        Invoke-ShowFileExtensions
    }
    
    if ($config.SystemSettings.ShowHiddenFiles) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "System Settings"
        Invoke-ShowHiddenFiles
    }
    
    # Software
    if ($config.Software.RemoveOneDrive) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "Software Management"
        Invoke-RemoveOneDrive
    }
    
    # Privacy Settings
    if ($config.PrivacySettings.DisableWindowsCopilot) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "Privacy Settings"
        Invoke-DisableWindowsCopilot
    }
    
    if ($config.SystemSettings.EnableDarkTheme) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "System Settings"
        Invoke-EnableDarkTheme
    }
    
    if ($config.PrivacySettings.DisableBingSearch) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "Privacy Settings"
        Invoke-DisableBingSearch
    }
    
    if ($config.PrivacySettings.DisableTaskbarSearchButton) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "Privacy Settings"
        Invoke-DisableTaskbarSearchBTN
    }
    
    if ($config.PrivacySettings.DisableTaskbarWidget) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "Privacy Settings"
        Invoke-DisableTaskbarWidget
    }
    
    if ($config.PrivacySettings.DisableTelemetry) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "Privacy Settings"
        Invoke-DisableTelemetry
    }
    
    if ($config.SystemSettings.EnableTaskbarEndTask) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "System Settings"
        Invoke-EnableTaskbarEndTask
    }
    
    # Development Tools
    if ($config.Software.InstallSQLite) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "Development Tools"
        Invoke-SqliteToPath
    }
    
    # Maintenance Tools
    if ($config.Maintenance.RunSFC) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "System Maintenance"
        Invoke-SystemCommand "sfc /scannow" "System File Checker (SFC) scan"
    }
    
    if ($config.Maintenance.RunDISM) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "System Maintenance"
        Invoke-SystemCommand "DISM /Online /Cleanup-Image /ScanHealth" "DISM ScanHealth"
        Invoke-SystemCommand "DISM /Online /Cleanup-Image /RestoreHealth" "DISM RestoreHealth"
    }
    
    # Software Installation
    if ($config.Software.InstallApplications) {
        $currentStep++
        Show-Progress -Current $currentStep -Total $totalSteps -Activity "Software Installation"
        Invoke-InstallApplications -Programs $config.Applications
    }
    
    # Restart explorer to apply changes
    Restart-Explorer
    
    Write-Progress -Activity "Complete" -Completed
    Write-Log "Script completed successfully!" "SUCCESS"
    Write-Log "Log file saved to: $LogPath" "INFO"
    
} catch {
    Write-Log "An unexpected error occurred: $_" "ERROR"
    Write-Log "Check the log file for more details: $LogPath" "INFO"
    exit 1
}