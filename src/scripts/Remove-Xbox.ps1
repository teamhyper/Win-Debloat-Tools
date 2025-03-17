Import-Module -DisableNameChecking "$PSScriptRoot\..\lib\Title-Templates.psm1"
Import-Module -DisableNameChecking "$PSScriptRoot\..\lib\debloat-helper\Remove-UWPApp.psm1"
Import-Module -DisableNameChecking "$PSScriptRoot\..\lib\debloat-helper\Set-ItemPropertyVerified.psm1"
Import-Module -DisableNameChecking "$PSScriptRoot\..\lib\debloat-helper\Set-ServiceStartup.psm1"
Import-Module -DisableNameChecking "$PSScriptRoot\..\lib\ui\Show-MessageDialog.psm1"
Import-Module -DisableNameChecking "$PSScriptRoot\..\utils\Individual-Tweaks.psm1"

function Remove-Xbox() {
    $PathToLMServicesXbgm = "HKLM:\SYSTEM\CurrentControlSet\Services\xbgm"
    $TweakType = "Xbox"

    $XboxServices = @(
        "XblAuthManager"                    # Xbox Live Auth Manager
        "XblGameSave"                       # Xbox Live Game Save
        "XboxGipSvc"                        # Xbox Accessory Management Service
        "XboxNetApiSvc"
    )

    $XboxApps = @(
        "Microsoft.GamingApp"               # Xbox
        "Microsoft.GamingServices"          # Gaming Services
        "Microsoft.XboxApp"                 # Xbox Console Companion (Legacy App)
        "Microsoft.XboxGameCallableUI"
        "Microsoft.XboxGameOverlay"
        "Microsoft.XboxSpeechToTextOverlay"
        "Microsoft.XboxGamingOverlay"       # Xbox Game Bar
        "Microsoft.XboxIdentityProvider"    # Xbox Identity Provider (Xbox Dependency)
        "Microsoft.Xbox.TCUI"               # Xbox Live API communication (Xbox Dependency)
    )

    Write-Status -Types "-", $TweakType -Status "Disabling ALL Xbox Services..."
    Set-ServiceStartup -State 'Disabled' -Services $XboxServices

    Write-Status -Types "-", $TweakType -Status "Wiping Xbox Apps completely from Windows..."
    Remove-UWPApp -AppxPackages $XboxApps

    Write-Status -Types "-", $TweakType -Status "Disabling Xbox Game Monitoring..."
    Set-ItemPropertyVerified -Path "$PathToLMServicesXbgm" -Name "Start" -Type DWord -Value 4

    Disable-XboxGameBarDVRandMode
}

Remove-Xbox # Remove all Xbox related Apps, services, etc.
