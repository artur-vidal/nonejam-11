if(place_meeting(x, y, obj_player) and keyboard_check_pressed(ord("Z")) and door != noone and !used){
    door.open = !door.open
    used = true
    if(!audio_is_playing(snd_switch)) audio_play_sound(snd_switch, 1, 0)
}