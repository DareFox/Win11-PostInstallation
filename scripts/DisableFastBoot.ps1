# [Script]
# Name = Disable-Fast-Boot
# Description = Disable Fast Boot. Strongly recommened, if you use dualboot systems. With Fast Boot, after reboot disk can be unreadable from second system. 

# [Dependencies] 
# Requires = null
function Disable-Fast-Boot {
    Set-Itemproperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name 'HiberbootEnabled' -Value 0 -Type DWord
}