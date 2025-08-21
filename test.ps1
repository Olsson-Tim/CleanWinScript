# Test script for Windows Optimization Script
# This script tests the main functions without making actual system changes

# Run the improved script in dry-run mode to test functionality
Write-Host "Testing Windows Optimization Script..." -ForegroundColor Cyan

# Test with dry-run mode to avoid making actual changes
.\SetupScript-Improved.ps1 -DryRun -LogPath ".\test-run.log"

Write-Host "Test completed. Check test-run.log for details." -ForegroundColor Green