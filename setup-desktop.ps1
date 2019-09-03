# Goal: Setup your brand new desktop with most used apps
# Requirements: Run this script as administrator

# Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RefreshEnv.cmd

# Use Chocolatey to install apps
& choco install 7zip autohotkey docker-desktop evernote f.lux git Github-desktop GoogleChrome Greenshot VScode Firefox ProtonVPN Python Simplenote Todoist todoist-outlook vmwarevsphereclient winpcap Wireshark zoom 1password -y

#Windows Terminal
$windowsTerminalPackage = "Microsoft.WindowsTerminal_0.3.2171.0_x64__8wekyb3d8bbwe"
Add-AppxPackage -Register “C:\Program Files\WindowsApps\$windowsTerminalPackage” –DisableDevelopmentMode

Restart-Computer -Confirm