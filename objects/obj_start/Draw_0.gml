switch(state){
    case 0:
        draw_sprite_stretched(spr_intro, 0, 0, 0, room_width + 1, room_height + 1)
        
        switch(start_step){
            case 0:
                draw_set_alpha(start_timer / start_time)
                draw_rectangle(0, 0, room_width, room_height, false)
                draw_set_alpha(1)
                break
            case 2:
                draw_set_alpha((start_time - start_timer) / start_time)
                draw_rectangle(0, 0, room_width, room_height, false)
                draw_set_alpha(1)
                break
        } 
        break
    case 1:
        
        // titulo
        scribble_anim_wave(1, 12, .03)
        var _title = scribble($"[wave]{title_text}")
            .starting_format("fnt_menu", c_white)
            .blend(c_black, title_alpha)
            .align(2, 2)
            .padding(10, 10, 10, 10)
        
        _title.draw(room_width, room_height - 10)
        
        // linha
        draw_set_color(c_black)
        draw_set_alpha(title_alpha)
        draw_line_width(room_width - _title.get_width(), room_height - 18, room_width - 5, room_height - 18, 2)
        draw_set_alpha(1)
        
        // opcoes
        for(var i = 0; i < array_length(options); i++){
            
            var _off = (i == pos) ? 8 : 0
            var _wave_effect = (i == pos) ? "[wave]" : ""
            var _alpha = (i == 0) ? title_alpha / 2 : title_alpha
            
            var _cur_option = scribble(_wave_effect + options[i])
                .starting_format("fnt_menu", c_white)
                .blend(c_black, _alpha)
                .scale(.75)
            
            _cur_option.draw(10 + _off,  10 + i * 20)
        }
        
        // resetando
        draw_set_color(c_white)
    
    scribble_anim_reset()
} 