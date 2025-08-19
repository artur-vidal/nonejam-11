enum BattleStates {
    STARTING,
    PLAYER_TURN,
    PLAYER_ACT,
    ENEMY_ATTACKING
}

enum BattleActions {
    ATTACK,
    MAGIC,
    HEAL,
    CHARGE,
    COUNT
}

enum BattleActionStates {
    ATTACK_WALKING,
    ATTACK_CHARGING,
    ATTACK_ATTACKING,
    ATTACK_LEAVING,
    HEAL_STARTING,
    HEAL_HEALING,
    CHARGE_ANIM,
}

enum BattleSelectionModes {
    ACTIONS,
    UNITS,
    ENEMIES,
}

function BattleEntity(_name, _sprite) constructor{
    static entity_id = 0
    entity_id++
    
    name = _name
    battle = other.id
    
    max_hp = 100
    hp = max_hp
    
    attack_damage = 5
    magic_damage = 5
    
    x = 0
    y = 0
    
    sprite = _sprite
    draw_x = 0
    draw_y = 0
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
    
    dead = false
    
    take_dmg = function(_dmg) {
        hp -= _dmg
        audio_play_sound(snd_hurt, 1, 0)
        create_indicator(x + offset.x, y + offset.y - 12, -_dmg)
        
        if(hp < 0) dead = true
    }
    
    heal = function(_healing) {
        hp += _healing
        hp = clamp(hp, 0, max_hp)
        
        audio_play_sound(snd_heal, 1, 0)
        create_indicator(x + offset.x, y + offset.y - 12, _healing)
    }
    
    set_pos = function(_x, _y) {
        x = _x
        y = _y
        draw_x = x
        draw_y = y
    }
    
    go_to_point = function(_px, _py, _spd){
        var _dist = point_distance(draw_x, draw_y, _px, _py)
        var _dir = point_direction(draw_x, draw_y, _px, _py)
        
        if(_dist <= _spd) {
            draw_x = _px
            draw_y = _py
            return true
        } else {
            draw_x += lengthdir_x(_spd * root.GAME_SPEED, _dir)
            draw_y += lengthdir_y(_spd * root.GAME_SPEED, _dir)
            return false
        }
    }
    
    main_update = function() { // não deve ser substituída
        
        // voltando a cor da sprite
        var _r = color_get_red(sprite.color)
        var _g = color_get_green(sprite.color)
        var _b = color_get_blue(sprite.color)
        
        _r = approach(_r, 255, 5)
        _g = approach(_g, 255, 5)
        _b = approach(_b, 255, 5)
        
        sprite.color = make_color_rgb(_r, _g, _b)
    }
    
    update = function() { // pode ser substituída
        
    }
    
    main_draw = function() { // não deve ser substituída
        sprite.draw(draw_x + offset.x, draw_y + offset.y)
    }
    
    draw = function() { // pode ser substituída
        
    }
}

