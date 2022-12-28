# [Script]
# Name = Disable-Hibernation
# Description = Disable Windows Hibernation feature. Strongly recommened, if you use dualboot systems. After Hibernation, disk can be unreadable from second system. 

# [Dependencies] 
# Requires = null
function Disable-Hibernation {
    Set-Itemproperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'HibernateEnabled' -Value 0 -Type DWord
}