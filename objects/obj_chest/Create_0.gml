event_inherited()

open = false
trigger_link = noone

action = function() {
	describe()
    array_push(root.guerreiro.available_actions, BattleActions.CHARGE)
    array_push(root.mago.available_actions, BattleActions.HEAL)
    if(trigger_link != noone) {
        instance_destroy(trigger_link)
    }
        
    if(!open){
        open = true
        audio_play_sound(snd_interact, 1, 0)
        texto = ["esse bau ja foi aberto."]
    }
}