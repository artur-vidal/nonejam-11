if((other.x - 8) % 16 == 0 and other.y % 16 == 0){
    other.velh = 0
    other.velv = 0
    
    on_start()
    create_dialogue(text, create_dialogue(text, dir, on_dialogue_end), sound)
    instance_destroy()
}
