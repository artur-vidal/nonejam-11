if(place_meeting(x + velh, y, obj_colisao)){
    var _colisao = instance_place(x + velh, y, obj_colisao)

    x = (velh > 0) ? _colisao.bbox_left + (x - bbox_right) : _colisao.bbox_right + (x - bbox_left)
    velh = 0
}

x += velh

if(place_meeting(x, y + velv, obj_colisao)){
    var _colisao = instance_place(x, y + velv, obj_colisao)

    y = (velv > 0) ? _colisao.bbox_top + (y - bbox_bottom) : _colisao.bbox_bottom + (y - bbox_top)
    velv = 0
}

y += velv