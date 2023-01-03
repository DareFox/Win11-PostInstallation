# [Script]
# Name = OpenSSH-Client-Setup
# Description = Install OpenSSH client and configure it
# Requires = null
function OpenSSH-Client-Setup {
    # Install the OpenSSH Client
    Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
}