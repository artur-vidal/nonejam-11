switch(state){
    case 0:
        start_timer--
        if(start_timer < 0){
            switch(start_step){
                case 0: start_step++; start_timer = start_time * 3; break
                case 1: start_step++; start_timer = start_time; break
                case 2: 
                    state = 1; 
                    audio_sound_gain(msc_start, 0, 0); 
                    audio_play_sound(msc_start, 1, 1); 
                    audio_sound_gain(msc_start, 1, 5000); 
                    break
            }
        }
        break
    case 1:
        title_alpha = approach(title_alpha, 1, 0.003)
        
        var _change = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up)
        pos += _change
        if(pos > array_length(options) - 1) pos = 0
        else if(pos < 0) pos = array_length(options) - 1
        
        if(_change != 0){
            audio_stop_sound(snd_blip)
            audio_play_sound(snd_blip, 1, 0, .5, undefined, 1.5)
        }
        
        if(keyboard_check_pressed(ord("Z"))) {
            switch(pos){
                case 0:
                    if(root.beat_game and clicked_start == false){
                        clicked_start = true
                        audio_sound_gain(msc_start, 0, 4500)
                        
                        root.anim.add(
                            new Animation(id, "title_alpha", 1, 0, 6)
                                .complete_callback(function(){room_goto(rm_end)})
                        )
                        
                    } else {
                        times_ng_clicked++
                        if(times_ng_clicked > 9){
                            show_message(ng_messages[min(times_ng_clicked - 10, array_length(ng_messages) - 1)])
                        }
                        play_wrong_sound()
                    }
                    break
                case 1:
                    if(root.beat_game){
                        play_wrong_sound()
                    } else if(clicked_start == false) {
                        state++
                        clicked_start = true
                        title_text = "Cosplay Final 98"
                        window_set_caption(title_text)
                        layer_background_blend(layer_background_get_id("Background"), #081820)
                        
                        var _fx = fx_create("_filter_screenshake") // g_Magnitude 10 g_ShakeSpeed 2.5
                        var _params = fx_get_parameters(_fx)
                        _params.g_Magnitude = 10
                        _params.g_ShakeSpeed = 2.5
                        fx_set_parameters(_fx, _params)
                        layer_set_fx("layer_shake", _fx)
                        
                        audio_stop_all()
                        audio_play_sound(snd_scary, 1, 0, .4, undefined, .7)
                        
                        call_later(.5, time_source_units_seconds,
                        function(){
                            create_transition(120, 
                            function(){
                                room_goto(rm_game)
                                audio_play_sound(msc_tension_min, 1, 1)
                            },
                            function(){
                                create_dialogue([
                                    "Gui, o guerreiro: ...",
                                    "Meg, a maga: Gui! Voce esta bem?",
                                    "Gui, o guerreiro: To... confuso. Onde a gente ta? Por que tudo ta verde?",
                                    "Meg, a maga: Eu estou tao confusa quanto voce. Vamos explorar.",
                                    "Gui, o guerreiro: Que lugar esquisito..."
                                ])
                            })
                        })
                        
                        
                    }
                    break
                case 2:
                    audio_master_gain(min((get_integer("Digite um volume de 1 a 100", 100) / 100), 1))
                    break
                case 3:
                    show_message("Não foi possível criar um tutorial, então aqui está um guia de como jogar.")
                    show_message("Controles:\nAndar: setas\nConfirmar/Interagir/Pular/Atacar: Z\nCancelar/Bloquear: X")
                    show_message("Quando estiver em batalha, o guerreiro e o mago tem ataques diferentes.\nNo ataque do guerreiro, você tem que apertar Z quando for acertar o inimigo.\nNo ataque do mago, ESMAGUE seu teclado com teclas! \"tipo AHSIHGDFOISADHFIASDHFIUHASDOIFUASHOFIUASDFL\"")
                    show_message("Por fim, quando os inimigos atacam, você pode esquivar com Z, ou bloquear com X e reduzir o dano.\nSe bloquear no momento exato, você faz um parry!")
                    show_message("É isso. Não deu tempo de colocar essas informações no jogo, então sinta-se livre para ler novamente.")
                    break
            }
        }
    
        break
}