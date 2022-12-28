# [Script]
# Name = Show-Seconds-In-Taskbar
# Description = Show seconds on taskbar clock
# Requires = null
function Show-Seconds-In-Taskbar {
    Set-Itemproperty -path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSecondsInSystemClock' -Value 1 -Type DWord
}