event_inherited()

open = false

action = function() {
	describe()
    if(!open){
        open = true
        audio_play_sound(snd_interact, 1, 0)
        texto = ["esse bau ja foi aberto."]
    }
}