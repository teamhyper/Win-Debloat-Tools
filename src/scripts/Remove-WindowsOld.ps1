Import-Module -DisableNameChecking "$PSScriptRoot\..\lib\Title-Templates.psm1"
Import-Module -DisableNameChecking "$PSScriptRoot\..\lib\ui\Show-MessageDialog.psm1"

function Remove-WindowsOld() {
    $TweakType = "Windows.old"

    Write-Status -Types "+", $TweakType -Status "Cleaning up Old Windows Installation (Windows.old)..."
    Start-Process cleanmgr.exe -ArgumentList "/d $env:SystemDrive", "/AUTOCLEAN" -Wait
    Remove-ItemVerified -Path "$env:SystemDrive\Windows.old\" -Recurse -Force
}

Remove-WindowsOld
