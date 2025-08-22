draw_rectangle(0, 0, room_width, room_height, false)

if(draw_black_overlay > 0){
    application_surface_enable(false)
    
    surface_set_target(black_overlay)
	draw_set_alpha(black_overlay_alpha)
    draw_set_color(c_black)
    draw_rectangle(0, 0, room_width, room_height, false)
    
    gpu_set_blendmode(bm_subtract)
    
} else {
    application_surface_enable(true)
}

draw_all()

if(state == BattleStates.PLAYER_TURN and array_length(available_actions) > 0){
    
    // desenhando menu de opções em cima da unit
    if(selecting == BattleSelectionModes.ACTIONS){
        var _x = units[current_unit].draw_x
        var _y = units[current_unit].draw_y - 20 - wave(0, 3, 3)
        
        var _text = scribble(action_labels[available_actions[action_selection]])
                .starting_format("fnt_default", #081820)
                .align(1, 1)
                .scale(.25)
                
        _text.draw(_x, _y - 4)
        
        var _arrow_spacing = 2
        var _arrow_scale = .3
        
        // desenhando setinhas
        draw_sprite_ext(spr_action_arrow, 0, _x + _text.get_width() / 2 + _arrow_spacing, _y - 4,
        _arrow_scale, _arrow_scale, 0, c_white, 1)
        
        draw_sprite_ext(spr_action_arrow, 0, _x - _text.get_width() / 2 - _arrow_spacing, _y - 4,
        -_arrow_scale, _arrow_scale, 0, c_white, 1)
    }
    
    // desenhando maozinha de seleção
    var _hand_x, _hand_y
    switch (selecting) {
        case BattleSelectionModes.UNITS:
            _hand_x = units[selected_entity].x + units[selected_entity].offset.x + 18
            _hand_y = units[selected_entity].y + units[selected_entity].offset.y - 12
            break;
        case BattleSelectionModes.ENEMIES:
            _hand_x = enemies[selected_entity].x + enemies[selected_entity].offset.x + 18
            _hand_y = enemies[selected_entity].y + enemies[selected_entity].offset.y - 12
            break;
        default:
            _hand_x = -100
            _hand_y = -100
            break;
    }
    
    // opção selecionada
    var _selected_action = scribble(action_labels[available_actions[action_selection]])
        .starting_format("fnt_default", #081820)
        .align(1, 1)
        .scale(.3)
    
    _selected_action.draw(_hand_x, _hand_y - 10 - wave(0, 3, 2))
    
    // maozinha
    draw_sprite(spr_hand_point, 0, _hand_x + wave(0, 5, 3), _hand_y)
    
}

if(draw_black_overlay > 0){
	gpu_set_blendmode(bm_normal)
	draw_set_color(c_white)
	draw_set_alpha(1)
	surface_reset_target()
    
    draw_surface(black_overlay, 0, 0)
}