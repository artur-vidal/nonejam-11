units = [
    new BattleUnit("Quadrado 1", spr_quad_1),
    new BattleUnit("Quadrado 2", spr_quad_1)
]

enemies = [
    new BattleEnemy("Inimigo 1", spr_quad_2),
    new BattleEnemy("Inimigo 2", spr_quad_2),
    new BattleEnemy("Inimigo 3", spr_quad_2)
]

ylayouts = [
    [140], // uma unit
    [100, 180], // duas unit
    [70, 140, 210] // tres unit
]

max_entities = 3 // maximo de entidades de cada lado

update_all = function() {
    // atualizando entidades
    for(var i = 0; i < array_length(units); i++){
        units[i].main_update()
        units[i].update()
    }
    
    for(var i = 0; i < array_length(enemies); i++){
        enemies[i].main_update()
        enemies[i].update()
    }
}

draw_all = function(){
    var _starting_unit_x = 60
    var _starting_enemy_x = room_width - 60
    var _starting_y = 40
    
    // desenhando entidades
    for(var i = 0; i < array_length(units); i++){
        units[i].x = _starting_unit_x
        units[i].y = ylayouts[array_length(units) - 1, i]
        units[i].main_draw()
        units[i].draw()
    }
    
    for(var i = 0; i < array_length(enemies); i++){
        enemies[i].x = _starting_enemy_x
        enemies[i].y = ylayouts[array_length(enemies) - 1, i]
        enemies[i].main_draw()
        enemies[i].draw()
    }
}

apply_start_anim = function() {
    state = BattleStates.STARTING
    
    var _yoffset = -400
    for(var i = 0; i < array_length(units); i++){
        units[i].offset.y = _yoffset
        var _anim = new Animation(units[i].offset, "y", _yoffset, 0, 2)
                        .ease(ease_out_sine)
                        .delay((array_length(units) - i) * 0.2)
                        .tag($"battle_entity_{units[i].entity_id}_spawn_anim")
        
        root.anim.add(_anim)
    }
    
    for(var i = 0; i < array_length(enemies); i++){
        enemies[i].offset.y = _yoffset
        var _anim = new Animation(enemies[i].offset, "y", _yoffset, 0, 2)
                        .ease(ease_out_sine)
                        .delay((array_length(units) - i) * 0.3)
                        .tag($"battle_entity_{enemies[i].entity_id}_spawn_anim")
        
        if(i == 0){
            _anim.complete_callback(function(_inst){_inst.state = BattleStates.PLAYER_TURN})
                .callback_args(id)
        }
        root.anim.add(_anim)
    }
}

// Estados
current_unit = 0
current_enemy = 0
selecting = 0 // 0 ação, 1 inimigo

action_selection = BattleActions.ATTACK
action_selection_display = action_selection

action_labels = []
action_labels[BattleActions.ATTACK] = "Ataque"
action_labels[BattleActions.MAGIC] = "Magia"
action_labels[BattleActions.CHARGE] = "Concentrar"
action_labels[BattleActions.ITEM] = "Item"
action_labels[BattleActions.SKIP] = "Skip"
action_labels[BattleActions.RUN] = "Fugir"

set_current_unit = function(){
    current_unit = 0
    while(units[current_unit].action != -1){
        current_unit++
    }
}

state_player = function(){ 
    set_current_unit()
    
    if(selecting == 0){
        
        // mudando opção
        var _change = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left)
        action_selection += _change
        if(action_selection > BattleActions.COUNT - 1) action_selection = 0
        else if(action_selection < 0) action_selection = BattleActions.COUNT - 1
         
        // voltando pra unidade anterior e redefinindo a ação dela
        if(keyboard_check_pressed(vk_escape) and current_unit > 0){
            units[current_unit - 1].action = -1
            units[current_unit - 1].target = -1
            current_enemy = 0
            return // quebrando pra não conflitar com mais nada
        }
        
        if(keyboard_check_pressed(vk_space)) {
            selecting = 1
            return // quebrando aqui pra não registrar espaço no mesmo frame
        }
    } 
    
    if(selecting == 1){
        // passando pelos inimigos
        var _change = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up)
        current_enemy += _change
        if(current_enemy > array_length(enemies) - 1) current_enemy = 0
        else if(current_enemy < 0) current_enemy = array_length(enemies) - 1
            
        change = sign(_change)
        
        // voltando pra unit caso aperte esc
        if(keyboard_check_pressed(vk_escape)){
            selecting = 0
        }
        
        // selecionando, definindo ação e passando pra próxima unidade
        if(keyboard_check_pressed(vk_space)){
            units[current_unit].action = action_selection
            units[current_unit].target = enemies[current_enemy]
            
            units[current_unit].action_state = -1
            units[current_unit].finished_action = false
            
            /* se o current_unit passar da quantidade de unidades (ou seja, acabou as ação)
            eu volto pra primeira unit e passo pro estado de ataque */
            if(current_unit == array_length(units) - 1){
                current_unit = 0
                current_enemy = 0
                state = BattleStates.PLAYER_ACT
                return
            }
            
            // se não, eu só reseto
            set_current_unit()
            current_enemy = 0
            selecting = 0
            action_selection = BattleActions.ATTACK
        }
    }
}

state_player_actions = function(){
    if(units[current_unit].finished_action){
        if(current_unit < array_length(units) - 1) current_unit++
        else{
            current_unit = 0
            action_selection = 0
            selecting = 0
            state = BattleStates.ENEMY_ATTACKING
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

// aplicando início depois de criar tudo
apply_start_anim()