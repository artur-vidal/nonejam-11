if(!out){
    cur_time = approach(cur_time, total_time, 1)
    if(cur_time == total_time) out = true
} else {
    
    cur_time = approach(cur_time, 0, 1)
    if(cur_time == 0) instance_destroy()
}

cur_alpha = cur_time / total_time
if(cur_alpha = approach(cur_alpha, round_digits(cur_alpha, 1), .1)) {
    audio_play_sound(snd_step, 1, 0, 1, undefined, 1.7)
}