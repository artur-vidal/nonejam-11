anim.run()

relative_current_time += RELATIVE_DT * 1000

dialogue_create_cooldown = approach(dialogue_create_cooldown, 0, 1)

if(room == rm_game and mouse_check_button_pressed(mb_left)){
    instance_create_depth(0, 0, -999, obj_transicao)
}