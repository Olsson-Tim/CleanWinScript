# Windows Setup Script

This script is designed to streamline the configuration of a Windows environment by performing system maintenance tasks, tweaking system settings, and installing essential applications.

## Features

1. **Revert Right-Click Menu to Windows 10 Style**
   - Restores the classic right-click menu layout.

2. **Enable File Extensions Visibility**
   - Ensures file extensions are visible in File Explorer.

3. **Enable Hidden Files Visibility**
   - Allows hidden files and system files to be visible in File Explorer.

4. **Remove OneDrive**
   - Completely removes OneDrive, its leftovers, and restores default folder locations.

5. **Disable Windows Copilot**
   - Removes Windows Copilot from the system.

6. **Enable Dark Theme**
   - Switches the system to dark mode.

7. **Disable Bing Search**
   - Disables Bing search integration in the Windows search bar.

8. **Disable Taskbar Search Button**
   - Removes the search button from the taskbar.

9. **Disable Taskbar Widget**
   - Removes the widget button from the taskbar.

10. **Disable Telemetry**
    - Limits Windows telemetry and diagnostics data collection.

11. **System Maintenance Commands**
    - Runs critical maintenance commands like `sfc /scannow` and `DISM` commands to ensure system integrity.

12. **Install Essential Applications**
    - Automatically installs a predefined list of programs using `winget`:
      - DB Browser for SQLite
      - Mozilla Firefox
      - Notepad++
      - TeraCopy
      - Python 3.13
      - 7-Zip

13. **Restart Explorer**
    - Restarts the `explorer.exe` process to apply changes immediately.

## Prerequisites

- Windows PowerShell must be run as an administrator.
- Winget (Windows Package Manager) should be installed and configured.

## Usage

1. Clone or download the script.
2. Open PowerShell as Administrator.
3. Run the script:
   ```powershell
   .\setup-script.ps1
   ```

## Functions

### `Invoke-SystemCommand`
Runs a system command with descriptive logging. Stops execution if the command fails.

### `Invoke-Revert-RightClickMenu`
Reverts the context menu to the Windows 10 style.

### `Invoke-ShowFileExtensions`
Enables visibility of file extensions in File Explorer.

### `Invoke-ShowHiddenFiles`
Enables visibility of hidden files and system files in File Explorer.

### `Invoke-RemoveOneDrive`
Completely removes OneDrive and its associated data.

### `Invoke-DisableWindowsCopilot`
Disables Windows Copilot.

### `Invoke-EnableDarkTheme`
Enables the system-wide dark theme.

### `Invoke-BingSearch`
Disables Bing search integration in the Windows search bar.

### `Invoke-TaskbarSearchBTN`
Disables the taskbar search button.

### `Invoke-TaskbarWidget`
Removes the widget button from the taskbar.

### `Invoke-DisableTelemetry`
Limits telemetry and diagnostics data collection.

## Additional Notes

- The script provides logging for each task, indicating success or failure.
- OneDrive removal includes steps to copy files from the OneDrive directory to the user's profile directory, ensuring no data is lost.
- After the script completes, restart your system for all changes to take full effect.

Enjoy a cleaner, more efficient Windows setup!

