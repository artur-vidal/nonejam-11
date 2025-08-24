switch(state){
    case 0:
        start_timer--
        if(start_timer < 0){
            switch(start_step){
                case 0: start_step++; start_timer = start_time * 3; break
                case 1: start_step++; start_timer = start_time; break
                case 2: 
                    state = 1; 
                    audio_sound_gain(msc_start, 0, 0); 
                    audio_play_sound(msc_start, 1, 1); 
                    audio_sound_gain(msc_start, 1, 5000); 
                    break
            }
        }
        break
    case 1:
        title_alpha = approach(title_alpha, 1, 0.01)
        
        var _change = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up)
        pos += _change
        if(pos > array_length(options) - 1) pos = 0
        else if(pos < 0) pos = array_length(options) - 1
        
        if(_change != 0){
            audio_stop_sound(snd_blip)
            audio_play_sound(snd_blip, 1, 0, .5, undefined, 1.5)
        }
        
        if(keyboard_check_pressed(ord("Z"))) {
            switch(pos){
                case 0:
                    times_ng_clicked++
                    play_wrong_sound()
                    break
                case 1:
                    state++
                    audio_stop_all()
                    create_transition(120, function(){
                        room_goto(rm_game)
                        audio_play_sound(msc_tension_min, 1, 1)
                    },
                    function(){
                        create_dialogue([
                            "Gui, o guerreiro: ...",
                            "Meg, a maga: Gui! Voce está bem?",
                            "Gui, o guerreiro: To... confuso. Onde a gente ta? Por que tudo ta verde?",
                            "Meg, a maga: Eu estou tão confusa quanto voce. Vamos explorar.",
                            "Gui, o guerreiro: Que lugar esquisito..."
                        ])
                    })
                    break
            }
        }
    
        break
}