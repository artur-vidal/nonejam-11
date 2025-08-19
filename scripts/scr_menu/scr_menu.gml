enum MenuOptionSelectionEffects{
    NO_EFFECT,
    SLIDE,
    SCALE,
    COUNT
}

enum MenuOptionIconEffects{
    NO_EFFECT,
    SIDEWAYS,
    UP_DOWN,
    ROTATE,
    COUNT
}

function MenuGroup(_elements, _label = "") constructor{
    static group_id = 0
    group_id++
    
    label = _label
    
    elements = _elements
    
    parent_group = -1
    parent_menu = -1
    child_num = -1
    
    option_offset = {x : 0, y : 0}
    effect_tag = $"menu_group_id:{group_id}_effect"
    
    parent_count = function(){
        if(parent_group = -1) return 0
            
        var _count = 0
        var _continue = true
        var _reading = parent_group
        while(_continue){
            if(_reading.parent_group == -1) _continue = false
            
            _count++
            _reading = _reading.parent_group
        }
        
        return _count
    }
    
    get_max_option_width = function(){
        
    }
}

function MenuOption(_label, _action = -1, _args = -1) constructor{
    static option_id = 0
    option_id++
    
    label = _label
    action = _action
    preset = ""
    arg_array = _args ?? []
    if(!is_array(arg_array)) arg_array = [arg_array]
    value = 0
    
    parent_menu = -1
    parent_group = -1
    
    base_draw_scale = 2
    
    effect = {
        type : MenuOptionSelectionEffects.NO_EFFECT,
        duration : 0,
        min : 0,
        max : 0,
        current : 0,
        ease : ease_linear,
        tag : $"menu_option_id:{option_id}_effect"
    }
    
    offset = {
        x : 0,
        y : 0
    }
    
    icon = {
        sprite : -1,
        effect : MenuOptionIconEffects.NO_EFFECT,
        offset : {
            x : 0,
            y : 12
        }
    }
    
    update = function(){
        
        var _key = keyboard_check_pressed(vk_space)
        var _is_on_me = parent_menu.current_group.elements[parent_menu.pos] == self
        
        // procurando ações presetadas
        if(!is_callable(action)){
            switch(action){
                case "chmenu":
                    preset = "chmenu"
                    action = change_submenu
                    icon.sprite = spr_menu_arrow
                    icon.effect = MenuOptionIconEffects.SIDEWAYS
                    icon.offset.x = 10
                    break
                case "bkmenu":
                    preset = "bkmenu"
                    action = change_submenu
                    arg_array = [parent_menu.current_group.parent_group, false] // linha bizarra
                    break
            }
        }
        
        // rodando depois de pegar o preset (ou se já era uma função predefinida)
        if(is_callable(action) and _key and _is_on_me) script_execute_ext(action, arg_array)
    }
    
    enter_selection = function(){
        root.anim.cancel(effect.tag)
        root.anim.add(
            new Animation(self.effect, "current", effect.min, effect.max, effect.duration)
                .tag(effect.tag)
                .ease(effect.ease)
        )
    }
    
    quit_selection = function(){
        root.anim.cancel(effect.tag)
        root.anim.add(
            new Animation(self.effect, "current", effect.max, effect.min, effect.duration)
                .tag(effect.tag)
                .ease(effect.ease)
        )
    }
    
    set_effect = function(type, start, finish, duration, ease){
        effect.type = type
        effect.min = start
        effect.max = finish
        effect.duration = duration
        effect.ease = ease
        effect.current = effect.min
    }
    
    // funçoes getter para uso externo
    get_width = function(){
        var _txt_scale = (effect.type == MenuOptionSelectionEffects.SCALE ? base_draw_scale * effect.current : base_draw_scale)
        return scribble(label).scale(_txt_scale).get_width()
    }
    
    get_height = function(){
        var _txt_scale = (effect.type == MenuOptionSelectionEffects.SCALE ? base_draw_scale * effect.current : base_draw_scale)
        return scribble(label).scale(_txt_scale).get_height()
    }
    
    draw_label = function(_labelx, _labely, _color, _scale, _scribble_effects){
        
        // desenhando texto
        scribble_anim_rainbow(.8, -.01)
        scribble_anim_wheel(1, 11, .1)
        
        var _final_string = string_concat("[wheel]", _scribble_effects, label)
        var _text = scribble(_final_string)
            .starting_format("fnt_menu", _color)
            .scale(_scale)
        
        _text.draw(
            _labelx + parent_group.option_offset.x + offset.x, 
            _labely + parent_group.option_offset.y + offset.y
        )
        
        scribble_anim_reset()
    }
    
    draw_icon = function(_iconx, _icony, _index, _scale, _color){
        
        var _x = _iconx + parent_group.option_offset.x + offset.x + icon.offset.x
        var _y = _icony + parent_group.option_offset.y + offset.y + icon.offset.y
        
        draw_sprite_ext(icon.sprite, _index, _x, _y, _scale, _scale, 0, _color, 1)
    }
    
    draw = function(_x, _y, _color, _scribble_effects = ""){
        
        // definindo alguns valores baseadas no efeito da opção
        var _slidex = 0, _scale = 1
        switch(effect.type){
            case MenuOptionSelectionEffects.SLIDE:
                _slidex = effect.current
                break
            case MenuOptionSelectionEffects.SCALE:
                _scale = effect.current
                break
        }
        
        var _final_scale = base_draw_scale * _scale
        
        draw_label(_x + _slidex, _y, _color, _final_scale, _scribble_effects)
        
        // desenhando ícones
        var _wavex = 0
        var _wavey = 0
        switch(icon.effect){
            case MenuOptionIconEffects.SIDEWAYS:
                var _wavex = wave(-1 * _final_scale, 1 * _final_scale * 2, 1.2)
                break
            case MenuOptionIconEffects.UP_DOWN:
                var _wavey = wave(-1 * _final_scale, 1 * _final_scale * 2, 1.2)
                break
            case MenuOptionIconEffects.ROTATE:
                var _wavex = wave(-1 * _final_scale, 1 * _final_scale, 0.9)
                var _wavey = wave(-1 * _final_scale, 1 * _final_scale, 0.9, 0.25)
                break
        }
        
        
        if(icon.sprite != -1){
            var _index = 0
            if(is_instanceof(self, MenuCheckbox)) _index = value
            
            var _iconx = _x + _wavex + _slidex + get_width() + (6 * _final_scale)
            var _icony = _y + _wavey
            
            draw_icon(_iconx, _icony, _index, _final_scale, _color)
        }
    }
    
    // ações
    change_submenu = function(_submenu_or_childnum, _forward = true){
        
        var _submenu_struct = -1
        
        with(parent_menu){
            
            // executando passos finais logo se for uma struct
            if(is_struct(_submenu_or_childnum)){
                _submenu_struct = _submenu_or_childnum
            }else{
                var _found_submenu = -1
                for(var i = 0; i < array_length(current_group.elements); i++){
                    if(!is_group(current_group.elements[i]))
                        continue
                    
                    if(current_group.elements[i].child_num == _submenu_or_childnum){
                        _found_submenu = current_group.elements[i]
                        break
                    }
                }
                
                if(_found_submenu != -1){
                    _submenu_struct = _found_submenu
                }
            }
            
            current_group = _submenu_struct
            pos = 0
            
            if(draw_past_groups and _forward){
                root.anim.cancel(_submenu_struct.effect_tag)
                root.anim.add(
                    new Animation(_submenu_struct.option_offset, "x", -600 - 400 * other.parent_group.parent_count(), 0, 1)
                        .ease(ease_out_quint)
                        .tag(_submenu_struct.effect_tag)
                )
            }
            
            current_group.elements[pos].enter_selection()
        }
        
        audio_play_sound((_forward) ? snd_menu_forward : snd_menu_back, 1, 0)
        quit_selection()
    }
}

