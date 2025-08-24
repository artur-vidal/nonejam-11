if((other.x - 8) % 16 == 0 and other.y % 16 == 0){
    other.velh = 0
    other.velv = 0
    
    create_transition(90, function(){
		start_battle([root.guerreiro, root.mago], enemies, start_delay, music)	
	})
    instance_destroy()
}
