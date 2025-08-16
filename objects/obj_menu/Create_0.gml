main_group = new MenuGroup([]) // criando grupo vazio inicialmente
current_group = main_group

activated = false

pos = 0
prev_pos = pos

draw_past_groups = true

// recursiva para manter todas as opções corretas
initialize = function(_ef_type = MenuOptionSelectionEffects.NO_EFFECT, _ef_start = 0, _ef_end = 0, _ef_duration = 0, _ef_ease = ease_linear, _array = main_group.elements, _parent = main_group){

    var _child_count = 0
    for(var i = 0; i < array_length(_array); i++){
        var _current = _array[i]
        
        // se for um array, eu transformo em um grupo e já rodo a função nos conteúdos dele
        if(is_array(_current)){
            _child_count++
            _array[i] = new MenuGroup(_current)
            _array[i].parent_group = _parent
            _array[i].parent_menu = id
            _array[i].child_num = _child_count
            initialize(_ef_type, _ef_start, _ef_end, _ef_duration, _ef_ease, _array[i].elements, _array[i])
            continue
        }
        
        // se for um grupo, eu rodo a função no elements dele
        if(is_group(_current)){
            _child_count++
            _current.parent_group = _parent
            _current.parent_menu = id
            _current.child_num = _child_count
            initialize(_ef_type, _ef_start, _ef_end, _ef_duration, _ef_ease, _current.elements, _current)
            continue
        }
        
        // finalmente, se for uma opção, eu defino as variáveis normalmente
        _current.parent_menu = id
        _current.parent_group = _parent
        _current.set_effect(_ef_type, _ef_start, _ef_end, _ef_duration, _ef_ease)
        
    }
    
}

update_all = function(){
    for(var i = 0; i < array_length(current_group.elements); i++){
        if(is_group(current_group.elements[i]))
            continue
        
        current_group.elements[i].update()
    }
}

open = function(_group){
    main_group = (is_struct(_group)) ? _group : new MenuGroup(_group)
    activated = true
    
    initialize(MenuOptionSelectionEffects.SLIDE, 0, 20, .5, ease_out_circ)
    //initialize(MenuOptionSelectionEffects.SCALE, 1, 1.25, .5, ease_out_circ)
    
    current_group = main_group
    show_debug_message(json_stringify(current_group, true))
    
    current_group.elements[pos].enter_selection()
}

close = function(){
    main_group = new MenuGroup([])
    activated = false
}    

is_group = function(_val){
    return is_struct(_val) and is_instanceof(_val, MenuGroup)
}

wrap_pos = function(){
    if(pos < 0) pos = array_length(current_group.elements) - 1
    else if(pos > array_length(current_group.elements) - 1) pos = 0
}

draw_group = function(_x, _y, _group){
    
    var _line_spacing = 5
    var _previous_line_height = 0
    var _cur_y = _y
    var _base_scale = 2
    var _is_active_group = _group == current_group
    
    for(var i = 0; i < array_length(_group.elements); i++){
    
        // desenhando o título primeiro se houver um
        if(i == 0 and _group.label != ""){
            
            scribble_anim_wheel(1, 11, .1)
            
            var _label = string_concat("[wheel]", _group.label)
            var _text = scribble(_label)
                .starting_format("fnt_menu", (_is_active_group) ? c_white : c_gray)
                .scale(_base_scale * 2/3)
            
            _text.draw(_x + _group.option_offset.x, _cur_y + _group.option_offset.y)
            
            scribble_anim_reset()
            
            _previous_line_height = _text.get_height()
            _cur_y += _line_spacing + _previous_line_height
        }
        
        var _cur_element = _group.elements[i]
        if(is_group(_cur_element)) 
            continue
        
        _cur_element.draw(_x, _cur_y, (_is_active_group) ? c_white : c_gray, (pos == i and _is_active_group) ? "[rainbow]" : "")
        
        _previous_line_height = _cur_element.get_height()
        _cur_y += _line_spacing + _previous_line_height
    }
}