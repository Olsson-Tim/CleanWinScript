# Windows Configuration Script

This PowerShell script is designed to streamline the configuration of a Windows system by performing the following tasks:

1. Running system maintenance commands.
2. Reverting the right-click context menu to the Windows 10 style.
3. Enabling the visibility of file extensions and hidden files in File Explorer.
4. Removing OneDrive.
5. Disabling Windows Copilot.
6. Enabling the dark theme.
7. Installing essential applications using Winget.
8. Restarting `explorer.exe` to apply changes.

## Features

### System Maintenance Commands
- **System File Checker (SFC)**: Scans for and repairs corrupted system files.
- **DISM ScanHealth**: Checks the health of the Windows image.
- **DISM RestoreHealth**: Repairs the Windows image if any issues are detected.

### Context Menu Customization
- Reverts the modern Windows 11 right-click menu to the classic Windows 10 style.

### File Explorer Customization
- Enables the visibility of file extensions.
- Shows hidden and super-hidden files.

### Additional Tweaks
- **Remove OneDrive**: Uninstalls OneDrive from the system.
- **Disable Windows Copilot**: Disables Windows Copilot through a registry change.
- **Enable Dark Theme**: Sets the system and app theme to dark mode.

### Application Installation
Installs the following programs using Winget:
- [DB Browser for SQLite](https://sqlitebrowser.org/) (`DBBrowserForSQLite.DBBrowserForSQLite`)
- [Mozilla Firefox](https://www.mozilla.org/firefox/) (`Mozilla.Firefox`)
- [Notepad++](https://notepad-plus-plus.org/) (`Notepad++.Notepad++`)
- [TeraCopy](https://www.codesector.com/teracopy) (`CodeSector.TeraCopy`)
- [Python 3.13](https://www.python.org/) (`Python.Python.3.13`)
- [7-Zip](https://www.7-zip.org/) (`7zip.7zip`)

### Explorer Restart
- Restarts `explorer.exe` to apply all system changes immediately.

## Usage

### Prerequisites
- Ensure you have administrative privileges to run the script.
- [Winget](https://learn.microsoft.com/en-us/windows/package-manager/) must be installed and configured on your system.

### Running the Script
1. Clone this repository or download the script file.
2. Open PowerShell **as Administrator**.
3. Navigate to the directory containing the script:
   ```powershell
   cd <path-to-script>
   ```
4. Execute the script:
   ```powershell
   .\SetupScript.ps1
   ```

### Notes
- Changes to the right-click menu, File Explorer settings, and theme may require restarting Windows Explorer or your system to take full effect.
- The script will check if each program is already installed before attempting installation.

## License
This project is licensed under the [MIT License](LICENSE).

## Contributing
Feel free to open issues or submit pull requests to improve the script or add additional features.

