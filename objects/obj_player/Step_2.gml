if(place_meeting(x + velh, y, obj_colisao)){
    var _colisao = instance_place(x + velh, y, obj_colisao)
    
    if(velh > 0){
        x = _colisao.bbox_left + (x - bbox_right)
    } else if (velh < 0){
        x = _colisao.bbox_right + (x - bbox_left)
    }
    velh = 0
}

x += velh

if(place_meeting(x, y + velv, obj_colisao)){
    var _colisao = instance_place(x, y + velv, obj_colisao)
    
    if(velv > 0){
        y = _colisao.bbox_top + (y - bbox_bottom)
    } else if (velv < 0){
        y = _colisao.bbox_bottom + (y - bbox_top)
    }
    velv = 0
}

y += velv