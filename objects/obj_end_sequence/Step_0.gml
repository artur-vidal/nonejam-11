timer--
if(timer <= 0){
    time = clamp(time - .5, 4, time)
    timer = ceil(time)
    
    explosions--
    
    audio_stop_sound(snd_explosion)
    instance_create_depth(irandom_range(70, 170), irandom_range(10, 100), -1000, obj_explosion)
    obj_camera.turn_shake_on(10, 1)
}

if(explosions <= 0){
    started_ending = true
}

if(started_ending){
    white_alpha = approach(white_alpha, 2, 0.008)
    if(white_alpha == 2) {
        audio_stop_all()
        room_goto(rm_start)
    }
}