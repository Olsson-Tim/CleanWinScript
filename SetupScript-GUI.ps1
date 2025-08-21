# Windows Optimization Script GUI
# This script creates a graphical interface for the Windows Optimization Script

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Windows Optimization Script'
$form.Size = New-Object System.Drawing.Size(600, 700)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

# Create a tab control
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = 'Fill'

# Create tabs
$systemTab = New-Object System.Windows.Forms.TabPage
$systemTab.Text = 'System Settings'

$privacyTab = New-Object System.Windows.Forms.TabPage
$privacyTab.Text = 'Privacy Settings'

$softwareTab = New-Object System.Windows.Forms.TabPage
$softwareTab.Text = 'Software'

$maintenanceTab = New-Object System.Windows.Forms.TabPage
$maintenanceTab.Text = 'Maintenance'

# Add tabs to tab control
$tabControl.TabPages.Add($systemTab)
$tabControl.TabPages.Add($privacyTab)
$tabControl.TabPages.Add($softwareTab)
$tabControl.TabPages.Add($maintenanceTab)

# System Settings Tab
$systemGroupBox = New-Object System.Windows.Forms.GroupBox
$systemGroupBox.Text = 'System Customization'
$systemGroupBox.Location = New-Object System.Drawing.Point(20, 20)
$systemGroupBox.Size = New-Object System.Drawing.Size(540, 200)

# Checkboxes for system settings
$revertRightClickMenu = New-Object System.Windows.Forms.CheckBox
$revertRightClickMenu.Text = 'Revert Right-Click Menu to Windows 10 Style'
$revertRightClickMenu.Location = New-Object System.Drawing.Point(20, 30)
$revertRightClickMenu.Size = New-Object System.Drawing.Size(300, 20)
$revertRightClickMenu.Checked = $true

$showFileExtensions = New-Object System.Windows.Forms.CheckBox
$showFileExtensions.Text = 'Show File Extensions'
$showFileExtensions.Location = New-Object System.Drawing.Point(20, 60)
$showFileExtensions.Size = New-Object System.Drawing.Size(200, 20)
$showFileExtensions.Checked = $true

$showHiddenFiles = New-Object System.Windows.Forms.CheckBox
$showHiddenFiles.Text = 'Show Hidden Files'
$showHiddenFiles.Location = New-Object System.Drawing.Point(20, 90)
$showHiddenFiles.Size = New-Object System.Drawing.Size(200, 20)
$showHiddenFiles.Checked = $true

$enableDarkTheme = New-Object System.Windows.Forms.CheckBox
$enableDarkTheme.Text = 'Enable Dark Theme'
$enableDarkTheme.Location = New-Object System.Drawing.Point(20, 120)
$enableDarkTheme.Size = New-Object System.Drawing.Size(200, 20)
$enableDarkTheme.Checked = $true

$enableTaskbarEndTask = New-Object System.Windows.Forms.CheckBox
$enableTaskbarEndTask.Text = 'Enable Taskbar End Task'
$enableTaskbarEndTask.Location = New-Object System.Drawing.Point(20, 150)
$enableTaskbarEndTask.Size = New-Object System.Drawing.Size(200, 20)
$enableTaskbarEndTask.Checked = $true

$systemGroupBox.Controls.AddRange(@($revertRightClickMenu, $showFileExtensions, $showHiddenFiles, $enableDarkTheme, $enableTaskbarEndTask))
$systemTab.Controls.Add($systemGroupBox)

# Privacy Settings Tab
$privacyGroupBox = New-Object System.Windows.Forms.GroupBox
$privacyGroupBox.Text = 'Privacy Enhancements'
$privacyGroupBox.Location = New-Object System.Drawing.Point(20, 20)
$privacyGroupBox.Size = New-Object System.Drawing.Size(540, 200)

$disableBingSearch = New-Object System.Windows.Forms.CheckBox
$disableBingSearch.Text = 'Disable Bing Search'
$disableBingSearch.Location = New-Object System.Drawing.Point(20, 30)
$disableBingSearch.Size = New-Object System.Drawing.Size(200, 20)
$disableBingSearch.Checked = $true

$disableTaskbarSearchButton = New-Object System.Windows.Forms.CheckBox
$disableTaskbarSearchButton.Text = 'Disable Taskbar Search Button'
$disableTaskbarSearchButton.Location = New-Object System.Drawing.Point(20, 60)
$disableTaskbarSearchButton.Size = New-Object System.Drawing.Size(250, 20)
$disableTaskbarSearchButton.Checked = $true

