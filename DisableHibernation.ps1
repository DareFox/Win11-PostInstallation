function Disable-Hibernation {
    Set-Itemproperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'HibernateEnabled' -Value 0 -Type DWord
}