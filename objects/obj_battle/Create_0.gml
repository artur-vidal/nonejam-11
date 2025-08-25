obj_camera.cx = 0
obj_camera.cy = 0

units = []
enemies = []
cards = []

ylayouts = [
    [70], // uma unit
    [50, 90], // duas unit
    [35, 70, 105], // tres unit
    [30, 55, 85, 110] // quatro unit
]

max_entities = 4 // maximo de entidades de cada lado

music = msc_battle

continue_seconds = 21 * 60
continue_text_timer = 15
continue_alpha = 0
continuing = false

// timer pra desenhar tela preta na frente
draw_black_overlay = 0
black_overlay = surface_create(320, 240)
black_overlay_alpha = 1

on_end = function() {
    audio_play_sound(msc_dungeon, 1, 1)
}

#region Partículas

pem = part_emitter_create(root.part_sys);

pt = part_type_create();
part_type_shape(pt, pt_shape_disk);
part_type_size(pt, .25, .25, 0, 0);
part_type_scale(pt, 0.1, 0.1);
part_type_speed(pt, 2.5, 2.5, 0, 0);
part_type_direction(pt, 85, 95, 0, 0);
part_type_gravity(pt, 0, 270);
part_type_orientation(pt, 0, 0, 0, 0, false);
part_type_colour3(pt, $e0f8d0, $88c070, $346856);
part_type_alpha3(pt, 1, 1, 1);
part_type_blend(pt, false);
part_type_life(pt, 30, 40);


particle_time = 0
turn_particles_on = function(_x, _y, _duration) {
    part_emitter_region(root.part_sys, pem, _x - 2, _x + 2, _y - 2, _y + 2, ps_shape_rectangle, ps_distr_linear);
    particle_time = _duration
}

#endregion

// atualizar entidades
update_all = function() {
    
    for(var i = 0; i < array_length(units); i++){
        units[i].main_update()
        units[i].update()
    }
    
    for(var i = 0; i < array_length(enemies); i++){
        enemies[i].main_update()
        enemies[i].update()
    }
}

// desenhar entidades
draw_all = function(){
    
    // desenho inimigos por cima se for a ação deles, ou as units se for ação delas
    if(state == BattleStates.ENEMY_ATTACKING){
        for(var i = 0; i < array_length(units); i++){
            units[i].main_draw()
            units[i].draw()
        }
        
        for(var i = 0; i < array_length(enemies); i++){
            enemies[i].main_draw()
            enemies[i].draw()
        }
    } else {
        for(var i = 0; i < array_length(enemies); i++){
            enemies[i].main_draw()
            enemies[i].draw()
        }
            
        for(var i = 0; i < array_length(units); i++){
            units[i].main_draw()
            units[i].draw()
        }
    }
}

// redefinindo alvos
redefine_targets = function(){
    
	for(var i = 0; i < array_length(units); i++){
		var _unit = units[i]
		
		/* se o alvo é uma unit ou ainda existe/tá vivo, 
		eu não preciso redefinir então passo pra próxima */
		if(is_instanceof(_unit.target, BattleUnit) or _unit.target == -1){
            show_debug_message("não pulando porque alvo é unit ou n tem target")
			continue	
		} else if(is_instanceof(_unit.target, BattleEnemy) and !_unit.target.dead) {
            show_debug_message("não pulando porque alvo é inimigo e vivo")
            continue
        }
		
		if(array_length(enemies) > 0){
			for(var j = 0; j < array_length(enemies); j++){
                if(!enemies[j].dead) {
                    _unit.target = enemies[j]
                    break
                }
            }
		}
        
        // tirando target se não achar nada no fim
        _unit.target = -1
	}
}

// resetando batalha
reset_battle = function(){
    
    audio_sound_gain(music, 1, 0)
    audio_sound_pitch(music, 1)
    continue_seconds = 21 * 60
    continue_text_timer = 15
    continue_alpha = 0
    continuing = false
    
    // voltando as units ao estado inicial
    root.guerreiro.hp = root.prev_guerreiro_hp
    root.guerreiro.mana = root.prev_guerreiro_mana
    
    root.mago.hp = root.prev_mago_hp
    root.mago.mana = root.prev_mano_mana
    
    // revivendo todas as units
    for(var i = 0; i < array_length(units); i++){
        units[i].concentrating = false
        units[i].dead = false
        units[i].turns_to_revive = 0
    }
    
    // curando todos os inimigos
    for(var i = 0; i < array_length(enemies); i++){
        enemies[i].hp = enemies[i].max_hp
    }
    
    state = BattleStates.STARTING
    
    audio_stop_sound(music)
    audio_play_sound(music, 1, 1)
    apply_start_anim()
}

