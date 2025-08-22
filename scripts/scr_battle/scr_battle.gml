enum BattleStates {
    STARTING,
    PLAYER_TURN,
    PLAYER_ACT,
    ENEMY_ATTACKING,
	DIALOGUE,
	END
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
    ATTACK_LEAVING,
    HEAL_STARTING,
    HEAL_HEALING,
    CHARGE_ANIM,
    MAGIC_STARTING,
    MAGIC_CHARGING,
    MAGIC_RELEASE
}

enum BattleSelectionModes {
    ACTIONS,
    UNITS,
    ENEMIES,
}


// CONSTRUTORES PRIMARIOS
function BattleEntity(_name, _sprite) constructor{
    static entity_id = 0
    entity_id++
    
    name = _name
    battle = noone
    
    max_hp = 100
    hp = max_hp
    
    attack_damage = 5
    magic_damage = 5
    available_actions = [
        BattleActions.ATTACK,
        BattleActions.MAGIC,
        BattleActions.CHARGE,
        BattleActions.HEAL,
    ]
    
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
    
    reduction = 1
    time_with_shield = 0
    
    take_dmg = function(_dmg, _crit = false) {
        if(time_with_shield == clamp(time_with_shield, 1, 7)){
            audio_play_sound(snd_parry, 1, 0, 1.3)
            reduction = 0
            // sprite.color = #88c070
            battle.draw_black_overlay = 8
        } else {
            audio_play_sound((_crit) ? snd_crit : snd_hurt, 1, 0)
            sprite.color = c_red
        }
        
        var _final_dmg = _dmg * reduction
        hp -= _final_dmg
        create_indicator(x + offset.x, y + offset.y - 12, -_final_dmg)
        
        if(hp < 0){
            dead = true
            die()
        }
    }
    
    heal = function(_healing) {
        var _prev_life = hp
        
        hp += _healing
        hp = clamp(hp, 0, max_hp)
        sprite.color = c_lime
        
        var _heal_diff = hp - _prev_life
        
        audio_play_sound(snd_heal, 1, 0)
        create_indicator(x + offset.x, y + offset.y - 12, _heal_diff)
    }
    
    die = function() {
        
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
    
    main_update = function() { 
        
        // voltando a cor da sprite
        var _r = color_get_red(sprite.color)
        var _g = color_get_green(sprite.color)
        var _b = color_get_blue(sprite.color)
        
        _r = approach(_r, 255, 3)
        _g = approach(_g, 255, 3)
        _b = approach(_b, 255, 3)
        
        sprite.color = make_color_rgb(_r, _g, _b)
        
        if(hp > max_hp) hp = max_hp
    }
    
    update = function() { // pode ser substituída
        
    }
    
    main_draw = function() { 
        sprite.draw(draw_x + offset.x, draw_y + offset.y)
    }
    
    draw = function() { // pode ser substituída
        
    }
}

function BattleUnit(_name, _sprite) : BattleEntity("", noone) constructor {
    name = _name
    sprite = _sprite
    
    charge = 0
    charge_max = 90
    
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
    
    fire_sprite = new Sprite(spr_fire)
    fire_sprite.alpha = .8
     
    root.anim.add(
        new Animation(self.fire_sprite, "xscale", .6, .9, 1.7)
            .ease(ease_in_out_quad)
            .type(AnimationTypes.PATROL),
        
        new Animation(self.fire_sprite, "yscale", 1, .7, 2)
            .ease(ease_in_out_quad)
            .type(AnimationTypes.PATROL)
    )
    
    attack_action = function() {
        
    }
    
    heal_action = function() {
        
    }
    
    charge_action = function() {    
        
    }
    
    magic_action = function() {
        
    }
    
    main_update = function(){
        // voltando a cor da sprite
        var _r = color_get_red(sprite.color)
        var _g = color_get_green(sprite.color)
        var _b = color_get_blue(sprite.color)
        
        _r = approach(_r, 255, 3)
        _g = approach(_g, 255, 3)
        _b = approach(_b, 255, 3)
        
        sprite.color = make_color_rgb(_r, _g, _b)
        
        if(hp > max_hp) hp = max_hp
        
        if(battle.units[battle.current_unit] == self){
            
            if(battle.state == BattleStates.PLAYER_ACT){
                switch(action){
                    case BattleActions.ATTACK: attack_action(); break;
                    case BattleActions.MAGIC: magic_action(); break;
                    case BattleActions.HEAL: heal_action(); break;
                    case BattleActions.CHARGE: charge_action(); break;
                }
            }
            
        } 
        
        if(dodging and !jumping) {
            
            if(keyboard_check_pressed(ord("Z"))){
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
                return
            } 
            
            if (keyboard_check(ord("X"))){
                reduction = 0.7
                time_with_shield++
            } else {
                reduction = 1
                time_with_shield = 0
            }
        }
        
        
        fire_sprite.animate(1)
    }
    
    main_draw = function() { // não deve ser substituída (mas eu substituí mesmo assim lol lmao xd)
        if(concentrating){
            fire_sprite.draw(draw_x + offset.x, draw_y + offset.y)
        }
        sprite.draw(draw_x + offset.x, draw_y + offset.y)
    }
}

function BattleEnemy(_name, _sprite) : BattleEntity("", noone) constructor {
    name = _name
    sprite = _sprite
    
    action = BattleActions.ATTACK
    
    attacked = false
    attack_anim_seconds = 1
    
    die = function() {
        with(battle) {
            for(var i = 0; i < array_length(enemies); i++){
                if(enemies[i] == other){
					array_delete(enemies, i, 1)
					redefine_targets()
				}
            }
        }
    }
    
    attack_state = function() {
        if(action_state == -1) action_state = BattleActionStates.ATTACK_WALKING
        if(target == -1) target = battle.units[irandom(array_length(battle.units) - 1)]
        
        var _targetx, _targety, _dir, _dist
        
        switch (action_state) {
            case BattleActionStates.ATTACK_WALKING:
                var _arrived = go_to_point(target.x + 24, target.y, 3)
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
                            var _damage = self.attack_damage * 4 // diminuindo dano se o parry der certo
                            self.target.take_dmg(_damage)
                        }
                        self.target.dodging = false
                        self.target.jumping = false
                        self.action_state = BattleActionStates.ATTACK_LEAVING
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
        
        if(dead){
            return
        }
        
        if(battle.state == BattleStates.ENEMY_ATTACKING and battle.enemies[battle.current_enemy] == self){
            
            switch(action){
                case BattleActions.ATTACK: attack_state(); break;
            }
        }
        
        if(hp > max_hp) hp = max_hp
    }
    
}


// ENTIDADES ESPECÍFICAS
function Guerreiro(_vida, _atk, _mag, ) : BattleUnit("", noone) constructor {
    hp = _vida
    max_hp = 130
    attack_damage = _atk
    
    attack_damage = _atk
    magic_damage = _mag
    
    sprite = new Sprite(spr_guerreiro_idle)
    
    available_actions = [
        BattleActions.ATTACK,
        BattleActions.CHARGE
    ]
    
    attack_action = function() {
        if(action_state == -1) action_state = BattleActionStates.ATTACK_WALKING
        
        switch (action_state) {
            case BattleActionStates.ATTACK_WALKING:
                
                if(sprite.sprite != spr_guerreiro_move) sprite.change(spr_guerreiro_move)
                
                var _arrived = go_to_point(target.x - 48, target.y, 2)
                if(_arrived) {
                    action_state = BattleActionStates.ATTACK_CHARGING
                    audio_play_sound(snd_jump, 1, 0)
                    
                    // adicionando animação de pulo
                    var _duration = charge_max / 60
                    var _jump_height = 24
                    
                    root.anim.add(
                        new Animation(self, "draw_x", draw_x, draw_x + 32, _duration)
                            .tag("guerreiro_pulo")
                    )
                    
                    root.anim.add(
                        new Animation(self, "draw_y", draw_y, draw_y - _jump_height, _duration / 2)
                            .ease(ease_out_quad)
                            .type(AnimationTypes.BOUNCE)
                            .tag("guerreiro_pulo")
                    )
                    
                    root.anim.add(
                        new Animation(self, "draw_y", draw_y - _jump_height, draw_y + 12, _duration / 2)
                            .delay(_duration / 2)
                            .ease(ease_in_quad)
                            .type(AnimationTypes.BOUNCE)
                            .tag("guerreiro_pulo")
                    )
                }
                break
                
            case BattleActionStates.ATTACK_CHARGING:
                if(!attacked){
                    charge++
                    var _charge_left = charge_max - charge
                    
                    if(keyboard_check_pressed(ord("Z")) or _charge_left <= 0){
                        
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
                        
                        root.anim.finish("guerreiro_pulo")
                        sprite.change(spr_guerreiro_ataque)
                        
                        var _remaining = charge / 60
                        
                        call_later(_remaining, time_source_units_seconds, 
                        function(){
                            if(concentrating) {
                                damage_to_deal *= 2.5
                                instance_create_depth(target.x, target.y - 12, -100, obj_explosion)
                            }
                            self.target.take_dmg(self.damage_to_deal, self.charge_max - self.charge > self.charge_excellent)
                            self.concentrating = false
                            call_later(1, time_source_units_seconds, function(){
                                self.sprite.change(spr_guerreiro_move)
								self.draw_y -= 14
                                self.sprite.xscale = -1
                                self.action_state = BattleActionStates.ATTACK_LEAVING
                            })
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
                    
                    sprite.change(spr_guerreiro_idle)
                    sprite.xscale = 1
                }
                break
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
    
    draw = function() {
        // draw_healthbar(draw_x - 9, draw_y + 4, draw_x + 8, draw_y + 8, charge / charge_max * 100, #081820, c_red, c_aqua, 0, true, true)
    }
}

function Mago(_vida, _atk, _mag) : BattleUnit("", noone) constructor {
    hp = _vida
    max_hp = 80
    
    attack_damage = _atk
    magic_damage = _mag
    
    sprite = new Sprite(spr_mago_idle)
    
    charge_max = 180
    magic_start_seconds = 2
    started_charging = false
    
    available_actions = [
        BattleActions.MAGIC,
        BattleActions.HEAL
    ]
    
    magic_action = function(){
        if(action_state == -1) action_state = BattleActionStates.MAGIC_STARTING
            
        if(!array_contains(battle.enemies, target)){
            action = -1
            target = -1
            finished_action = true
            call_later(1, time_source_units_frames, function(){self.finished_action = false})
            return
        }
        
        switch (action_state) {
            case BattleActionStates.MAGIC_STARTING:
                
                damage_to_deal = 0
                charge = charge_max
                
                if(!started_charging){
                    call_later(magic_start_seconds, time_source_units_seconds,
                    function(){self.action_state = BattleActionStates.MAGIC_CHARGING})
                    started_charging = true
                }
                break
                
            case BattleActionStates.MAGIC_CHARGING:
                charge--
                if(sprite.sprite != spr_mago_move) sprite.change(spr_mago_move)
                
                if(keyboard_check_pressed(vk_anykey)){
                    var _inc = .4
                    
                    damage_to_deal += _inc
                    audio_stop_sound(snd_blip)
                    audio_play_sound(snd_blip, 1, 0, .8, undefined, 1 + (damage_to_deal / 20))
                    /*var _plusind = instance_create_depth(draw_x + 6 + irandom_range(-3, 3), draw_y - 10, -1000, obj_mini_number_indicator)
                    _plusind.val = _inc*/
                }
                
                if(charge <= 0){
                    sprite.change(spr_mago_ataque)
                    action_state = BattleActionStates.MAGIC_RELEASE
                    
                    call_later(3, time_source_units_seconds, 
                    function(){
                        self.target.take_dmg(floor(damage_to_deal), (damage_to_deal > 30))
                        
                        self.action = -1
                        self.target = -1
                        self.action_state = -1
                        
                        self.started_charging = false
                        self.attacked = false
                        
                        self.sprite.change(spr_mago_idle)
                        
                        call_later(1, time_source_units_seconds,
                        function(){self.finished_action = true})
                    })
                }
                break
            
            case BattleActionStates.MAGIC_RELEASE:
                if(!attacked){
                    attacked = true
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
    
    update = function(){
        if(action == BattleActions.MAGIC){
            if(action_state == BattleActionStates.MAGIC_CHARGING){
                sprite.xscale = wave(1.1 + (damage_to_deal / 20), 1, 1)
                sprite.yscale = wave(1, 1.1 + (damage_to_deal / 20), 1)
                
                var _shake = .5 + (damage_to_deal / 30)
                offset.x = irandom_range(-_shake, _shake)
                offset.y = irandom_range(-_shake, _shake)
                
            }else{
                sprite.xscale = 1
                sprite.yscale = 1
                offset.x = 0
                offset.y = 0
            }
        }
    }
}

function Dino() : BattleEnemy(250, noone) constructor {
    name = "Dino"
	sprite = new Sprite(spr_dino_idle)
	
	attack_anim_seconds = 1.5
	
	attack_state = function() {
        if(action_state == -1) action_state = BattleActionStates.ATTACK_WALKING
        if(target == -1) target = battle.units[irandom(array_length(battle.units) - 1)]
        
        var _targetx, _targety, _dir, _dist
        
        switch (action_state) {
            case BattleActionStates.ATTACK_WALKING:
                var _arrived = go_to_point(target.x + 32, target.y, 3)
                if(_arrived) {
                    action_state = BattleActionStates.ATTACK_CHARGING
                    
                    // adicionando animação de ataque
					var _tag = $"enemy:{entity_id}_attack_anim"
                    var _duration = attack_anim_seconds
                    var _back_distance = 16 
                    
                    root.anim.add(
                        new Animation(self.sprite, "yscale", 1, .8, _duration * (2 / 3))
							.ease(ease_out_sine)
                            .tag(_tag)
                    )
					
					root.anim.add(
                        new Animation(self.sprite, "yscale", .8, 1, _duration * (1 / 3))
							.delay(_duration * (2 / 3))
							.ease(ease_out_sine)
                            .tag(_tag)
                    )
					
                    root.anim.add(
                        new Animation(self, "draw_x", draw_x, draw_x + _back_distance, _duration * (2 / 3))
							.ease(ease_out_sine)
                            .tag(_tag)
                    )
                    
                    root.anim.add(
                        new Animation(self, "draw_x", draw_x + _back_distance, draw_x - 20, _duration * (1 / 3))
							.delay(_duration * (2 / 3))
                            .ease(ease_out_quart)
                            .tag(_tag)
                    )
                    
                }
                break
            
            case BattleActionStates.ATTACK_CHARGING:
                if(!attacked){
                    attacked = true
                    target.dodging = true
                    call_later(attack_anim_seconds - .3, time_source_units_seconds, 
                    function(){
                        if(!target.jumping){
                            var _damage = self.attack_damage * 4 // diminuindo dano se o parry der certo
                            self.target.take_dmg(_damage)
                        }
                        self.target.dodging = false
                        self.target.jumping = false
                        self.action_state = BattleActionStates.ATTACK_LEAVING
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
}


function start_battle(_units, _enemies) {
    var _inst = instance_create_depth(0, 0, -100, obj_battle)
    
    for(var i = 0; i < array_length(_units); i++){
        _units[i].battle = _inst
    }
    
    for(var i = 0; i < array_length(_enemies); i++){
        _enemies[i].battle = _inst
    }
    
    _inst.units = _units
    _inst.enemies = _enemies
    _inst.apply_start_anim()
}
