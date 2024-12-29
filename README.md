# Windows System Optimization Script

## Overview
This script optimizes and customizes your Windows system by automating tasks such as enabling/disabling features, removing unnecessary software, and running essential system maintenance commands. It's an efficient, all-in-one solution to enhance productivity and streamline system performance.

This scripts is made to work best with a Microwin image created with the [Chris Titus Tech's WinUtil project](https://christitustech.github.io/winutil/userguide/#microwin) but it should work with a normal windows 11 install.

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

## Usage

### Prerequisites:
- PowerShell 5.1 or later
- Ensure you have administrative privileges to execute the script.
- Confirm that the **winget** package manager is installed and up-to-date.
- Confirm that you have enabled powershell scripts with **Get-ExecutionPolicy** 

### Running the Script:
1. Open PowerShell as an Administrator.
2. Execute the script. 

    #### Default:
   ```ps1
   irm "https://raw.githubusercontent.com/Olsson-Tim/CleanWinScript/main/SetupScript.ps1" | iex
   ```
    #### Installs apps:
   ```ps1
   irm "https://raw.githubusercontent.com/Olsson-Tim/CleanWinScript/main/SetupScript.ps1" | iex -app
   ```

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

## Credits
This script incorporates code and concepts from [Chris Titus Tech's WinUtil project](https://github.com/ChrisTitusTech/winutil). A big thanks to Chris Titus for providing a foundation for Windows optimization.

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