$disableTaskbarWidget = New-Object System.Windows.Forms.CheckBox
$disableTaskbarWidget.Text = 'Disable Taskbar Widget'
$disableTaskbarWidget.Location = New-Object System.Drawing.Point(20, 90)
$disableTaskbarWidget.Size = New-Object System.Drawing.Size(200, 20)
$disableTaskbarWidget.Checked = $true

$disableWindowsCopilot = New-Object System.Windows.Forms.CheckBox
$disableWindowsCopilot.Text = 'Disable Windows Copilot'
$disableWindowsCopilot.Location = New-Object System.Drawing.Point(20, 120)
$disableWindowsCopilot.Size = New-Object System.Drawing.Size(200, 20)
$disableWindowsCopilot.Checked = $true

$disableTelemetry = New-Object System.Windows.Forms.CheckBox
$disableTelemetry.Text = 'Disable Windows Telemetry'
$disableTelemetry.Location = New-Object System.Drawing.Point(20, 150)
$disableTelemetry.Size = New-Object System.Drawing.Size(200, 20)
$disableTelemetry.Checked = $true

$privacyGroupBox.Controls.AddRange(@($disableBingSearch, $disableTaskbarSearchButton, $disableTaskbarWidget, $disableWindowsCopilot, $disableTelemetry))
$privacyTab.Controls.Add($privacyGroupBox)

# Software Tab
$softwareGroupBox = New-Object System.Windows.Forms.GroupBox
$softwareGroupBox.Text = 'Software Management'
$softwareGroupBox.Location = New-Object System.Drawing.Point(20, 20)
$softwareGroupBox.Size = New-Object System.Drawing.Size(540, 200)

$removeOneDrive = New-Object System.Windows.Forms.CheckBox
$removeOneDrive.Text = 'Remove OneDrive'
$removeOneDrive.Location = New-Object System.Drawing.Point(20, 30)
$removeOneDrive.Size = New-Object System.Drawing.Size(200, 20)
$removeOneDrive.Checked = $true

$installApplications = New-Object System.Windows.Forms.CheckBox
$installApplications.Text = 'Install Applications'
$installApplications.Location = New-Object System.Drawing.Point(20, 60)
$installApplications.Size = New-Object System.Drawing.Size(200, 20)
$installApplications.Checked = $true

$installSQLite = New-Object System.Windows.Forms.CheckBox
$installSQLite.Text = 'Install SQLite Tools'
$installSQLite.Location = New-Object System.Drawing.Point(20, 90)
$installSQLite.Size = New-Object System.Drawing.Size(200, 20)
$installSQLite.Checked = $true

$softwareGroupBox.Controls.AddRange(@($removeOneDrive, $installApplications, $installSQLite))
$softwareTab.Controls.Add($softwareGroupBox)

# Maintenance Tab
$maintenanceGroupBox = New-Object System.Windows.Forms.GroupBox
$maintenanceGroupBox.Text = 'System Maintenance'
$maintenanceGroupBox.Location = New-Object System.Drawing.Point(20, 20)
$maintenanceGroupBox.Size = New-Object System.Drawing.Size(540, 200)

$runSFC = New-Object System.Windows.Forms.CheckBox
$runSFC.Text = 'Run System File Checker (SFC)'
$runSFC.Location = New-Object System.Drawing.Point(20, 30)
$runSFC.Size = New-Object System.Drawing.Size(250, 20)
$runSFC.Checked = $true

$runDISM = New-Object System.Windows.Forms.CheckBox
$runDISM.Text = 'Run DISM Scan and Repair'
$runDISM.Location = New-Object System.Drawing.Point(20, 60)
$runDISM.Size = New-Object System.Drawing.Size(250, 20)
$runDISM.Checked = $true

$maintenanceGroupBox.Controls.AddRange(@($runSFC, $runDISM))
$maintenanceTab.Controls.Add($maintenanceGroupBox)

# Applications Group Box
$applicationsGroupBox = New-Object System.Windows.Forms.GroupBox
$applicationsGroupBox.Text = 'Applications to Install'
$applicationsGroupBox.Location = New-Object System.Drawing.Point(20, 300)
$applicationsGroupBox.Size = New-Object System.Drawing.Size(540, 250)

# Application checkboxes
$dbBrowser = New-Object System.Windows.Forms.CheckBox
$dbBrowser.Text = 'DB Browser for SQLite'
$dbBrowser.Location = New-Object System.Drawing.Point(20, 30)
$dbBrowser.Size = New-Object System.Drawing.Size(200, 20)
$dbBrowser.Checked = $true

$firefox = New-Object System.Windows.Forms.CheckBox
$firefox.Text = 'Mozilla Firefox'
$firefox.Location = New-Object System.Drawing.Point(20, 60)
$firefox.Size = New-Object System.Drawing.Size(200, 20)
$firefox.Checked = $true

