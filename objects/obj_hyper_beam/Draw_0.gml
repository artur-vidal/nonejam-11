// draw
for (var i = head; i < circles; i++) {
    
    // definindo cor baseado no circulo atual
    var _colors = [(#e0f8d0), #88c070, #346856] // a primeira tem q ficar em parentese, GM é imbecil
    var _third = max_circles / 3
    
    var _circle_c = c_aqua // cor bem forte pra eu saber quando deu errado
    if(i > floor(_third * 2)){
        _circle_c = _colors[2]
    } else if (i == clamp(i, floor(_third), floor(_third * 2))) {
        _circle_c = _colors[1]
    } else {
        _circle_c = _colors[0]
    }
    
    var _dist = i * 5;
    
    // posição base seguindo direção
    var bx = x + lengthdir_x(_dist, dir);
    var by = y + lengthdir_y(_dist, dir);
    
    // onda em Y perpendicular à direção
    var ox = lengthdir_x(1, dir + 90); // eixo perpendicular
    var oy = lengthdir_y(1, dir + 90);
    
    // deslocamento da onda
    var off = wave(amplitude, -amplitude, b_speed, .15 * i);
    
    // desenha as duas bolinhas
    draw_set_color(_circle_c)
    draw_circle(bx + ox * off, by + oy * off, 2, false);
    draw_circle(bx - ox * off, by - oy * off, 2, false);
    draw_set_color(c_white)
}
