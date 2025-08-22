function Sprite(_asset) constructor{
    sprite = _asset
    image_ind = 0
    image_spd = 1
    
    xscale = 1
    yscale = 1
    color = c_white
    rotation = 0
    alpha = 1
    
    offset = {
        x : 0,
        y : 0
    }
    
    flash_time = 60
    flash_cooldown = 0
    
    change = function(_new_asset){
		if(sprite != _new_asset){
	        sprite = _new_asset
	        image_ind = 0
		}
    }
    
    animate = function(_fps){
        
    	// Pegando quantos frames minha sprite atual tem
    	var _image_num = sprite_get_number(sprite)
    	
    	//Aumentando o valor do index com base na velocidade
        var _add = _fps * image_spd * RELATIVE_DT
    	image_ind += _add
    	
        // Rodando script de fim de animação quando ela acabar
        if(image_ind + _add > _image_num) {
            image_ind = 0
            on_animation_end()
        }
    }
    
    on_animation_end = function() {
        
    }
    
    draw = function(x, y){
        if(sprite != noone){
            draw_sprite_ext(sprite, image_ind, x + offset.x, y + offset.y, xscale, yscale, rotation, color, alpha)
        }
    }
}

//// FUNÇÕES ////

///@desc Retorna se o jogo está ou não pausado. Estar com velocidade 0 já conta
function is_paused(){
    return root.GAME_PAUSED or root.GAME_SPEED == 0
}

///@desc Interpolação linear para ângulos.
function lerp_direction(start, final, vel) {
    var _max, _da, _result;
    _max = 360;
    _da = (final - start) % _max;
    _result = 2 * _da % _max - _da;

    return start + _result * vel;
}

///@description Returns a value that will wave back and forth between [from-to] over [duration] seconds
function wave(_min, _max, _duration, _offset = 0){
    var a4 = (_max - _min) * 0.5;
    var angle = ((root.relative_current_time * 0.001) / _duration) * (pi * 2);
    angle += _offset * (pi * 2); // deslocamento de fase
    return _min + a4 + sin(angle) * a4;
}

function round_digits(_n, _digits){
    var value = _n;
    var dec = _digits;
    
    var mult = power(10, dec);
    return floor(value*mult)/mult;
}

function game_start() {
    audio_play_sound(msc_tension_min, 1, 1)
    room_goto(rm_game)
}

function create_indicator(_x, _y, _val){
    instance_create_depth(_x, _y, -100, obj_number_indicator).val = _val
}

function create_dialogue(_text_array, _sound = snd_text_mid, _pitch_min = 1, _pitch_max = 1, _font = fnt_default){
	if(root.dialogue_create_cooldown > 0 or instance_exists(obj_ow_dialogue)){
		return
	}
	
    var _box = instance_create_depth(0, 0, -100, obj_ow_dialogue)
    _box.text = _text_array
    _box.font = _font
    _box.sound = _sound
    _box.pitch_min = _pitch_min
    _box.pitch_max = _pitch_max
}