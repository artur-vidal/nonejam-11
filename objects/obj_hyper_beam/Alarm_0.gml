if (circles < max_circles) {
    circles++
} else {
    head++;    // cortando do início
    if (head > max_circles) {
        instance_destroy()
    }
}

audio_play_sound(snd_beam, 1, 0, .6, undefined, .75)
alarm[0] = frame_interval;
