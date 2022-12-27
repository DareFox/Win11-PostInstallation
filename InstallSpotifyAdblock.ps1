function Install-Spotify-Adblock {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; 
    iex "& { $((iwr -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content) } -confirm_spoti_recomended_over -podcasts_on -cache_off -block_update_off -start_spoti"
}