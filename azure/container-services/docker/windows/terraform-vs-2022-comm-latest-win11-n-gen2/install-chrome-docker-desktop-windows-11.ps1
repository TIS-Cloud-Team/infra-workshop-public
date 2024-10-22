# Function to check if a Windows feature is enabled
function Is-FeatureEnabled {
    param (
        [string]$featureName
    )
    $feature = Get-WindowsOptionalFeature -FeatureName $featureName -Online
    return $feature.State -eq 'Enabled'
}

# Function to enable a Windows feature
function Enable-Feature {
    param (
        [string]$featureName
    )
    if (-not (Is-FeatureEnabled -featureName $featureName)) {
        Enable-WindowsOptionalFeature -Online -FeatureName $featureName -All -NoRestart
        Write-Output "$featureName has been enabled. A restart may be required."
    } else {
        Write-Output "$featureName is already enabled."
    }
}

# Define the URL for the latest x64 version of Google Chrome
$chromeUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"

# Define the path to save the installer
$installerPath = "$env:TEMP\chrome_installer.exe"

# Download the Chrome installer
Invoke-WebRequest -Uri $chromeUrl -OutFile $installerPath

# Install Chrome silently
Start-Process -FilePath $installerPath -ArgumentList "/silent", "/install" -NoNewWindow -Wait

# Clean up the installer file
Remove-Item -Path $installerPath -Force

Write-Output "Google Chrome has been installed successfully."

# Define the URL for the latest Docker Desktop
$dockerUrl = "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"

# Define the path to save the Docker installer
$dockerInstallerPath = "$env:TEMP\DockerDesktopInstaller.exe"

# Download the Docker Desktop installer
Invoke-WebRequest -Uri $dockerUrl -OutFile $dockerInstallerPath

# Install Docker Desktop silently
Start-Process -FilePath $dockerInstallerPath -ArgumentList "install", "--quiet" -NoNewWindow -Wait

# Clean up the Docker installer file
Remove-Item -Path $dockerInstallerPath -Force

Write-Output "Docker Desktop has been installed successfully."

# Enable Hyper-V if not already enabled
Enable-Feature -featureName "Microsoft-Hyper-V-All"

# Restart the computer if Hyper-V was enabled
if (-not (Is-FeatureEnabled -featureName "Microsoft-Hyper-V-All")) {
    Write-Output "Restarting the computer to complete Hyper-V installation..."
    Restart-Computer -Force
} else {
    Write-Output "Hyper-V is already enabled."
}

## Usage:
## Open PowerShell as an administrator.
## .\install-chrome-docker-desktop-windows-11.ps1