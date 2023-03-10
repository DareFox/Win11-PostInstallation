# [Script]
# Name = Create-Refind-Dualboot-Shortcut
# Description = Create shortcut to change UEFI refind keys and reboot to other system
# Requires = null
function Create-Refind-Dualboot-Shortcut {
    $folder = "C:\DualbootRefind"
    if (!(Test-Path $folder)) {
        New-Item $folder -ItemType Directory
    }

    $baseUrl = "https://raw.githubusercontent.com/DareFox/Win11-PostInstallation/main/resources/"
    $files = "RefindNextBoot.cs","RefindNextBoot.ps1","dualboot.ps1","dualboot.bat"

    $ProgressPreference = 'SilentlyContinue' # https://stackoverflow.com/a/43477248

    foreach ($element in $files) {
        Invoke-WebRequest -URI "$baseUrl$element" -OutFile "$folder\$element" 
    }

    $ShortcutPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Dualboot.lnk"
    $TargetPath = "$folder\dualboot.bat"

    $WScriptObj = New-Object -ComObject ("WScript.Shell")
    $ShortcutObj = $WscriptObj.CreateShortcut($ShortcutPath)
    $ShortcutObj.TargetPath = $TargetPath
    $ShortcutObj.Save()

    $bytes = [System.IO.File]::ReadAllBytes($ShortcutPath)

    $bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
    [System.IO.File]::WriteAllBytes($ShortcutPath, $bytes)
}

Create-Refind-Dualboot-Shortcut
