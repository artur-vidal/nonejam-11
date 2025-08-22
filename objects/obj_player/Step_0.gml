var _horizontal = keyboard_check(vk_right) - keyboard_check(vk_left)
var _vertical = keyboard_check(vk_down) - keyboard_check(vk_up)

var _left = x - 6

if((_left % tile_size == 0 and y % tile_size == 0) and control){
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

if(velh != 0 or velv != 0){
	step_sound_cd--
}

if(step_sound_cd < 0){
    audio_play_sound(snd_step, 1, 0, .8, undefined, random_range(.8, 1.2))
    step_sound_cd = 30
}

if(keyboard_check_pressed(ord("Z")) and control and (velh == 0 and velv == 0)) {
    var _interagivel = collision_circle(x - 1, y - 7, 7, obj_interagivel, false, true)
    if(_interagivel) {
        if(array_length(_interagivel.texto) > 0) create_dialogue(_interagivel.texto)
		_interagivel.action()
    }
}

if(velh != 0 or velv != 0){
	sprite.animate(4)
} else {
	sprite.image_ind = 0	
}

