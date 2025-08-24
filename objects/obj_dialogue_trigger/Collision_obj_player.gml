if((other.x - 8) % 16 == 0 and other.y % 16 == 0){
    other.velh = 0
    other.velv = 0
    
    create_dialogue(text)
    instance_destroy()
}