// inicializando tudo
delay_start = 0
apply_start_anim = function() {
    
    state = BattleStates.STARTING
    
    var _unit_xoffset = -60
    var _enemy_xoffset = 70
    
    var _starting_unit_x = 40
    var _starting_enemy_x = 120
    
    var _base_delay = (root.first_battle) ? 3 : 0
    var _duration = (root.first_battle) ? 2.5 : 1
    
    // units
    for(var i = 0; i < array_length(units); i++){
        
        units[i].set_pos(_starting_unit_x, ylayouts[array_length(units) - 1, i])
        
        var _prev_off = units[i].offset.x
        units[i].offset.x = _unit_xoffset
        
        var _sprite_move, _sprite_idle
        if(is_instanceof(units[i], Guerreiro)){
            _sprite_idle = spr_guerreiro_idle
            _sprite_move = spr_guerreiro_move
        } else {
            _sprite_idle = spr_mago_idle
            _sprite_move = spr_mago_move
        }
        
        units[i].sprite.change(_sprite_move)
        var _anim = new Animation(units[i].offset, "x", _unit_xoffset, _prev_off, _duration)
                        .ease(ease_linear)
                        .delay(_base_delay + i * 0.5)
                        .tag($"battle_entity:{units[i].entity_id}_spawn_anim")
                        .complete_callback(function(_u, _s){_u.sprite.change(_s)})
                        .callback_args([units[i], _sprite_idle])
        
        root.anim.add(_anim)
    }
    
    // inimigos
    for(var i = 0; i < array_length(enemies); i++){
        
        enemies[i].set_pos(_starting_enemy_x, ylayouts[array_length(enemies) - 1, i])
        
        var _prev_off = enemies[i].offset.x
        enemies[i].offset.x = _enemy_xoffset
        var _anim = new Animation(enemies[i].offset, "x", _enemy_xoffset, _prev_off, _duration)
                        .ease(ease_out_sine)
                        .delay(_base_delay * 3 + i)  
                        .tag($"battle_entity_{enemies[i].entity_id}_spawn_anim")
        
        if(i == array_length(enemies) - 1){
            _anim.complete_callback(function(_inst){_inst.state = BattleStates.PLAYER_TURN})
                .callback_args(id)
        }
        root.anim.add(_anim)
    }
    
    for(var i = 0; i < array_length(cards); i++){
        cards[i].x = 20 + 48 * i
    }
    root.first_battle = false
}

// Estados
current_unit = 0
current_enemy = 0

selecting = BattleSelectionModes.ACTIONS
selected_entity = 0

action_selection = BattleActions.ATTACK
available_actions = []

action_labels = []
action_labels[BattleActions.ATTACK] = "Ataque"
action_labels[BattleActions.MAGIC] = "Magia"
action_labels[BattleActions.CHARGE] = "Concentrar"
action_labels[BattleActions.HEAL] = "Curar"
action_labels[BattleActions.MEDITATE] = "Meditar"

ending = false

set_current_unit = function() {
    current_unit = -1
    do {
        current_unit++
        
        if(units[current_unit].dead){
             // guerreiro vira mago, mago pula ação
            if(current_unit == 0) current_unit = 1
            else if(current_unit == 1) {
                current_unit = 0
                selected_entity = 0
                state = BattleStates.PLAYER_ACT
            }
            break
        }
        
        available_actions = units[current_unit].available_actions
    } until(units[current_unit].action == -1)
}

select_action = function(_entity) {
    units[current_unit].action = available_actions[action_selection]
    units[current_unit].target = _entity[selected_entity]
    
    units[current_unit].action_state = -1
    units[current_unit].finished_action = false
    
    /* se o current_unit passar da quantidade de unidades (ou seja, acabou as ação)
    eu volto pra primeira unit e passo pro estado de ataque */
    if(current_unit == array_length(units) - 1){
        current_unit = 0
        selected_entity = 0
        state = BattleStates.PLAYER_ACT
        return
    }
    
    // se não, eu só reseto
    set_current_unit()
    selected_entity = 0
    current_enemy = 0
    selecting = BattleSelectionModes.ACTIONS
    action_selection = BattleActions.ATTACK
}

