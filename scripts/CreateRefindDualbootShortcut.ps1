# [Script]
# Name = Create-Refind-Dualboot-Shortcut
# Description = Create shortcut to change UEFI refind keys and reboot to other system
# Requires = null
function Create-Refind-Dualboot-Shortcut {
    $folder = New-Item "C:\DualbootRefind" -ItemType Directory
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

    $bytes = [System.IO.File]::ReadAllBytes("$Home\Desktop\ColorPix.lnk")

    if ([Environment]::Is64BitProcess -ne [Environment]::Is64BitOperatingSystem) {
        Write-Host "System is 32 bit"
        $bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON
    } else {
        Write-Host "System is 64 bit"
        $bytes[0x2A] = $bytes[0x2A] -bor 0x20 # Run as Administrator
        # https://stackoverflow.com/questions/28997799/how-to-create-a-run-as-administrator-shortcut-using-powershell#comment113731543_29002207
    }
    $bytes | Set-Content $ShortcutPath -Encoding Byte
}