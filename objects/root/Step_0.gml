anim.run()

relative_current_time += RELATIVE_DT * 1000

dialogue_create_cooldown = approach(dialogue_create_cooldown, 0, 1)

if(room == rm_game and !instance_exists(obj_battle) and mouse_check_button_pressed(mb_left)){
    create_transition(2, function(){
		start_battle([guerreiro, mago], [new Dino()], 30)	
	})
}