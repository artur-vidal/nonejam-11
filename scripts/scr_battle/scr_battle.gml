enum BattleStates {
    STARTING,
    PLAYER_TURN,
    PLAYER_ACT,
    ENEMY_ATTACKING
}

enum BattleActions {
    ATTACK,
    MAGIC,
    ITEM,
    RUN,
    SKIP,
    CHARGE,
    COUNT
}

enum BattleActionStates {
    ATTACK_WALKING,
    ATTACK_CHARGING,
    ATTACK_ATTACKING,
    ATTACK_LEAVING
}

function BattleEntity(_name, _sprite) constructor{
    static entity_id = 0
    entity_id++
    
    name = _name
    battle = other.id
    
    hp = 100
    attack_damage = 5
    magic_damage = 5
    
    sprite = _sprite
    x = 0
    y = 0
    offset = {
        x : 0,
        y : 0,
    }
    
    shadow_offset = {
        x : 0,
        y : 0,
    }
    draw_shadow = true
    
    action = -1
    target = -1
    
    action_state = -1
    finished_action = false
    
    take_dmg = function(_dmg){
        hp -= _dmg
    }
    
    main_update = function() { // não deve ser substituída
        
    }
    
    update = function() { // pode ser substituída
        
    }
    
    main_draw = function() { // não deve ser substituída
        if(sprite != noone){    
            if(draw_shadow){
                var _distance_multi = 1 + (y + (y - offset.y) / 150)
                draw_sprite_ext(spr_shadow, 0, x + shadow_offset.x + offset.x, y + shadow_offset.y + offset.y, max(0, 1 * _distance_multi), max(0, 0.7 * _distance_multi), 0, c_white, 1 * (1 + (1 - _distance_multi)))
            }
            draw_sprite(sprite, 0, x + offset.x, y + offset.y)
        }
        
        var _info = scribble(name + "\nVida: " + string(hp))
            .starting_format("fnt_default", c_white)
            .align(1, 0)
        
        _info.draw(x + offset.x, y + offset.y + 4)
    }
    
    draw = function() { // pode ser substituída
        
    }
}

function BattleUnit(_name, _sprite) : BattleEntity("", noone) constructor{
    name = _name
    sprite = _sprite
    
    charge = 0
    charge_max = 120
    
    charge_ok = charge_max / 1.2
    charge_good = charge_max / 2
    charge_excellent = charge_max / 4
    
    attacked = false
    damage_to_deal = 0
    attack_anim_seconds = 1
    
    attack_action = function() {
        if(action_state == -1) action_state = BattleActionStates.ATTACK_WALKING
        
        var _targetx, _targety, _dir, _dist
        
        switch (action_state) {
            case BattleActionStates.ATTACK_WALKING:
                
                _targetx = target.x - x - 64
                _targety = target.y - y
                _dist = point_distance(offset.x, offset.y, _targetx, _targety)
                _dir = point_direction(offset.x, offset.y, _targetx, _targety)
            
                if(_dist <= 5){
                    offset.x = _targetx
                    offset.y = _targety
                    action_state = BattleActionStates.ATTACK_CHARGING
                }else{
                    offset.x += lengthdir_x(4, _dir)
                    offset.y += lengthdir_y(4, _dir)
                }
                break
                
            case BattleActionStates.ATTACK_CHARGING:
                if(!attacked){
                    charge++
                    var _charge_left = charge_max - charge
                    
                    if(keyboard_check_pressed(vk_space) or _charge_left <= 0){
                        
                        if(_charge_left > 0){
                            if(_charge_left < charge_excellent){
                                damage_to_deal = attack_damage * 3 * 1.25
                            } else if(_charge_left < charge_good) {
                                damage_to_deal = attack_damage
                            } else if(_charge_left < charge_ok) {
                                damage_to_deal = attack_damage * 3 * 0.75
                            } else {
                                damage_to_deal = attack_damage
                            }
                        } else {
                            damage_to_deal = attack_damage
                        }
                        
                        charge = 0
                        attacked = true
                        call_later(attack_anim_seconds, time_source_units_seconds, 
                        function(){self.action_state = BattleActionStates.ATTACK_ATTACKING})
                    }
                }
                break
            
            case BattleActionStates.ATTACK_ATTACKING:
                target.take_dmg(damage_to_deal)
                action_state = BattleActionStates.ATTACK_LEAVING
                break
            
            case BattleActionStates.ATTACK_LEAVING:
                _dist = point_distance(offset.x, offset.y, 0, 0)
                _dir = point_direction(offset.x, offset.y, 0, 0)
                
                if(_dist <= 5){
                    offset.x = 0
                    offset.y = 0
                    
                    action = -1
                    target = -1
                    action_state = -1
                    attacked = false
                    finished_action = true
                }else{
                    offset.x += lengthdir_x(6, _dir)
                    offset.y += lengthdir_y(6, _dir)
                }
                break
        }
    }
    
    update = function(){
        if(battle.state == BattleStates.PLAYER_ACT and battle.units[battle.current_unit] == self){
            
            switch(action){
                case BattleActions.ATTACK: attack_action(); break;
            }
        }
    }
    
    draw = function() {
        
        var _miss_color = c_red
        var _ok_color = c_yellow
        var _good_color = c_lime
        var _excellent_color = c_aqua
        
        var _charge_left = charge_max - charge
        if(_charge_left < charge_excellent){
            draw_set_color(_excellent_color)
        } else if(_charge_left < charge_good) {
            draw_set_color(_good_color)
        } else if(_charge_left < charge_ok) {
            draw_set_color(_ok_color)
        } else {
            draw_set_color(_miss_color)
        }
        
        draw_text(x + offset.x, y + offset.y - 64, charge)
        draw_set_color(c_white)
    }
}

