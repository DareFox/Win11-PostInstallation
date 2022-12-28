# [Script]
# Name = Scoop-Setup
# Description = Install app manager Scoop
# Requires = null
function Scoop-Setup {
    Set-ExecutionPolicy Bypass -Scope Process -Force; 
    irm get.scoop.sh | iex
}