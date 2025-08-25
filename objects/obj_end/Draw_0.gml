draw_rectangle(0, 0, room_width, room_height, false)

scribble_anim_wave(1, 11, .05)

var _end_text = scribble(texto_fim)
    .starting_format("fnt_menu", c_black)
    .align(1, 1)
    .scale(.75)
    .wrap(room_width - 20)
_end_text.draw(room_width / 2, 60)

var _agrad_text = scribble(texto_agradecimento)
    .starting_format("fnt_menu", c_black)
    .scale(.5)
    .wrap(room_width - 15)
_agrad_text.draw(10, room_height - 75)

scribble_anim_reset()

// sprites
gui.sprite.draw(gui.x, gui.y + wave(-6, 6, 4))
meg.sprite.draw(meg.x - 64, meg.y + wave(6, -6, 4))
cav.sprite.draw(meg.x - 128, meg.y + wave(6, -6, 2))

draw_set_alpha(white_alpha)
draw_rectangle(0, 0, room_width, room_height, false)
draw_set_alpha(1)