param(
    [Parameter(Mandatory=$true)]
    [string]$TerraformServerName
)

$EnvironmentVariableName = "ML_ServerName"

[System.Environment]::SetEnvironmentVariable($EnvironmentVariableName, $TerraformServerName, "Machine")
Write-Output "Environment variable '$EnvironmentVariableName' set to '$TerraformServerName'."

if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Chocolatey is not installed. Proceeding with installation..."

    Set-ExecutionPolicy Bypass -Scope Process -Force

    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Output "Chocolatey installed successfully."
} else {
    Write-Output "Chocolatey is already installed."
}

$RequiredPackages = @('git', 'nodejs', 'firefox')

foreach ($Package in $RequiredPackages) {
    Write-Output "Installing package: $Package..."
    choco install -y $Package
}

Write-Output "All dependencies have been installed and environment variable configured."