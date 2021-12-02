# Goal: Setup your brand new desktop with most used apps
# Requirements: Run this script as administrator
#$VerbosePreference = "Continue"

# Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RefreshEnv.cmd

# List of apps to install
$Apps = @("azure-cli", "covenanteyes", "docker-desktop", "dropbox", 
        "Firefox", "f.lux", "git", "Github-desktop", "GoogleChrome", "Greenshot",
        "kubernetes-cli", "microsoft-windows-terminal", "mRemoteNG", "obsidian", "powershell-core", "ProtonVPN",
        "Python", "RescueTime", "Simplenote", "Spotify",
        "terraform", "terragrunt", "todoist-outlook", "VScode", "winpcap", "Wireshark",
        "wsl", "wsl-kalilinux", "wsl-ubuntu-2004",
        "zoom","1password","7zip")
# Not listed in choco package management:
# - espanso - https://espanso.org/docs/next/install/win/
# - Raindrop.io -> maybe just use the Firefox extension and not native app
# - Todoist (legacy package is hosted as of 11/23/21) - https://todoist.com/downloads
        
# Use Chocolatey to install apps
# TODO: 
# - Add progress bar
# - Add logging for troubleshooting and ensuring everything got installed if unattended
# https://docs.chocolatey.org/en-us/choco/commands/install#exit-codes
$i = 0
ForEach ($App in $Apps) {
    $i++
    Write-Progress -Activity 'Installing applications' -CurrentOperation $App -PercentComplete (($i / $Apps.Count) * 100)
    & choco install $app --confirm --limit-output
}


# Configure taskbar
# Hide search window
# Show task view button
# Pin favorite applications to taskbar
# https://docs.microsoft.com/en-us/windows/configuration/configure-windows-10-taskbar
# Left to right:
# - Firefox, Windows Terminal, VScode, Obsidian, Todoist, Spotify, Chrome, anything else, Raindrop.io

# Powershell Modules to install
$PowershellModules = @("az")
$i = 0
foreach ($PowershellModule in $PowershellModules) {
    $i++
    Write-Progress -Activity 'Installing Powershell modules' -CurrentOperation $PowershellModule -PercentComplete (($i / $PowershellModules.Count) * 100)
    Install-Module -Name $PowershellModule
}

# Reboot for changes
$PatienceInterval = 10
Write-Host "Restarting PC in $PatienceInterval seconds"
Start-Sleep -Seconds $PatienceInterval
Restart-Computer -Confirm