function BattleUnit(_name, _sprite) : BattleEntity("", noone) constructor {
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
    
    started_healing = false
    healed = false
    heal_anim_seconds = 1
    
    dodging = false
    jumping = false
    jump_height = 16
    jump_duration = .2
    
    concentrating = false
    charge_anim_seconds = 1
    started_charging = false
    
    attack_action = function() {
        if(action_state == -1) action_state = BattleActionStates.ATTACK_WALKING
        
        switch (action_state) {
            case BattleActionStates.ATTACK_WALKING:
                var _arrived = go_to_point(target.x - 24, target.y, 2)
                if(_arrived) {
                    action_state = BattleActionStates.ATTACK_CHARGING
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
                        function(){
                            self.target.take_dmg((self.concentrating) ? damage_to_deal * 2 : damage_to_deal)
                            self.concentrating = false
                            self.target.sprite.color = c_red
                            self.action_state = BattleActionStates.ATTACK_LEAVING
                        })
                    }
                }
                break
            
            case BattleActionStates.ATTACK_LEAVING:
                var _arrived = go_to_point(x, y, 3)
                if(_arrived){
                    action = -1
                    target = -1
                    action_state = -1
                    
                    attacked = false
                    finished_action = true
                }
                break
        }
    }
    
    heal_action = function() {
        if(action_state == -1) action_state = BattleActionStates.HEAL_STARTING
            
        switch(action_state) {
            case BattleActionStates.HEAL_STARTING:
                if(!started_healing){
                    call_later(heal_anim_seconds, time_source_units_seconds,
                    function(){self.action_state = BattleActionStates.HEAL_HEALING}) 
                    started_healing = true
                }
                break;
            
            case BattleActionStates.HEAL_HEALING:
                if(!healed){
                    target.heal(magic_damage * 2)
                    target.sprite.color = c_lime
                    healed = true
                    
                    call_later(1, time_source_units_seconds, function(){
                        self.action = -1
                        self.target = -1
                        self.action_state = -1
                        
                        self.healed = false
                        self.started_healing = false
                        self.finished_action = true
                    })
                }
                break;
        }
    }
    
    charge_action = function() {
        if(action_state == -1) action_state = BattleActionStates.CHARGE_ANIM
            
        switch(action_state) {
            case BattleActionStates.CHARGE_ANIM:
                if(!started_charging){
                    call_later(heal_anim_seconds, time_source_units_seconds,
                    function(){
                        audio_play_sound(snd_charge, 1, 0)
                        self.sprite.color = c_blue
                        
                        self.action = -1
                        self.target = -1
                        self.action_state = -1
                        
                        self.concentrating = true
                        self.started_charging = false
                        self.finished_action = true
                    }) 
                    started_charging = true
                }
                break;
        }
    }
    
    update = function(){
        if(battle.units[battle.current_unit] == self){
            if(battle.state == BattleStates.PLAYER_TURN){
                offset.x = lerp(offset.x, 12, 0.1)
            }
            
            if(battle.state == BattleStates.PLAYER_ACT){
                switch(action){
                    case BattleActions.ATTACK: attack_action(); break;
                    case BattleActions.HEAL: heal_action(); break;
                    case BattleActions.CHARGE: charge_action(); break;
                }
            }
            
        } else if(battle.state != BattleStates.STARTING){
            offset.x = lerp(offset.x, 0, 0.2)
        }
        
        if(dodging and !jumping and keyboard_check_pressed(vk_space)) {
            jumping = true
            root.anim.add(
                new Animation(self.offset, "y", 0, -jump_height, jump_duration)
                    .ease(ease_out_quad),
                    
                new Animation(self.offset, "y", -jump_height, 0, jump_duration)
                    .ease(ease_in_quad)
                    .delay(jump_duration)
                    .complete_callback(function(_){
                        _.offset.y = 0
                        _.jumping = false 
                    })
                    .callback_args(self)
            )
        }
    }
    
    draw = function() {
        var _temp = scribble($"{round(hp)} {max_hp}")
            .starting_format("fnt_default", #081820)
            .align(2, 1)
            .scale(.4)
        
        _temp.draw(draw_x + offset.x - 12, draw_y + offset.y - 8)
        draw_healthbar(draw_x + offset.x - 9, draw_y + offset.y + 4, draw_x + offset.x + 8, draw_y + offset.y + 8, charge / charge_max * 100, #081820, c_red, c_aqua, 0, true, true)
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
                var _arrived = go_to_point(target.x + 24, target.y, 4)
                if(_arrived) {
                    action_state = BattleActionStates.ATTACK_CHARGING
                }
                break
            
            case BattleActionStates.ATTACK_CHARGING:
                if(!attacked){
                    attacked = true
                    target.dodging = true
                    call_later(attack_anim_seconds, time_source_units_seconds, 
                    function(){
                        if(!target.jumping){
                            self.target.take_dmg(attack_damage * 5)
                            self.target.sprite.color = c_red
                        }
                        self.action_state = BattleActionStates.ATTACK_LEAVING
                        target.dodging = false
                        target.jumping = false
                    })
                }
                break
            
            case BattleActionStates.ATTACK_LEAVING:
                var _arrived = go_to_point(x, y, 2)
                if(_arrived){
                    target = -1
                    action_state = -1
                    
                    attacked = false
                    finished_action = true
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
        
        // me removendo do array
        if(dead){
            with(battle) {
                for(var i = 0; i < array_length(enemies); i++){
                    if(enemies[i] == other) array_delete(enemies, i, 1)
                }
            }
        }
    }
    
    draw = function() {
        
        var _temp = scribble($"{round(hp)} {max_hp}")
            .starting_format("fnt_default", #081820)
            .align(0, 1)
            .scale(.4)
        
        _temp.draw(draw_x + offset.x + 12, draw_y + offset.y - 8)
    }
}









