if(delay_start == 0) apply_start_anim()
delay_start--

if(!audio_is_playing(music) and !ending and state != BattleStates.GAME_OVER){
    // parando todas as musicas pra tocar essa
	audio_stop_sound(msc_battle)
	audio_stop_sound(msc_boss_1)
	audio_stop_sound(msc_dungeon)
	audio_stop_sound(msc_final_boss_loop)
	audio_stop_sound(msc_tension_max)
	audio_stop_sound(msc_tension_mid)
	audio_stop_sound(msc_tension_min)
	
    if(root.first_battle or music != msc_battle){
        audio_play_sound(music, 1, 1, .85)
    } else {
        audio_play_sound(music, 1, 1, .85, 10.14)
    }
}

switch(state) {
    case BattleStates.PLAYER_TURN: state_player(); break;
    case BattleStates.PLAYER_ACT: state_player_actions(); break;
    case BattleStates.ENEMY_ATTACKING: state_enemy_attacks(); break;
	case BattleStates.END: state_end(); break;
	case BattleStates.GAME_OVER: state_game_over(); break;
}

draw_black_overlay = approach(draw_black_overlay, 0, 1)

if(particle_time > 0){
    part_emitter_burst(root.part_sys, pem, pt, 1)
}
particle_time = approach(particle_time, 0, 1)

// manipulando cards
// subindo e descendo
for(var i = 0; i < array_length(cards); i++){
    if(state == BattleStates.PLAYER_TURN and i == current_unit){
        cards[i].offset.y = lerp(cards[i].offset.y, -16, 0.2)
        cards[i].resumo = false
    }else if(state != BattleStates.END){
        cards[i].offset.y = lerp(cards[i].offset.y, 0, 0.2)
        cards[i].resumo = true
    }else{
        cards[i].offset.y = lerp(cards[i].offset.y, 30, 0.2)
        cards[i].resumo = true
    }
}

if(!surface_exists(black_overlay)) black_overlay = surface_create(320, 240)