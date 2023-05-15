# Goal: Setup your brand new desktop with most used apps
# Requirements: Run this script as administrator
#$VerbosePreference = "Continue"
$ConfFiles = @("packages-homebrew.conf",
                "packages-apt.conf",
                "packages-choco.conf")
foreach ($ConfFile in $ConfFiles) {
    if (! $(Test-Path -Path "./$ConfFile")) {
        Write-Error "Configuration file `"$ConfFile`" not found."
        Write-Host "Downloading `"$ConfFile`""
        $ConfFileUrl = "https://raw.githubusercontent.com/Wittionary/setup-desktop/master/$ConfFile"
        ((New-Object System.Net.WebClient).DownloadString($ConfFileUrl)) | Out-File -FilePath $ConfFile
    } else {
        Write-Host "Configuration file `"$ConfFile`" found."
    }
}

# Hyper-V
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RefreshEnv.cmd

# List of apps to install
$ChocoPackages = Get-Content .\packages-choco.conf
# Not listed in choco package management:
# - espanso - https://espanso.org/docs/next/install/win/
# - Raindrop.io -> maybe just use the Firefox extension and not native app
# - Todoist (legacy package is hosted as of 11/23/21) - https://todoist.com/downloads
        
# Use Chocolatey to install apps
# TODO: 
# - Add logging for troubleshooting and ensuring everything got installed if unattended
# https://docs.chocolatey.org/en-us/choco/commands/install#exit-codes
$i = 0
$ErrorStack = @()
ForEach ($ChocoPackage in $ChocoPackages) {
    $i++
    Write-Progress -Activity 'Installing applications' -CurrentOperation $ChocoPackage -PercentComplete (($i / $ChocoPackages.Count) * 100)
    try {
        & choco install $ChocoPackage --confirm --limit-output
    } catch {
        $ErrorStack += $Error
    }
}
Write-Host "Installation errors:`n$ErrorStack"


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

# Setup WSL
wsl --update
$Distros = @("Ubuntu-22.04", "kali-linux")
foreach ($Distro in $Distros) {
    # Install
    Write-Host "Initializing $Distro..."
    wsl --install --distribution $Distro
}

# Wait until the distros are setup manually w/ user and pass
# TODO: feed the installs a config file that
$UbuntuProcess = Get-Process -Name "ubuntu2204"
$KaliProcess = Get-Process -Name "kali"
Write-Host "Waiting for user to configure and close Ubuntu ($($UbuntuProcess.Id)) and Kali ($($UbuntuProcess.Id)) processes..."
Wait-Process -Id $UbuntuProcess.Id
Wait-Process -Id $KaliProcess.Id

foreach ($Distro in $Distros) {
    wsl --set-default $Distro
    # Setup kubectl prereqs - https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
    wsl -u root -- sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    wsl -u root -- sudo echo 'deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    
    # Update each distro
    Write-Host "Updating $Distro..."
    wsl --user root -- sudo apt update
    wsl --user root -- sudo apt upgrade -y
}

# Set Ubuntu as default
wsl --set-default "Ubuntu-22.04"
# Install software
$AptPackages = Get-Content .\packages-apt.conf
$HomebrewPackages = Get-Content .\packages-homebrew.conf
Write-Host "Installing homebrew..."
wsl -u root -- /bin/bash -c "$(curl https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
wsl -u root -- echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/witt/.zprofile
wsl -u root -- eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
Write-Host "Installing apt packages..."
wsl -u root -- sudo apt install $AptPackages -y
Write-Host "Installing homebrew packages..."
wsl -u root -- brew install $HomebrewPackages
# Setup zsh
#wsl -u root -- sudo chsh -s $(which zsh)


# Reboot for changes
$PatienceInterval = 10
Write-Host "Restarting PC in $PatienceInterval seconds"
Start-Sleep -Seconds $PatienceInterval
Restart-Computer -Confirm $true
