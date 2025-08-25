var _cur_text = string_copy(text[cur_page], 1, typist.get_position())
var _cur_char = string_char_at(text[cur_page], typist.get_position())

if(_cur_text != prev_text and !array_contains([" ", ".", ",", ":", "!", "?"], _cur_char)){
    var _snd = sound
    
    if(string_starts_with(text[cur_page], "O Cavaleiro")) _snd = snd_text_low
    else if(string_starts_with(text[cur_page], "Meg, a maga") or string_starts_with(text[cur_page], "Meg")) _snd = snd_text_high
    audio_stop_sound(_snd)
    audio_play_sound(_snd, 1, 0, .8, undefined, random_range(pitch_min, pitch_max))
}

prev_text = string_copy(text[cur_page], 1, typist.get_position())

if(keyboard_check_pressed(ord("Z")) and !appearing){
    if(typist.get_state() < 1){
        typist.skip()
    }else{
        pass_text()
    }
}