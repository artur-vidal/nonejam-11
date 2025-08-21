draw_sprite_stretched(spr_textbox, 0, box_x, box_y, box_width, box_height)

var _text = scribble(text[cur_page])
    .starting_format($"{font_get_name(font)}", #e0f8d0)
    .scale(.35)
    .padding(pad, pad, pad, pad)
    .wrap(120)

_text.draw(round(box_x), round(box_y), typist)