function MenuCheckbox(_label) : MenuOption("", -1, -1) constructor{
    label = _label
    value = false
    icon.sprite = spr_menu_check
    icon.effect = MenuOptionIconEffects.ROTATE
    
    update = function(){
        var _key = keyboard_check_pressed(vk_space)
        var _is_on_me = parent_menu.current_group.elements[parent_menu.pos] == self
        
        if(_key and _is_on_me){
            value = !value
            audio_stop_sound(snd_menu_switch)
            audio_play_sound(snd_menu_switch, 1, 0, 1, undefined, (value) ? 1 : .6)
        }
    }
}

function MenuSelection(_label, _option_array, _wrap = false) : MenuOption("", -1, -1) constructor{
    label = _label
    options = _option_array
    index = 0
    icon_label = options[index]
    
    wrap_options = _wrap
    
    icon.sprite = spr_menu_option_select_arrow
    icon.effect = MenuOptionIconEffects.UP_DOWN
    
    set_index = function(_ind){
        index = _ind
        value = options[_ind]
        icon_label = string(options[_ind])
    }
    
    on_change = function() {
        
    }
    
    update = function(){
        var _change = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left)
        var _is_on_me = parent_menu.current_group.elements[parent_menu.pos] == self
        var _changed = index // checada posteriormente para saber se mudou ou não    
        
        if(_is_on_me){
            if(wrap_options){
                index += _change
                if(index > array_length(options) - 1) index = 0
                else if(index < 0) index = array_length(options) - 1
            }else{
                index = clamp(index + _change, 0, array_length(options) - 1)
            }
            
            icon_label = options[index]
            _changed = index != _changed
            
            if(_change != 0){
                on_change()
                
                audio_stop_sound(snd_menu_switch)
                audio_play_sound(snd_menu_switch, 1, 0, 1, undefined, .7) 
            }
        }
        
        value = options[index]
    }
    
    draw = function(_x, _y, _color, _scribble_effects = ""){
        
        // definindo alguns valores baseadas no efeito da opção
        var _slidex = 0, _scale = 1
        switch(effect.type){
            case MenuOptionSelectionEffects.SLIDE:
                _slidex = effect.current
                break
            case MenuOptionSelectionEffects.SCALE:
                _scale = effect.current
                break
        }
        
        var _final_scale = base_draw_scale * _scale
        
        draw_label(_x + _slidex, _y, _color, _final_scale, _scribble_effects)
        
        // desenhando ícones
        var _wavex = 0
        var _wavey = 0
        switch(icon.effect){
            case MenuOptionIconEffects.SIDEWAYS:
                var _wavex = wave(-1 * _final_scale, 1 * _final_scale * 2, 1.2)
                break
            case MenuOptionIconEffects.UP_DOWN:
                var _wavey = wave(-1 * _final_scale, 1 * _final_scale * 2, 1.2)
                break
            case MenuOptionIconEffects.ROTATE:
                var _wavex = wave(-1 * _final_scale, 1 * _final_scale, 0.9)
                var _wavey = wave(-1 * _final_scale, 1 * _final_scale, 0.9, 0.25)
                break
        }
        
        
        if(icon.sprite != -1){
            var _index = 0
            if(is_instanceof(self, MenuCheckbox)) _index = value
            
            var _iconx = _x + _wavex + _slidex + get_width() + (6 * _final_scale)
            var _icony = _y + _wavey
            
            draw_icon(_iconx, _icony, _index, _final_scale, _color)
        }
    }
    
    draw_icon = function(_iconx, _icony, _index, _scale, _color){
        
        var _x = _iconx + parent_group.option_offset.x + offset.x + icon.offset.x + (4 * _scale)
        var _y = _icony + parent_group.option_offset.y + offset.y + icon.offset.y
        
        // seta esquerda
        // diminuindo saturação se as opções tiverem acabado
        var _left_color = _color
        if(!wrap_options and index = 0){
            _left_color = make_color_hsv(
                color_get_hue(_color),
                color_get_saturation(_color),
                color_get_value(_color) / 2
            )
        }
        
        draw_sprite_ext(icon.sprite, _index, _x, _y + (8 * _scale), -_scale, _scale, 0, _left_color, 1)
        
        // opção selecionada
        var _text = scribble(string_concat("[wheel]", icon_label))
            .starting_format("fnt_menu", _color)
            .scale(_scale)
        _text.draw(_x + (8 * _scale), _y - 10)
        
        // seta direita
        // diminuindo saturação se as opções tiverem acabado
        var _right_color = _color
        if(!wrap_options and index = array_length(options) - 1){
            _right_color = make_color_hsv(
                color_get_hue(_color),
                color_get_saturation(_color),
                color_get_value(_color) / 2
            )
        }
        
        draw_sprite_ext(icon.sprite, _index, _x + _text.get_width() + (16 * _scale), _y + (8 * _scale), _scale, _scale, 0, _right_color, 1)
    }
}

function create_menu(groups){
    var _menu = (!instance_exists(obj_menu)) ? instance_create_depth(0, 0, -9999, obj_menu) : instance_find(obj_menu, 0)
    _menu.open(groups)
}