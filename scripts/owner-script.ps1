param(
    [Parameter(Mandatory=$true)]
    [string]$TerraformServerName
)

$EnvVarScriptUrl = ""

$LogFilePath = "C:\owner-scripts-logs.txt"

Start-Transcript -Path $LogFilePath -Append

$ScriptsToDownload = @(
    @{
        Url = $EnvVarScriptUrl
        Path = "C:\scripts\set_environment_variable.ps1"
    }
)

$ScriptsDirectory = "C:\scripts"
if (-Not (Test-Path -Path $ScriptsDirectory)) {
    New-Item -Path $ScriptsDirectory -ItemType Directory -Force
}

foreach ($Script in $ScriptsToDownload) {
    Write-Output "Downloading $($Script.Url)..."
    Invoke-WebRequest -Uri $Script.Url -OutFile $Script.Path

    Write-Output "Executing $($Script.Path)..."

    if ($Script.Path -eq "C:\scripts\set_environment_variable.ps1") {
        powershell -ExecutionPolicy Unrestricted -File $Script.Path -TerraformServerName $TerraformServerName
    } else {
        powershell -ExecutionPolicy Unrestricted -File $Script.Path
    }
}

Stop-Transcript