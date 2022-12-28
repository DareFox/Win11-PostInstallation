# [Script]
# Name = Disable-Dynamic-Tick
# Description = Black magic placbeo. Can make feel game smother or not. Effect depends on hardware, current weather and your mood a.k.a RANDOM
# Requires = null
function Disable-Dynamic-Tick {
    bcdedit /set disabledynamictick yes
}