back_action = function() {
    current_unit = 0
    selected_entity = 0
    set_current_unit()
    
    selecting = BattleSelectionModes.ACTIONS
}

wrap_action_selection = function() {
    if(action_selection > array_length(available_actions) - 1) action_selection = 0
    else if(action_selection < 0) action_selection = array_length(available_actions) - 1
}

wrap_entity_selection = function() {
    
    if(selecting = BattleSelectionModes.UNITS) {
        
        do {
            if(selected_entity > array_length(units) - 1) selected_entity = 0
            else if(selected_entity < 0) selected_entity = array_length(units) - 1
                
            if(units[selected_entity].dead) selected_entity++
                
            if(selected_entity > array_length(units) - 1) selected_entity = 0
            else if(selected_entity < 0) selected_entity = array_length(units) - 1
                
        } until (!units[selected_entity].dead)
            
    } else if(selecting = BattleSelectionModes.ENEMIES) {
        
        do {
            if(selected_entity > array_length(enemies) - 1) selected_entity = 0
            else if(selected_entity < 0) selected_entity = array_length(enemies) - 1
                
            if(enemies[selected_entity].dead) selected_entity++
                
            if(selected_entity > array_length(enemies) - 1) selected_entity = 0
            else if(selected_entity < 0) selected_entity = array_length(enemies) - 1
        } until (!enemies[selected_entity].dead)
            
    } 
}

state_player = function(){ 
    
    var _change = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up)
    
    if(selecting == BattleSelectionModes.ACTIONS){
        set_current_unit()
        
        // mudando opção
        _change = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left)
        action_selection += _change
        wrap_action_selection()
         
        // voltando pra unidade anterior e redefinindo a ação dela
        if(keyboard_check_pressed(ord("X")) and current_unit > 0){
            units[current_unit - 1].action = -1
            units[current_unit - 1].target = -1
            current_enemy = 0
            return // quebrando pra não conflitar com mais nada
        }
        
        if(keyboard_check_pressed(ord("Z"))) {
            var _mana_price = 0
            switch(available_actions[action_selection]) {
                case BattleActions.ATTACK: 
                    selecting = BattleSelectionModes.ENEMIES; 
                    wrap_entity_selection(); 
                    break;
                case BattleActions.MAGIC: 
                    var _mana_price = 12
                    if(units[current_unit].mana < _mana_price){
                        play_wrong_sound()
                        break;
                    }
                    selecting = BattleSelectionModes.ENEMIES; 
                    wrap_entity_selection(); 
                    break;
                case BattleActions.CHARGE: 
                    var _mana_price = 4
                    if(units[current_unit].mana < _mana_price){
                        play_wrong_sound()
                        break;
                    }
                    select_action(units); 
                    break;
                case BattleActions.MEDITATE: 
                    select_action(units); 
                    break;
                case BattleActions.HEAL: 
                    var _mana_price = 8
                    if(units[current_unit].mana < _mana_price){
                        play_wrong_sound()
                        break;
                    }
                    selecting = BattleSelectionModes.UNITS; 
                    wrap_entity_selection(); 
                break;
            }
            return // quebrando aqui pra não registrar espaço no mesmo frame
        }
    } 
    
    if(selecting == BattleSelectionModes.UNITS){
        // passando pelos aliados
        selected_entity += _change
        wrap_entity_selection()
        
        // voltando pra unit caso aperte esc
        if(keyboard_check_pressed(ord("X"))) back_action()
        
        // selecionando, definindo ação e passando pra próxima unidade
        if(keyboard_check_pressed(ord("Z"))) select_action(units)
    }
    
    if(selecting == BattleSelectionModes.ENEMIES){
        // passando pelos inimigos
        selected_entity += _change
        wrap_entity_selection()
        
        // voltando pra unit caso aperte esc
        if(keyboard_check_pressed(ord("X"))) back_action()
        
        // selecionando, definindo ação e passando pra próxima unidade
        if(keyboard_check_pressed(ord("Z"))) select_action(enemies)
    }
}

