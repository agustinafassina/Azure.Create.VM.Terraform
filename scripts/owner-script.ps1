param(
    [Parameter(Mandatory=$true)]
    [string]$TerraformServerName
)

$ErrorActionPreference = "Stop"

$LogFilePath = "C:\owner-scripts-logs.txt"

Start-Transcript -Path $LogFilePath -Append

# The Custom Script Extension downloads every file listed in fileUris into the
# same folder as this script, so the child scripts are run from $PSScriptRoot.
$ScriptsToRun = @(
    @{
        Name = "create_environment_variable.ps1"
        Args = @("-TerraformServerName", $TerraformServerName)
    },
    @{
        Name = "install_script.ps1"
        Args = @()
    }
)

try {
    foreach ($Script in $ScriptsToRun) {
        $ScriptPath = Join-Path $PSScriptRoot $Script.Name

        if (-Not (Test-Path -Path $ScriptPath)) {
            throw "Script not found: $ScriptPath"
        }

        Write-Output "Executing $ScriptPath..."
        powershell -ExecutionPolicy Unrestricted -File $ScriptPath @($Script.Args)

        if ($LASTEXITCODE -ne 0) {
            throw "$($Script.Name) failed with exit code $LASTEXITCODE"
        }
    }
}
finally {
    Stop-Transcript
}
