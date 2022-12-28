# [Script]
# Name = Install-Spotify-Adblock
# Description = Install Spotify with adblock

# [Dependencies] 
# Requires = null
function Install-Spotify-Adblock {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; 
    Invoke-Expression "& { $((Invoke-WebRequest -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content) } -confirm_spoti_recomended_over -podcasts_on -cache_off -block_update_off -start_spoti"
}