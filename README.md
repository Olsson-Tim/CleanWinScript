# Windows System Optimization Script

## Overview
This script optimizes and customizes your Windows system by automating tasks such as enabling/disabling features, removing unnecessary software, and running essential system maintenance commands. It's an efficient, all-in-one solution to enhance productivity and streamline system performance.

This script is made to work best with a Microwin image created with the [Chris Titus Tech's WinUtil project](https://christitustech.github.io/winutil/userguide/#microwin) but it should work with a normal Windows 11 install.

## Features

### System Optimization and Configuration
- **Revert Right-Click Menu**: Restores the classic Windows 10-style right-click menu.
- **Show File Extensions**: Enables the visibility of file extensions in File Explorer.
- **Show Hidden Files**: Makes hidden files visible in File Explorer.
- **Disable Bing Search**: Removes Bing integration from the Windows search feature.
- **Disable Taskbar Search Button**: Disables the search button on the taskbar.
- **Disable Taskbar Widget**: Removes the taskbar widget.
- **Enable Taskbar End Task**: Adds the "End Task" option to the taskbar context menu.
- **Enable Dark Theme**: Activates the dark theme for apps and the system.

### Maintenance Tools
- **System File Checker (SFC) Scan**: Verifies the integrity of system files and repairs them if necessary.
- **DISM Scan and Repair**: Scans and repairs the Windows image using Deployment Image Servicing and Management (DISM) tools.

### Privacy and Cleanup
- **Disable Windows Telemetry**: Reduces data collection by disabling telemetry services.
- **Remove OneDrive**: Uninstalls OneDrive, removes its residual files, and restores default folder locations.
- **Disable Windows Copilot**: Removes the Windows Copilot feature for a cleaner user experience.

### Development Tools
- **Download SQLite Tools**: Automatically downloads SQLite tools and adds them to the system PATH for easy access.

### (Optional) Software Installation:
Install essential software automatically using **winget** (Windows Package Manager):
- DB Browser for SQLite
- Mozilla Firefox
- Notepad++
- TeraCopy
- Python 3.13
- 7-Zip

## Enhanced Version Features

### Improved PowerShell Script (SetupScript-Improved.ps1)
- **Configuration File Support**: Customize which features to enable/disable using a JSON configuration file
- **Dry Run Mode**: See what changes would be made without actually applying them
- **Enhanced Logging**: Detailed logging to troubleshoot issues
- **Better Error Handling**: More robust error handling with descriptive messages
- **Progress Tracking**: Visual progress indicator for long-running operations
- **Parameter Support**: Command-line parameters for automation

### GUI Version (SetupScript-GUI.ps1)
- **User-Friendly Interface**: Graphical interface for easy configuration
- **Tabbed Organization**: Organize settings into logical categories
- **Selective Execution**: Choose which optimizations to apply
- **Application Selection**: Select which applications to install

## Usage

### Prerequisites:
- PowerShell 5.1 or later
- Ensure you have administrative privileges to execute the script.
- Confirm that the **winget** package manager is installed and up-to-date.
- Confirm that you have enabled PowerShell scripts with **Get-ExecutionPolicy** 

### Running the Script:

#### Default Version:
1. Open PowerShell as an Administrator.
2. Execute the script. 

```ps1
irm "https://raw.githubusercontent.com/Olsson-Tim/CleanWinScript/main/SetupScript.ps1" | iex
```

#### Enhanced Version:
1. Open PowerShell as an Administrator.
2. Execute the improved script.

```ps1
.\SetupScript-Improved.ps1
```

#### GUI Version:
1. Open PowerShell as an Administrator.
2. Execute the GUI script.

```ps1
.\SetupScript-GUI.ps1
```

### Configuration File:
The enhanced version uses a JSON configuration file (`config.json`) to determine which optimizations to apply. You can customize this file to enable or disable specific features.

### Parameters:
The enhanced version supports the following parameters:
- `-ConfigPath`: Path to a custom configuration file
- `-DryRun`: Shows what would be changed without making any changes
- `-LogPath`: Path to a custom log file

Example with parameters:
```ps1
.\SetupScript-Improved.ps1 -ConfigPath ".\custom-config.json" -DryRun -LogPath ".\optimization.log"
```

### What Happens:
- The script customizes your system by making registry changes.
- OneDrive is uninstalled (with optional manual removal of leftover files).
- Essential software is installed automatically.
- System maintenance tasks are run.
- Explorer is restarted to apply changes.

## Safety Notes
- **Backup Important Files:** Before running the script, back up critical data.
- **Transparency:** Actions are logged for review and troubleshooting.
- **Review the Script:** Review the script before running it to ensure it meets your needs.
- **Dry Run Mode:** Use the dry run mode to see what changes would be made before applying them.

## Troubleshooting
- If the script encounters an issue, detailed error messages will help identify the problem.
- Check the log file for detailed information about what the script did.
- Verify dependencies, such as having `winget` installed and a stable internet connection.

## Credits
This script incorporates code and concepts from [Chris Titus Tech's WinUtil project](https://github.com/ChrisTitusTech/winutil). A big thanks to Chris Titus for providing a foundation for Windows optimization.

## License
This project is licensed under the MIT License. You are free to modify and distribute it as needed.

## Contributions
Contributions are welcome! Feel free to submit a pull request or open an issue if you have suggestions for improvements or additional features.

### Example Output
```powershell
[2024-08-21 10:30:15] [INFO] Starting Windows Optimization Script
[2024-08-21 10:30:15] [INFO] Log file: C:\Users\User\AppData\Local\Temp\windows-optimization.log
[2024-08-21 10:30:15] [SUCCESS] Configuration loaded from C:\Scripts\config.json
[2024-08-21 10:30:15] [INFO] Reverting right-click menu to Windows 10 style...
[2024-08-21 10:30:16] [SUCCESS] Right-click menu reverted successfully.
...
[2024-08-21 10:35:22] [SUCCESS] Script completed successfully!
```

---

**Streamline your Windows experience with this powerful optimization script!**
