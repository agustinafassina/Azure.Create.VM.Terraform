# Set environment variables
$envVariableName = "ML_ServerName"
$envVariableValue = "tf-prod-ml"
[System.Environment]::SetEnvironmentVariable($envVariableName, $envVariableValue, "Machine")

# Install required dependencies (example with Chocolatey)
# Check if Chocolatey is installed
if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Chocolatey is not installed. Proceeding with installation..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
    Write-Output "Chocolatey is already installed."
}

# Install necessary packages
$packages = @('git', 'nodejs', 'firefox')
foreach ($pkg in $packages) {
    choco install -y $pkg
}

Write-Output "All dependencies have been installed and environment variable configured."