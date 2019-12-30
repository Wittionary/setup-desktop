# Goal: Setup your brand new desktop with most used apps
# Requirements: Run this script as administrator

# TODO:
# add logging for troubleshooting and ensuring everything got installed if unattended

# Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RefreshEnv.cmd

# List of apps to install
# add new versions of powershell (6, 7, core)?
$apps = @("7zip", "autohotkey", "docker-desktop", "evernote", 
        "f.lux", "git", "Github-desktop", "GoogleChrome", "Greenshot",
        "VScode", "Firefox", "ProtonVPN", "Python", "Simplenote", "Spotify", "Todoist",
        "todoist-outlook", "vmwarevsphereclient", "winpcap", "Wireshark",
        "zoom","1password")
        
# Use Chocolatey to install apps
ForEach ($app in $apps) {
    & choco install $app --confirm
}

# Windows Subsystem for Linux (WSL 1) -- REQUIRES REBOOT
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart

# Download distro ( https://docs.microsoft.com/en-us/windows/wsl/install-manual )
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile Ubuntu.appx -UseBasicParsing
Add-AppxPackage .\app_name.appx
# Initialize distro ( https://docs.microsoft.com/en-us/windows/wsl/initialize-distro )
# create sched task to run distro.exe upon next boot

#Windows Terminal
$windowsTerminalPackage = "Microsoft.WindowsTerminal_0.3.2171.0_x64__8wekyb3d8bbwe"
Add-AppxPackage -Register “C:\Program Files\WindowsApps\$windowsTerminalPackage” –DisableDevelopmentMode

Restart-Computer -Confirm