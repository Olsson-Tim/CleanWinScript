@echo off
REM Windows Optimization Script Launcher
REM This batch file launches the GUI version of the Windows Optimization Script

powershell -ExecutionPolicy Bypass -File "%~dp0SetupScript-GUI.ps1"