$notepad = New-Object System.Windows.Forms.CheckBox
$notepad.Text = 'Notepad++'
$notepad.Location = New-Object System.Drawing.Point(20, 90)
$notepad.Size = New-Object System.Drawing.Size(200, 20)
$notepad.Checked = $true

$teraCopy = New-Object System.Windows.Forms.CheckBox
$teraCopy.Text = 'TeraCopy'
$teraCopy.Location = New-Object System.Drawing.Point(20, 120)
$teraCopy.Size = New-Object System.Drawing.Size(200, 20)
$teraCopy.Checked = $true

$python = New-Object System.Windows.Forms.CheckBox
$python.Text = 'Python 3.13'
$python.Location = New-Object System.Drawing.Point(280, 30)
$python.Size = New-Object System.Drawing.Size(200, 20)
$python.Checked = $true

$sevenZip = New-Object System.Windows.Forms.CheckBox
$sevenZip.Text = '7-Zip'
$sevenZip.Location = New-Object System.Drawing.Point(280, 60)
$sevenZip.Size = New-Object System.Drawing.Size(200, 20)
$sevenZip.Checked = $true

$applicationsGroupBox.Controls.AddRange(@($dbBrowser, $firefox, $notepad, $teraCopy, $python, $sevenZip))
$softwareTab.Controls.Add($applicationsGroupBox)

# Buttons
$runButton = New-Object System.Windows.Forms.Button
$runButton.Text = 'Run Optimization'
$runButton.Location = New-Object System.Drawing.Point(200, 600)
$runButton.Size = New-Object System.Drawing.Size(120, 40)
$runButton.BackColor = [System.Drawing.Color]::LightGreen

$exitButton = New-Object System.Windows.Forms.Button
$exitButton.Text = 'Exit'
$exitButton.Location = New-Object System.Drawing.Point(350, 600)
$exitButton.Size = New-Object System.Drawing.Size(120, 40)
$exitButton.BackColor = [System.Drawing.Color]::LightCoral

# Add controls to form
$form.Controls.AddRange(@($tabControl, $runButton, $exitButton))

# Event handlers
$runButton.Add_Click({
    # Create configuration based on selections
    $config = @{
        SystemSettings = @{
            RevertRightClickMenu = $revertRightClickMenu.Checked
            ShowFileExtensions = $showFileExtensions.Checked
            ShowHiddenFiles = $showHiddenFiles.Checked
            EnableDarkTheme = $enableDarkTheme.Checked
            EnableTaskbarEndTask = $enableTaskbarEndTask.Checked
        }
        PrivacySettings = @{
            DisableBingSearch = $disableBingSearch.Checked
            DisableTaskbarSearchButton = $disableTaskbarSearchButton.Checked
            DisableTaskbarWidget = $disableTaskbarWidget.Checked
            DisableWindowsCopilot = $disableWindowsCopilot.Checked
            DisableTelemetry = $disableTelemetry.Checked
        }
        Maintenance = @{
            RunSFC = $runSFC.Checked
            RunDISM = $runDISM.Checked
        }
        Software = @{
            RemoveOneDrive = $removeOneDrive.Checked
            InstallApplications = $installApplications.Checked
            InstallSQLite = $installSQLite.Checked
        }
        Applications = @()
    }
    
    # Add selected applications
    if ($dbBrowser.Checked) { $config.Applications += "DBBrowserForSQLite.DBBrowserForSQLite" }
    if ($firefox.Checked) { $config.Applications += "Mozilla.Firefox" }
    if ($notepad.Checked) { $config.Applications += "Notepad++.Notepad++" }
    if ($teraCopy.Checked) { $config.Applications += "CodeSector.TeraCopy" }
    if ($python.Checked) { $config.Applications += "Python.Python.3.13" }
    if ($sevenZip.Checked) { $config.Applications += "7zip.7zip" }
    
    # Save configuration to temp file
    $configPath = "$env:TEMP\windows-opt-config.json"
    $config | ConvertTo-Json -Depth 3 | Out-File -FilePath $configPath -Encoding UTF8
    
    # Run the main script with the configuration
    $scriptPath = Join-Path -Path $PSScriptRoot -ChildPath "SetupScript-Improved.ps1"
    if (Test-Path $scriptPath) {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`" -ConfigPath `"$configPath`"" -Wait
        [System.Windows.Forms.MessageBox]::Show("Optimization completed! Check the log file for details.", "Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } else {
        [System.Windows.Forms.MessageBox]::Show("Main script not found. Please ensure SetupScript-Improved.ps1 exists in the same directory.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

$exitButton.Add_Click({
    $form.Close()
})

# Show the form
$form.ShowDialog() | Out-Null