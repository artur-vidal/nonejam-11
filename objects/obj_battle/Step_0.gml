if(delay_start == 0) apply_start_anim()
delay_start--

if(!audio_is_playing(music)){
    // parando todas as musicas pra tocar essa
	audio_stop_sound(msc_battle)
	audio_stop_sound(msc_boss_1)
	audio_stop_sound(msc_dungeon)
	audio_stop_sound(msc_final_boss_loop)
	audio_stop_sound(msc_tension_max)
	audio_stop_sound(msc_tension_mid)
	audio_stop_sound(msc_tension_min)
	
    if(root.first_battle){
        audio_play_sound(msc_battle, 1, 1, .7)
    } else {
        audio_play_sound(msc_battle, 1, 1, .7, 10.14)
    }
}

switch(state) {
    case BattleStates.PLAYER_TURN: state_player(); break;
    case BattleStates.PLAYER_ACT: state_player_actions(); break;
    case BattleStates.ENEMY_ATTACKING: state_enemy_attacks(); break;
	case BattleStates.END: state_end(); break;
}

draw_black_overlay = approach(draw_black_overlay, 0, 1)