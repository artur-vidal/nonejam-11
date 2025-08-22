units = [
    new Guerreiro(130, 10, 0),
    new Mago(80, 0, 10),
]

enemies = [
    new Dino(),
    new BattleEnemy("Inimigo 2", new Sprite(spr_quad_2))
]

ylayouts = [
    [70], // uma unit
    [50, 90], // duas unit
    [35, 70, 105] // tres unit
]

max_entities = 3 // maximo de entidades de cada lado

// timer pra desenhar tela preta na frente
draw_black_overlay = 0
black_overlay = surface_create(320, 240)

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
    
    for(var i = 0; i < array_length(units); i++){
        units[i].main_draw()
        units[i].draw()
    }
    
    for(var i = 0; i < array_length(enemies); i++){
        enemies[i].main_draw()
        enemies[i].draw()
    }
}

// redefinindo alvos
redefine_targets = function(){
	for(var i = 0; i < array_length(units); i++){
		var _unit = units[i]
		
		/* se o alvo é uma unit ou ainda existe, 
		eu não preciso redefinir então passo pra próxima */
		if(is_instanceof(_unit.target, BattleUnit) or array_contains(enemies, _unit.target)){
			continue	
		}
		
		if(array_length(enemies) > 0){
			_unit.target = enemies[0]
		}
	}
}

// inicializando tudo
apply_start_anim = function() {
    
    state = BattleStates.STARTING
    
    var _unit_xoffset = -60
    var _enemy_xoffset = 50
    
    var _starting_unit_x = 40
    var _starting_enemy_x = room_width - 40
    
    var _base_delay = (root.first_battle) ? 3 : 0
    var _duration = (root.first_battle) ? 2.5 : 1
    
    // units
    for(var i = 0; i < array_length(units); i++){
        
        units[i].set_pos(_starting_unit_x, ylayouts[array_length(units) - 1, i])
        
        var _prev_off = units[i].offset.x
        units[i].offset.x = _unit_xoffset
        var _anim = new Animation(units[i].offset, "x", _unit_xoffset, _prev_off, _duration)
                        .ease(ease_linear)
                        .delay(_base_delay + i * 0.5)
                        .tag($"battle_entity:{units[i].entity_id}_spawn_anim")
        
        root.anim.add(_anim)
    }
    
    // inimigos
    for(var i = 0; i < array_length(enemies); i++){
        
        enemies[i].set_pos(_starting_enemy_x, ylayouts[array_length(enemies) - 1, i])
        
        var _prev_off = enemies[i].offset.x
        enemies[i].offset.x = _enemy_xoffset
        var _anim = new Animation(enemies[i].offset, "x", _enemy_xoffset, _prev_off, _duration)
                        .ease(ease_linear)
                        .delay(_base_delay * 3 + i)  
                        .tag($"battle_entity_{enemies[i].entity_id}_spawn_anim")
        
        if(i == array_length(enemies) - 1){
            _anim.complete_callback(function(_inst){_inst.state = BattleStates.PLAYER_TURN})
                .callback_args(id)
        }
        root.anim.add(_anim)
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

set_current_unit = function() {
    current_unit = -1
    do {
        current_unit++
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

state_player = function(){ 
    
    var _change = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up)
    
    if(selecting == BattleSelectionModes.ACTIONS){
        set_current_unit()
        
        // mudando opção
        _change = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left)
        action_selection += _change
        wrap_action_selection()
         
        // voltando pra unidade anterior e redefinindo a ação dela
        if(keyboard_check_pressed(vk_escape) and current_unit > 0){
            units[current_unit - 1].action = -1
            units[current_unit - 1].target = -1
            current_enemy = 0
            return // quebrando pra não conflitar com mais nada
        }
        
        if(keyboard_check_pressed(ord("Z"))) {
            switch(available_actions[action_selection]) {
                case BattleActions.ATTACK: selecting = BattleSelectionModes.ENEMIES; break;
                case BattleActions.MAGIC: selecting = BattleSelectionModes.ENEMIES; break;
                case BattleActions.CHARGE: select_action(units); break;
                case BattleActions.HEAL: selecting = BattleSelectionModes.UNITS; break;
            }
            return // quebrando aqui pra não registrar espaço no mesmo frame
        }
    } 
    
    if(selecting == BattleSelectionModes.UNITS){
        // passando pelos aliados
        selected_entity += _change
        if(selected_entity > array_length(units) - 1) selected_entity = 0
        else if(selected_entity < 0) selected_entity = array_length(units) - 1
        
        // voltando pra unit caso aperte esc
        if(keyboard_check_pressed(ord("X"))) back_action()
        
        // selecionando, definindo ação e passando pra próxima unidade
        if(keyboard_check_pressed(ord("Z"))) select_action(units)
    }
    
    if(selecting == BattleSelectionModes.ENEMIES){
        // passando pelos inimigos
        selected_entity += _change
        if(selected_entity > array_length(enemies) - 1) selected_entity = 0
        else if(selected_entity < 0) selected_entity = array_length(enemies) - 1
        
        change = sign(_change)
        
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
			
			if(array_length(enemies) > 0){
				state = BattleStates.ENEMY_ATTACKING
			} else {
				state = BattleStates.END	
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
            }
            
            state = BattleStates.PLAYER_TURN
        }
    }
}

state = BattleStates.PLAYER_TURN

// inicializando
if(!audio_is_playing(msc_battle)){
    
    if(root.first_battle){
        audio_play_sound(msc_battle, 1, 1, .7)
    } else {
        audio_play_sound(msc_battle, 1, 1, .7, 10.14)
    }
}