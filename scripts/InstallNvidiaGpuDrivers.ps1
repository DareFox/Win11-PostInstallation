# [Script]
# Name = Install-Nvidia-Gpu-Drivers
# Description = Install Nvidia Drivers
# Requires = Choco-Setup
function Install-Nvidia-Gpu-Drivers {
    choco install nvidia-display-driver -y
}