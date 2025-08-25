event_inherited()

open = false
trigger_links = -1

action = function() {
	describe()
    
    if(!open){
        if(trigger_link != noone) {
            array_foreach(trigger_link, function(_el, _ind){instance_destroy(_el)})
        }
        
        open = true
        audio_play_sound(snd_interact, 1, 0)
        array_push(root.guerreiro.available_actions, BattleActions.CHARGE)
        array_push(root.mago.available_actions, BattleActions.HEAL)
        texto = ["esse bau ja foi aberto."]
    }
}