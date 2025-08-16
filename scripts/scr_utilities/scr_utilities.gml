//// CONSTRUTORES GERAIS ////
function Counter(_array_or_ds_list) constructor{
    
    counter = {}
    
    if(is_array(_array_or_ds_list)){
        for(var i = 0; i < array_length(_array_or_ds_list); i++){
            var _cur_value = string(_array_or_ds_list[i].food_id)
            var _has_this_value = struct_exists(counter, _cur_value)
            
            if(_has_this_value) counter[$ _cur_value]++
            else struct_set(counter, _cur_value, 1)
        }
    }
    
    else if(ds_exists(_array_or_ds_list, ds_type_list)){
        for(var i = 0; i < ds_list_size(_array_or_ds_list); i++){
            var _cur_value = string(_array_or_ds_list[| i].food_id)
            var _has_this_value = struct_exists(counter, _cur_value)
            
            if(_has_this_value) counter[$ _cur_value]++
            else struct_set(counter, _cur_value, 1)
        }
    }
    
    ///@desc Retorna um array de arrays [nome da variável, contagem], organizados da contagem mais alta à mais baixa
    most_common = function(_reversed = false) {
        var _value_array = []
        var _names = struct_get_names(counter)
        
        for(var i = 0; i < array_length(_names); i++){
            var _cur_name = _names[i]
            
            // excluindo alguns nomes
            if(_cur_name != "most_common")
            array_push(_value_array, [_cur_name, counter[$ _cur_name]])
        }
        
        // organizando com um bubble sort
        var n = array_length(_value_array)
        for (var i = 0; i < n - 1; i++) {
            for (var j = 0; j < n - i - 1; j++) {
                var a = _value_array[j][1]
                var b = _value_array[j + 1][1]
                var condition = !_reversed ? (a < b) : (a > b)
                
                if (condition) {
                    var temp = _value_array[j]
                    _value_array[j] = _value_array[j + 1]
                    _value_array[j + 1] = temp
                }
            }
        }
        
        return _value_array
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

///@description Pausa ou despausa o jogo dependendo do estado atual.
//function pause(){
    //root.GAME_PAUSED = !root.GAME_PAUSED
    //if(GAME_PAUSED){
        //audio_stop_sound(snd_pause);
        //audio_play_sound(snd_pause, 1, 0);
        //GAME_SPEED = 0
        //
        //instance_create_depth(0, 0, 0, obj_pause_menu)
    //}else{
        //GAME_SPEED = 1
        //instance_destroy(obj_pause_menu)
    //}
//}