if(!activated) exit

var _up = keyboard_check_pressed(vk_up)
var _down = keyboard_check_pressed(vk_down)
var _action = keyboard_check_pressed(vk_space)

var _change = _down - _up

pos += _change
wrap_pos()

var _cur_element = current_group.elements[pos]

// fazendo verificação para pular grupos
while(is_group(_cur_element) and _change != 0){
    pos += _change
    wrap_pos()
    _cur_element = current_group.elements[pos]
}
    
// fazendo algumas coisas se houve mudança
if(_change != 0){
    
    _cur_element.enter_selection()
    current_group.elements[prev_pos].quit_selection()
    
    var _offrange = .2
    audio_play_sound(snd_menu_change, 1, 0, 1, undefined, random_range(1 - _offrange, 1 + _offrange))
}

// rodando update em todas as opções
for(var i = 0; i < array_length(current_group.elements); i++){
    var _current = current_group.elements[i]
    if(is_group(_current))
        continue
    
    _current.update()
}

if(mouse_check_button_pressed(mb_left)){
    // show_debug_message(json_stringify(current_group, true))
}


prev_pos = pos