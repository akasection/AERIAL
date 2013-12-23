soundcontrol = {}


function soundcontrol:init()
    --audiolist
    local a = love.audio
    bgm_main = a.newSource("bgm/Waveform.ogg")
    sound_click = a.newSource("sound/sp.wav", "static")
    sound_move = a.newSource("sound/move.wav", "static")
    sound_select = a.newSource("sound/select.wav", "static")
    sound_fail_menu = a.newSource("sound/fail_menu.wav", "static")
    sound_menu = a.newSource("sound/menu.wav", "static" )
    
    -- audio configuration
    bgm_main:setLooping(true)
	bgm_main:setVolume(0.64)
	sound_click:setVolume(1.00)
	sound_move:setVolume(1.00)
	sound_menu:setVolume(1.00)
	sound_select:setVolume(1.00)
	
	
end