var _horizontal = keyboard_check(vk_right) - keyboard_check(vk_left)
var _vertical = keyboard_check(vk_down) - keyboard_check(vk_up)


if(((x - 6) % tile_size == 0 and y % tile_size == 0) and control){
    if(_horizontal != 0 xor _vertical != 0) {
        velh = _horizontal * max_vel
        velv = _vertical * max_vel
		
		if(_horizontal != 0) {
			sprite.xscale = -_horizontal
			sprite.change(spr_guerreiro_mini_lado)
		}
		
		if(_vertical > 0) sprite.change(spr_guerreiro_mini_frente)
		else if(_vertical < 0) sprite.change(spr_guerreiro_mini_tras)
    } else {
        velh = 0
        velv = 0
    }
}

if(keyboard_check_pressed(ord("Z")) and control and (velh == 0 and velv == 0)) {
    var _interagivel = collision_circle(x - 1, y - 7, 7, obj_interagivel, false, true)
    if(_interagivel and array_length(_interagivel.texto) > 0) {
        create_dialogue(_interagivel.texto)
		_interagivel.action()
    }
}

if(velh != 0 or velv != 0){
	sprite.animate(4)
} else {
	sprite.image_ind = 0	
}