state_player_actions = function(){
    if(units[current_unit].finished_action){
        if(current_unit < array_length(units) - 1) current_unit++
        else{
            current_unit = 0
            action_selection = 0
            selecting = BattleSelectionModes.ACTIONS
			
            var _all_enemies_dead = 0
            for(var i = 0; i < array_length(enemies); i++){
                if(enemies[i].dead) _all_enemies_dead++
            }
            _all_enemies_dead /= array_length(enemies) + 1
            
            if(array_length(enemies) == 0 or _all_enemies_dead){
				state = BattleStates.END	
            } else {
				state = BattleStates.ENEMY_ATTACKING
            }
        }
    }
}

state_enemy_attacks = function() {
    
    if(enemies[current_enemy].finished_action){
        if(current_enemy < array_length(enemies) - 1) current_enemy++
        else{
            current_enemy = 0
            
            // resetando todas as ações
            for(var i = 0; i < array_length(enemies); i++){
                enemies[i].finished_action = false
                enemies[i].action_state = -1
                enemies[i].target = -1
            }
            
            // indo pra game over se todas as units tiverem morrido
            var _all_dead = 0
            for(var i = 0; i < array_length(units); i++){
                if(units[i].dead) _all_dead++
            }
            _all_dead /= array_length(units) + 1
            
            if(_all_dead){
                state = BattleStates.GAME_OVER
                return 
            }
            
            state = BattleStates.PLAYER_TURN
        }
    }
}

state_end = function(){
    var _is_knight = array_length(enemies) == 3 and is_instanceof(enemies[1], Cavaleiro)
    
	if(!ending){
        
        if(_is_knight){
            root.beat_game = true
            audio_sound_gain(msc_final_boss_loop, 0, 3)
            
                
            root.anim.add(
                new Animation(obj_camera, "cx", obj_camera.cx, obj_camera.cx + 35, 3)
            )
            
            call_later(4, time_source_units_seconds, function(){
                if(!units[0].dead) units[0].sprite.change(units[0].happy_sprite)
                if(!units[1].dead) units[1].sprite.change(units[1].happy_sprite)
                instance_create_depth(0, 0, 0, obj_end_sequence)
            })
            
            ending = true
        } else {
            audio_stop_all()
            audio_play_sound(msc_victory, 1, 0)
            
    		show_debug_message("acabano")
    		call_later(5, time_source_units_seconds,
    		function(){
    			create_transition(120, function(){
    				end_battle()
    			})	
    		})
    		ending = true
        }
	}
    
    if(_is_knight){
        
    } else {
        
        if(units[0].dead){
            units[0].dead = false
            units[0].finished_action = false
            units[0].heal(units[1].max_hp * .5)
            units[0].sprite.change(units[0].happy_sprite)
        }
        if(units[0].go_to_point(60, 80, 1)){
            units[0].sprite.change(spr_guerreiro_win)
        }
        
        if(units[1].dead){
            units[1].dead = false
            units[1].finished_action = false
            units[1].heal(units[1].max_hp * .5)
            units[1].sprite.change(units[1].happy_sprite)
        }
        
        if(array_length(units) > 1 and !units[1].dead){
            if(units[1].go_to_point(100, 80, 1)){
                units[1].sprite.change(spr_mago_win)
            }
        }
    }
}

state_game_over = function() {
    if(!continuing){
        audio_play_sound(msc_gameover, 1, 0)
        
        audio_sound_gain(music, .3, 2000)
        audio_sound_pitch(music, .8)
        continuing = true
    }
    
    continue_alpha = approach(continue_alpha, .8, 0.005)
    
    continue_text_timer = approach(continue_text_timer, 0, 1)
    continue_seconds--
    
    if(continue_seconds % 60 == 0) {
        continue_text_timer = 10
        
        var _pitch = ((continue_seconds / 60) % 2 == 0) ? 1.1 : 0.8
        audio_play_sound(snd_tick, 1, 0, .6, undefined, _pitch)
    }
    
    if(keyboard_check_pressed(ord("Z"))) {
        reset_battle()
    }
    
    if(continue_seconds <= 0) {
        audio_sound_gain(music, 1, 0)
        audio_sound_pitch(music, 1)
        game_restart()
    }
}

state = BattleStates.STARTING