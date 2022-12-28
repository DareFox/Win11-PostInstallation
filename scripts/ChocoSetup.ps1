# [Script]
# Name = Choco-Setup
# Description = Install chocolatey
#
# [Dependencies] 
# Requires = null
function Choco-Setup {
    Set-ExecutionPolicy Bypass -Scope Process -Force; 
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}