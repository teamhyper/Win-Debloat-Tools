Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"title-templates.psm1"

# Adapted from this ChrisTitus script:                      https://github.com/ChrisTitusTech/win10script
# Adapted from this Sycnex script:                          https://github.com/Sycnex/Windows10Debloater
# Adapted from this kalaspuffar/Daniel Persson script:      https://github.com/kalaspuffar/windows-debloat

Function PersonalTweaks() {

    Title1 -Text "My Personal Tweaks"

    Push-Location -Path "$PSScriptRoot\..\utils\"
    Write-Host "[+] Enabling Dark theme..."
    regedit /s dark-theme.reg
    Write-Host "$($Status[0]) Cortana..."
    regedit /s disable-cortana.reg
    Write-Host "[+] Enabling photo viewer..."
    regedit /s enable-photo-viewer.reg
    Pop-Location

    Section1 -Text "Windows Explorer Tweaks"

    Write-Host "[-] Hiding Quick Access from Windows Explorer..."
    Set-ItemProperty -Path "$PathToExplorer" -Name "ShowFrequent" -Type DWord -Value $Zero
    Set-ItemProperty -Path "$PathToExplorer" -Name "ShowRecent" -Type DWord -Value $Zero
    Set-ItemProperty -Path "$PathToExplorer" -Name "HubMode" -Type DWord -Value $One

    Section1 -Text "Personalization"
    Section1 -Text "TaskBar Tweaks"

    Caption1 -Text "Windows 11 Only"

    Write-Host "[@] (0 = Hide Widgets, 1 = Show Widgets)"
    Write-Host "[-] Hiding Widgets from taskbar..."
    Set-ItemProperty -Path "$PathToExplorerAdvanced" -Name "TaskbarDa" -Type DWord -Value $Zero
    
    Caption1 -Text "Windows 10 Compatible"
    
    Write-Host "[@] (0 = Hide completely, 1 = Show icon only, 2 = Show long Search Box)"
    Write-Host "[-] Hiding the search box from taskbar..."
    Set-ItemProperty -Path "$PathToSearch" -Name "SearchboxTaskbarMode" -Type DWord -Value $Zero

    Write-Host "[@] (0 = Hide Task view, 1 = Show Task view)"
    Write-Host "[-] Hiding the Task View from taskbar..."
    Set-ItemProperty -Path "$PathToExplorerAdvanced" -Name "ShowTaskViewButton" -Type DWord -Value $Zero

    Write-Host "[@] (0 = Disable, 1 = Enable)"
    Write-Host "$($Status[0]) Open on Hover from News and Interest from taskbar..."
    Set-ItemProperty -Path "$PathToNewsAndInterest" -Name "ShellFeedsTaskbarOpenOnHover" -Type DWord -Value $Zero

    Write-Host "[@] (0 = Enable, 1 = Enable Icon only, 2 = Disable)"
    Write-Host "$($Status[0]) News and Interest from taskbar..."
    Set-ItemProperty -Path "$PathToNewsAndInterest" -Name "ShellFeedsTaskbarViewMode" -Type DWord -Value 2

    Write-Host "[-] Hiding People icon..."
    Set-ItemProperty -Path "$PathToExplorerAdvanced\People" -Name "PeopleBand" -Type DWord -Value $Zero

    Write-Host "$($Status[0]) Live Tiles..."
    If (!(Test-Path "$PathToLiveTiles")) {
        New-Item -Path "$PathToLiveTiles" -Force | Out-Null
    }
    Set-ItemProperty -Path $PathToLiveTiles -Name "NoTileApplicationNotification" -Type DWord -Value $One

    Write-Host "[=] Enabling Auto tray icons..."
    Set-ItemProperty -Path "$PathToExplorer" -Name "EnableAutoTray" -Type DWord -Value 1

    Write-Host "[+] Showing This PC shortcut on desktop..."
    If (!(Test-Path "$PathToExplorer\HideDesktopIcons\ClassicStartMenu")) {
        New-Item -Path "$PathToExplorer\HideDesktopIcons\ClassicStartMenu" -Force | Out-Null
    }
    Set-ItemProperty -Path "$PathToExplorer\HideDesktopIcons\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value $Zero
    If (!(Test-Path "$PathToExplorer\HideDesktopIcons\NewStartPanel")) {
        New-Item -Path "$PathToExplorer\HideDesktopIcons\NewStartPanel" -Force | Out-Null
    }
    Set-ItemProperty -Path "$PathToExplorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value $Zero

    # Disable creation of Thumbs.db thumbnail cache files
    Write-Host "$($Status[0]) creation of Thumbs.db..."
    Set-ItemProperty -Path "$PathToExplorerAdvanced" -Name "DisableThumbnailCache" -Type DWord -Value $One
    Set-ItemProperty -Path "$PathToExplorerAdvanced" -Name "DisableThumbsDBOnNetworkFolders" -Type DWord -Value $One

    Caption1 -Text "Colors"

    Write-Host "$($Status[0]) taskbar transparency..."
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Type DWord -Value $Zero

    Section1 -Text "System"
    Caption1 -Text "Multitasking"

    Write-Host "$($Status[0]) Edge multi tabs showing on Alt + Tab..."
    Set-ItemProperty -Path "$PathToExplorerAdvanced" -Name "MultiTaskingAltTabFilter" -Type DWord -Value 3

    Section1 -Text "Devices"
    Caption1 -Text "Bluetooth & other devices"

    Write-Host "$($Status[1]) driver download over metered connections..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceSetup" -Name "CostedNetworkPolicy" -Type DWord -Value $One
    
    Section1 -Text "Cortana Tweaks"

    Write-Host "$($Status[0]) Bing Search in Start Menu..."
    Set-ItemProperty -Path "$PathToSearch" -Name "BingSearchEnabled" -Type DWord -Value $Zero
    Set-ItemProperty -Path "$PathToSearch" -Name "CortanaConsent" -Type DWord -Value $Zero

    Section1 -Text "Ease of Access"
    Caption1 -Text "Keyboard"

    Write-Output "- Disabling Sticky Keys..."
    Set-ItemProperty -Path "$PathToAccessibility\StickyKeys" -Name "Flags" -Value "506"
    Set-ItemProperty -Path "$PathToAccessibility\Keyboard Response" -Name "Flags" -Value "122"
    Set-ItemProperty -Path "$PathToAccessibility\ToggleKeys" -Name "Flags" -Value "58"

    Section1 -Text "Microsoft Edge Policies"
    Caption1 -Text "Privacy, search and services / Address bar and search"

    Write-Host "[=] Show me search and site suggestions using my typed characters..."
    Remove-ItemProperty -Path "$PathToEdgeUserPol" -Name "SearchSuggestEnabled" -Force -ErrorAction SilentlyContinue
    Write-Host "[=] Show me history and favorite suggestions and other data using my typed characters..."
    Remove-ItemProperty -Path "$PathToEdgeUserPol" -Name "LocalProvidersEnabled" -Force -ErrorAction SilentlyContinue

    Write-Host "[+] Keep ENABLED Error reporting..."
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value $Zero

    Write-Host "$($Status[1]) Setting time to UTC..."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value $One
    
    Write-Host "[+] Setting up the DNS from Google (ipv4 and ipv6)..."
    #Get-DnsClientServerAddress # To look up the current config.
    Set-DNSClientServerAddress -InterfaceAlias "Ethernet*" -ServerAddresses ("8.8.8.8", "8.8.4.4"), ("2001:4860:4860::8888", "2001:4860:4860::8844")
    Set-DNSClientServerAddress -InterfaceAlias "Wi-Fi*" -ServerAddresses ("8.8.8.8", "8.8.4.4"), ("2001:4860:4860::8888", "2001:4860:4860::8844")
    
    Write-Host "[+] Bringing back F8 alternative Boot Modes..."
    bcdedit /set `{current`} bootmenupolicy Legacy

    Write-Host "[+] Fixing Xbox Game Bar FPS Counter... (LIMITED BY LANGUAGE)"
    net localgroup "Performance Log Users" "$env:USERNAME" /add         # ENG
    net localgroup "Usuários de log de desempenho" "$env:USERNAME" /add # PT-BR

    Section1 -Text "Power Plan Tweaks"
    $Time = 10

    Write-Host "[=] Setting Hibernate size to full..."
    powercfg -hibernate -type full
    Write-Host "[+] Enabling Hibernate..."
    powercfg -hibernate off

    Write-Host "[+] Setting the Monitor Timeout to $Time min (AC = Alternating Current, DC = Direct Current)"
    powercfg -Change Monitor-Timeout-AC $Time
    powercfg -Change Monitor-Timeout-DC $Time

    Write-Host "[+] Setting the Disk Timeout to $Time min"
    powercfg -Change Disk-Timeout-AC $Time
    powercfg -Change Disk-Timeout-DC $Time

    Write-Host "[+] Setting the Standby Timeout to $Time min"
    powercfg -Change Standby-Timeout-AC $Time
    powercfg -Change Standby-Timeout-DC $Time

    Write-Host "[+] Setting the Hibernate Timeout to $Time min"
    powercfg -Change Hibernate-Timeout-AC $Time
    powercfg -Change Hibernate-Timeout-DC $Time

}

function Main() {

    # Initialize all Path variables used to Registry Tweaks
    $Global:PathToAccessibility = "HKCU:\Control Panel\Accessibility"
    $Global:PathToEdgeUserPol = "HKCU:\SOFTWARE\Policies\Microsoft\Edge"
    $Global:PathToExplorer = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
    $Global:PathToExplorerAdvanced = "$PathToExplorer\Advanced"
    $Global:PathToLiveTiles = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
    $Global:PathToNewsAndInterest = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds"
    $Global:PathToSearch = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"

    $Global:Zero = 0
    $Global:One = 1
    $Global:Status = @("[-] Disabling", "[+] Enabling")

    if (($Revert)) {
        Write-Host "[<] Reverting: $Revert"

        $Global:Zero = 1
        $Global:One = 0
        $Global:Status = @("[<] Enabling", "[<] Disabling")
      
    }
    
    PersonalTweaks  # Personal UI, Network, Energy and Accessibility Optimizations

}

Main