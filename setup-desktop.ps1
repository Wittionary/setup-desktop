# Goal: Setup your brand new desktop with most used apps
# Requirements: Run this script as administrator

# Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Use Chocolatey to install apps
& choco install 7zip
& choco install autohotkey
& choco install docker-desktop
& choco install evernote
& choco install f.lux
& choco install git
& choco install Github-desktop
& choco install GoogleChrome
& choco install Greenshot
& choco install Hyper
& choco install VScode
& choco install Firefox
& choco install ProtonVPN
& choco install Python
& choco install Simplenote
& choco install Todoist
& choco install todoist-outlook
& choco install vmwarevsphereclient
& choco install winpcap
& choco install Wireshark
& choco install zoom

& choco install 1password # requires reboot?

Restart-Computer -Confirm