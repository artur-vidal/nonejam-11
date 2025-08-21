anim.run()

relative_current_time += RELATIVE_DT * 1000

if(room == rm_game and mouse_check_button_pressed(mb_left) and !instance_exists(obj_ow_dialogue)){
    var _txt = [
        "Dialogo teste.",
        "bLABLABLA. Ola, que doido. None Jam 11? Nao da nem pra contar com as duas maos.",
        "bora bora bora brasil :fogo::fogo::fogo:"
    ]
    
    create_dialogue(_txt)
}