anim.run()

relative_current_time += RELATIVE_DT * 1000

if(room == rm_game and mouse_check_button_pressed(mb_left) and !instance_exists(obj_ow_dialogue)){
    instance_create_depth(0, 0, 0, obj_ow_dialogue)
}