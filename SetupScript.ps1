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
        New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Name "InprocServer32" -force -value ""
        Write-Host Restarting explorer.exe ...
        $process = Get-Process -Name "explorer"
        Stop-Process -InputObject $process
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
    $OneDrivePath = $($env:OneDrive)
    Write-Host "Removing OneDrive"
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe"
    if (Test-Path $regPath) {
        $OneDriveUninstallString = Get-ItemPropertyValue "$regPath" -Name "UninstallString"
        $OneDriveExe, $OneDriveArgs = $OneDriveUninstallString.Split(" ")
        Start-Process -FilePath $OneDriveExe -ArgumentList "$OneDriveArgs /silent" -NoNewWindow -Wait
    } else {
        Write-Host "Onedrive dosn't seem to be installed anymore" -ForegroundColor Red
        return
    }
    # Check if OneDrive got Uninstalled
    if (-not (Test-Path $regPath)) {
    Write-Host "Copy downloaded Files from the OneDrive Folder to Root UserProfile"
    Start-Process -FilePath powershell -ArgumentList "robocopy '$($OneDrivePath)' '$($env:USERPROFILE.TrimEnd())\' /mov /e /xj" -NoNewWindow -Wait

    Write-Host "Removing OneDrive leftovers"
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\OneDrive"
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\OneDrive"
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:programdata\Microsoft OneDrive"
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:systemdrive\OneDriveTemp"
    reg delete "HKEY_CURRENT_USER\Software\Microsoft\OneDrive" -f
    # check if directory is empty before removing:
    If ((Get-ChildItem "$OneDrivePath" -Recurse | Measure-Object).Count -eq 0) {
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$OneDrivePath"
    }

    Write-Host "Remove Onedrive from explorer sidebar"
    Set-ItemProperty -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Name "System.IsPinnedToNameSpaceTree" -Value 0
    Set-ItemProperty -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Name "System.IsPinnedToNameSpaceTree" -Value 0

    Write-Host "Removing run hook for new users"
    reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
    reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
    reg unload "hku\Default"

    Write-Host "Removing startmenu entry"
    Remove-Item -Force -ErrorAction SilentlyContinue "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"

    Write-Host "Removing scheduled task"
    Get-ScheduledTask -TaskPath '\' -TaskName 'OneDrive*' -ea SilentlyContinue | Unregister-ScheduledTask -Confirm:$false

    # Add Shell folders restoring default locations
    Write-Host "Shell Fixing"
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
    Write-Host "Restarting explorer"
    taskkill.exe /F /IM "explorer.exe"
    Start-Process "explorer.exe"

    Write-Host "Waiting for explorer to complete loading"
    Write-Host "Please Note - The OneDrive folder at $OneDrivePath may still have items in it. You must manually delete it, but all the files should already be copied to the base user folder."
    Write-Host "If there are Files missing afterwards, please Login to Onedrive.com and Download them manually" -ForegroundColor Yellow
    Start-Sleep 5
    } else {
    Write-Host "Something went Wrong during the Unistallation of OneDrive" -ForegroundColor Red
    }
}

# Function to disable Windows Copilot
function Invoke-DisableWindowsCopilot {
    Write-Host "Disabling Windows Copilot..." -ForegroundColor Cyan
    try {
        dism /online /remove-package /package-name:Microsoft.Windows.Copilot
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

function Invoke-BingSearch {
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name BingSearchEnabled -Value 0
        Write-Host "Bing Search has been disabled." -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to disable Bing Search: $_" -ForegroundColor Red
    }
    
}

function Invoke-TaskbarSearchBTN {
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search\" -Name SearchboxTaskbarMode -Value 0
    }
    catch {
     Write-Host "Failed to disable Taskbar button: $_" -ForegroundColor Red
    }
    
}

function Invoke-TaskbarWidget {
   try {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarData" -Value 0
   }
   catch {
    Write-Host "Failed to disable Taskbar Widget: $_" -ForegroundColor Red
   }
    
}

function Invoke-DisableTelementery {
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

    # Fix Managed by your organization in Edge if regustry path exists then remove it

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
}

# Revert right-click menu to Windows 10 style
Invoke-Revert-RightClickMenu

# Enable file extensions and hidden files visibility
Invoke-ShowFileExtensions

# Enable hidden files visibility
Invoke-ShowHiddenFiles

# Remove OneDrive
Invoke-RemoveOneDrive

# Disable Windows Copilot
Invoke-DisableWindowsCopilot

# Enable dark theme
Invoke-EnableDarkTheme

#Disable Bing Search
Invoke-BingSearch

#Disable Taskbar Search Button
Invoke-TaskbarSearchBTN

#Disable Taskbar Widget
Invoke-TaskbarWidget

#Disable Telementery
Invoke-DisableTelementery

# Run system maintenance commands
Invoke-SystemCommand "sfc /scannow" "System File Checker (SFC) scan"
Invoke-SystemCommand "DISM /Online /Cleanup-Image /ScanHealth" "DISM ScanHealth"
Invoke-SystemCommand "DISM /Online /Cleanup-Image /RestoreHealth" "DISM RestoreHealth"

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

    try {
        # Check if the program is already installed
        $installed = winget list --id $program 2>&1 | Out-String
        if ($installed -match "No installed package found matching input criteria.") {
            Write-Host "Installing $program..." -ForegroundColor Green

            # Try installing the program and handle the first-time Y prompt
            $installOutput = winget install --id $program --accept-source-agreements --accept-package-agreements 2>&1 | Out-String
            if ($installOutput -match "Do you agree to all source agreements") {
                Write-Host "Responding to first-time Y prompt..." -ForegroundColor Cyan
                "Y" | winget install --id $program --accept-source-agreements --accept-package-agreements
            }
        } else {
            Write-Host "$program is already installed." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "An error occurred while processing $program $_" -ForegroundColor Red
    }
}


# Restart explorer.exe
Write-Host "Restarting explorer.exe to apply changes..." -ForegroundColor Cyan
Stop-Process -Name explorer -Force
Start-Process explorer

Write-Host "Script completed!" -ForegroundColor Green
