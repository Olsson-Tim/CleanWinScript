# Windows System Optimization Script

## Overview
This script optimizes and customizes your Windows system by automating tasks such as enabling/disabling features, removing unnecessary software, and running essential system maintenance commands. It's an efficient, all-in-one solution to enhance productivity and streamline system performance.

## Features

### Customization:
- Revert the right-click menu to Windows 10 style for better usability.
- Enable visibility of file extensions and hidden files in File Explorer.
- Activate a dark theme across Windows.

### Optimization:
- Completely remove OneDrive, including leftover files and registry entries.
- Disable Windows Copilot.
- Turn off Bing Search in the Start Menu.
- Remove the Taskbar Search Button and Widgets.
- Enable the Taskbar's End Task option for quick program termination.
- Reduce system overhead by disabling unnecessary telemetry.

### Maintenance:
Perform vital maintenance tasks using built-in Windows tools:
- **sfc /scannow**: System File Checker to repair corrupted system files.
- **DISM ScanHealth** and **DISM RestoreHealth**: Check and restore Windows image health.

### Software Installation:
Install essential software automatically using **winget** (Windows Package Manager):
- DB Browser for SQLite
- Mozilla Firefox
- Notepad++
- TeraCopy
- Python 3.13
- 7-Zip

## Usage

### Prerequisites:
- Ensure you have administrative privileges to execute the script.
- Confirm that the **winget** package manager is installed and up-to-date.

### Running the Script:
1. Open PowerShell as an Administrator.
2. Execute the script.

### What Happens:
- The script customizes your system by making registry changes.
- OneDrive is uninstalled (with optional manual removal of leftover files).
- Essential software is installed automatically.
- System maintenance tasks are run.
- Explorer is restarted to apply changes.

## Safety Notes
- **Backup Important Files:** Before running the script, back up critical data.
- **Transparency:** Actions are logged using `Write-Host`, keeping you informed in real time.
- **Review the Script:** Review the script before running it to ensure it meets your needs.

## Troubleshooting
- If the script encounters an issue, detailed error messages will help identify the problem.
- Verify dependencies, such as having `winget` installed and a stable internet connection.

## License
This project is licensed under the MIT License. You are free to modify and distribute it as needed.

## Contributions
Contributions are welcome! Feel free to submit a pull request or open an issue if you have suggestions for improvements or additional features.

### Example Output
```powershell
Starting: System File Checker (SFC) scan...
System File Checker (SFC) scan completed successfully!

Installing Mozilla.Firefox...
Mozilla.Firefox is already installed.

Restarting explorer.exe to apply changes...
Script completed!
```

---

**Streamline your Windows experience with this powerful optimization script!**