function BattleEnemy(_name, _sprite) : BattleEntity("", noone) constructor{
    name = _name
    sprite = _sprite
    
    action = BattleActions.ATTACK
    
    attacked = false
    attack_anim_seconds = 1
    
    attack_state = function() {
        if(action_state == -1) action_state = BattleActionStates.ATTACK_WALKING
        if(target == -1) target = battle.units[irandom(array_length(battle.units) - 1)]
        
        var _targetx, _targety, _dir, _dist
        
        switch (action_state) {
            case BattleActionStates.ATTACK_WALKING:
                
                _targetx = target.x - x + 64
                _targety = target.y - y
                _dist = point_distance(offset.x, offset.y, _targetx, _targety)
                _dir = point_direction(offset.x, offset.y, _targetx, _targety)
                
                
                show_debug_message($"{target}")
                
                if(_dist <= 5){
                    offset.x = _targetx
                    offset.y = _targety
                    action_state = BattleActionStates.ATTACK_ATTACKING
                }else{
                    offset.x += lengthdir_x(6, _dir)
                    offset.y += lengthdir_y(6, _dir)
                }
                break
                
            case BattleActionStates.ATTACK_ATTACKING:
                target.take_dmg(attack_damage * 3)
                action_state = BattleActionStates.ATTACK_LEAVING
                break
            
            case BattleActionStates.ATTACK_CHARGING:
                if(!attacked){
                    attacked = true
                    call_later(attack_anim_seconds, time_source_units_seconds, 
                    function(){self.action_state = BattleActionStates.ATTACK_ATTACKING})
                }
                break
            
            case BattleActionStates.ATTACK_LEAVING:
                _dist = point_distance(offset.x, offset.y, 0, 0)
                _dir = point_direction(offset.x, offset.y, 0, 0)
                
                if(_dist <= 5){
                    offset.x = 0
                    offset.y = 0
                    
                    target = -1
                    action_state = -1
                    attacked = false
                    finished_action = true
                }else{
                    offset.x += lengthdir_x(6, _dir)
                    offset.y += lengthdir_y(6, _dir)
                }
                break
        }
    }
    
    update = function() {
        if(battle.state == BattleStates.ENEMY_ATTACKING and battle.enemies[battle.current_enemy] == self){
            
            switch(action){
                case BattleActions.ATTACK: attack_state(); break;
            }
        }
    }
}









