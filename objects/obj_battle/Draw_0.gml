draw_all()

if(state == BattleStates.PLAYER_TURN){
    
    // desenhando menu de opções em cima da unit
    if(selecting == BattleSelectionModes.ACTIONS){
        var _x = units[current_unit].x + units[current_unit].offset.x
        var _y = units[current_unit].y + units[current_unit].offset.y - 20
        
        var _spacing = 20
        
        var _prev_index = (action_selection - 1 + BattleActions.COUNT) % BattleActions.COUNT
        var _next_index = (action_selection + 1) % BattleActions.COUNT
        
        var _left_text = scribble(action_labels[_prev_index])
                .starting_format("fnt_default", #081820)
                .align(1, 1)
                .blend(c_white, .4)
                .scale(.25)
                
        _left_text.draw(_x - _spacing, _y - 4)
        
        var _mid_text = scribble(action_labels[action_selection])
                .starting_format("fnt_default", #081820)
                .align(1, 1)
                .blend(c_white, 1)
                .scale(.25)
                
        _mid_text.draw(_x, _y)
        
        var _right_text = scribble(action_labels[_next_index])
                .starting_format("fnt_default", #081820)
                .align(1, 1)
                .blend(c_white, .4)
                .scale(.25)
                
        _right_text.draw(_x + _spacing, _y - 4)
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
    var _selected_action = scribble(action_labels[action_selection])
        .starting_format("fnt_default", #081820)
        .align(1, 1)
        .scale(.3)
    
    _selected_action.draw(_hand_x, _hand_y - 10 - wave(0, 3, 2))
    
    // maozinha
    draw_sprite(spr_hand_point, 0, _hand_x + wave(0, 5, 3), _hand_y)
    
}