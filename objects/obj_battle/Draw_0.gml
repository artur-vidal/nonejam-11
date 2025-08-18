draw_all()

if(state == BattleStates.PLAYER_TURN){
    
    // desenhando menu de opções em cima da unit
    if(selecting == 0){
        var _x = units[current_unit].x
        var _y = units[current_unit].y - 40
        
        var _spacing = 32
        
        var _prev_index = (action_selection - 1 + BattleActions.COUNT) % BattleActions.COUNT
        var _next_index = (action_selection + 1) % BattleActions.COUNT
        
        var _left_text = scribble(action_labels[_prev_index]) // esquerda
            .starting_format("fnt_default", c_white)
            .align(1, 1)
            .blend(c_white, 0.5)
        _left_text.draw(_x - _spacing, _y - 8)
        
        var _main_text = scribble(action_labels[action_selection]) // principal
            .starting_format("fnt_default", c_white)
            .align(1, 1)
            .blend(c_white, 1)
        _main_text.draw(_x, _y - wave(0, 3, 2))
        
        var _right_text = scribble(action_labels[_next_index]) // direita
            .starting_format("fnt_default", c_white)
            .align(1, 1)
            .blend(c_white, 0.5)
        _right_text.draw(_x + _spacing, _y - 8)
    }
    
    // desenhando maozinha de seleção
    if(selecting == 1){
        
        var _hand_x = enemies[current_enemy].x + 36
        var _hand_y = enemies[current_enemy].y - 16
        
        // opção selecionada
        var _selected_action = scribble(action_labels[action_selection])
            .starting_format("fnt_default", c_white)
            .align(1, 1)
        _selected_action.draw(_hand_x, _hand_y - 14 - wave(0, 3, 2))
        
        // maozinha
        draw_sprite(spr_hand_point, 0, _hand_x + wave(0, 5, 3), _hand_y)
    }
}