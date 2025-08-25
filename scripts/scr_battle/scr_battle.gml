enum BattleStates {
    STARTING,
    PLAYER_TURN,
    PLAYER_ACT,
    ENEMY_ATTACKING,
	DIALOGUE,
	END,
    GAME_OVER
}

enum BattleActions {
    ATTACK,
    MAGIC,
    HEAL,
    CHARGE,
    MEDITATE,
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

enum BattleBossActions {
    JUMP_ATTACK,
    TACKLE,
    BEAM,
    CHARGE
}

enum BattleBossActionStates {
    CHARGE_ANIM,
    JUMP_PREP,
    JUMP_JUMP,
    JUMP_LAND,
    JUMP_LEAVE,
    BEAM_PREP,
    BEAM_ATTACK,
    BEAM_LEAVING
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
    
    mana = 20
    max_mana = 20
    
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
    draw_x = -100
    draw_y = -100
    offset = {
        x : 0,
        y : 0,
    }
	
	default_sprite = noone
	hurt_sprite = noone
	dead_sprite = noone
    happy_sprite = noone
    
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
        if(time_with_shield == clamp(time_with_shield, 1, 6)){
            audio_play_sound(snd_parry, 1, 0, 1.3)
            reduction = 0
            battle.draw_black_overlay = 8
            if(hp < max_hp) heal(round(max_hp * 0.15))
        } else {
            var _snd
            if(time_with_shield > 0)_snd = snd_block
            else if (_crit) _snd = snd_crit
            else _snd = snd_hurt
            
            audio_play_sound(_snd, 1, 0)
            
            sprite.color = c_red
			if(hurt_sprite != noone and _dmg * reduction <= hp - max_hp){
				sprite.change(hurt_sprite)
				call_later(1, time_source_units_seconds, 
				function(){self.sprite.change(default_sprite)})
			}
        }
        
        var _final_dmg = _dmg * reduction
        hp -= _final_dmg
        create_indicator(x + offset.x, y + offset.y - 12, -_final_dmg)
        
        if(hp <= 0){
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
    
    use_mana = function(_val) {
        audio_play_sound(snd_charge, 1, 0)
        sprite.color = c_blue
        mana -= _val
        create_indicator(x, y - 8, -_val, true)
    }
    
    die = function() {
        
    }
	
	revive = function() {
		dead = false
		heal(max_hp / 2)
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
    
    charge_ok = charge_max / 2
    charge_good = charge_max / 4
    charge_excellent = charge_max / 6
    
    attacked = false
    damage_to_deal = 0
    attack_anim_seconds = 1
    
    started_healing = false
    healed = false
    heal_anim_seconds = 1
	turns_to_revive = 2
    
    dodging = false
    jumping = false
    jump_height = 16
    jump_duration = .2
    
    concentrating = false
    charge_anim_seconds = 1
    started_charging = false
    
    fire_sprite = new Sprite(spr_fire)
    fire_sprite.alpha = .8
    
    shield_sprite = new Sprite(spr_shield)
    draw_shield = false
    
    turns_to_revive = 0
     
    root.anim.add(
        new Animation(self.fire_sprite, "xscale", .6, .9, 1.7)
            .ease(ease_in_out_quad)
            .type(AnimationTypes.PATROL),
        
        new Animation(self.fire_sprite, "yscale", 1, .7, 2)
            .ease(ease_in_out_quad)
            .type(AnimationTypes.PATROL)
    )
    
    die = function() {
        if(dead_sprite != noone) sprite.change(dead_sprite)
        
        audio_play_sound(snd_explosion, 1, 0)
        turns_to_revive = 3
        battle.turn_particles_on(x, y, 30)
        battle.draw_black_overlay = 8
    }
    
    attack_action = function() {
        
    }
    
    heal_action = function() {
        
    }
    
    charge_action = function() {    
        
    }
    
    magic_action = function() {
        
    }
    
    meditate_action = function() {
        
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
        
        hp = clamp(hp, 0, max_hp)
        mana = clamp(mana, 0, max_mana)
            
        if(!dead){
            if(battle.units[battle.current_unit] == self){
                
                if(battle.state == BattleStates.PLAYER_ACT){
                    switch(action){
                        case BattleActions.ATTACK: attack_action(); break;
                        case BattleActions.MAGIC: magic_action(); break;
                        case BattleActions.HEAL: heal_action(); break;
                        case BattleActions.CHARGE: charge_action(); break;
                        case BattleActions.MEDITATE: meditate_action(); break;
                    }
                }else if(dead){
    				finished_action = true;
    			}
                
            } 
            
            if(dodging and !jumping) {
                
                if(keyboard_check_pressed(ord("Z"))){
                    jumping = true
                    audio_play_sound(snd_jump, 1, 0)
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
                    if(time_with_shield == 0){
                        audio_play_sound(snd_pick_shield, 1, 0)
                    }
                    
                    draw_shield = true
                    reduction = 0.6
                    time_with_shield++
                } else {
                    draw_shield = false
                    reduction = 1
                    time_with_shield = 0
                }
            } else{
                draw_shield = false
            }
        } else {
            if(battle.state == BattleStates.PLAYER_ACT and battle.units[battle.current_unit] == self){
                finished_action = true
                turns_to_revive = approach(turns_to_revive, 0, 1)
                
                if(turns_to_revive > 0) {
                    audio_play_sound(snd_tick, 1, 0, .6)
                    create_indicator(x, y - 10, turns_to_revive, true)
                } else if(turns_to_revive == 0){
                    create_indicator(x, y, "REVIVER", true)
                    heal(max_hp * 0.5)
                    sprite.change(default_sprite)
                    dead = false
                    call_later(2, time_source_units_frames,
                    function(){self.finished_action = false})
                }
            }
        }
        
        
        
        fire_sprite.animate(1)
    }
    
    main_draw = function() { // não deve ser substituída (mas eu substituí mesmo assim lol lmao xd)
        if(concentrating){
            fire_sprite.draw(draw_x + offset.x, draw_y + offset.y)
        }
        sprite.draw(draw_x + offset.x, draw_y + offset.y)
        if(draw_shield){
            shield_sprite.draw(draw_x + offset.x + 6, draw_y + offset.y + wave(1, 3, 1))
        }
    }
}

function BattleEnemy(_name, _sprite) : BattleEntity("", noone) constructor {
    name = _name
    sprite = _sprite
    
    action = BattleActions.ATTACK
    
    attacked = false
    attack_anim_seconds = 1
    
    find_alive_target = function() {
        if(battle.units[0].dead and battle.units[1].dead){
            finished_action = true
            return
        }
        do {
            target = battle.units[irandom(array_length(battle.units) - 1)]
        } until(!target.dead)
    }
    
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
        if(mana > max_mana) mana = max_mana
    }
    
}



// ENTIDADES ESPECÍFICAS
function Guerreiro(_vida, _atk, _mag) : BattleUnit("Gui", noone) constructor {
    hp = _vida
    max_hp = 130
    attack_damage = _atk
    
    attack_damage = _atk
    magic_damage = _mag
    
    sprite = new Sprite(spr_guerreiro_idle)
    
    available_actions = [
        BattleActions.ATTACK
    ]
    
	default_sprite = spr_guerreiro_idle
	hurt_sprite = spr_guerreiro_hit
    dead_sprite = spr_guerreiro_morte
    happy_sprite = spr_guerreiro_win
    
    manual_hit = false
	
    attack_action = function() {
        if(action_state == -1) action_state = BattleActionStates.ATTACK_WALKING
        
        switch (action_state) {
            case BattleActionStates.ATTACK_WALKING:
                
                sprite.change(spr_guerreiro_move)
                sprite.image_spd = 2
                
                var _arrived = go_to_point(target.x - 48, target.y, 2)
                if(_arrived) {
                    action_state = BattleActionStates.ATTACK_CHARGING
                    audio_play_sound(snd_jump, 1, 0)
                    
                    sprite.change(spr_guerreiro_prep_ataque)
                    
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
                        
                        if(keyboard_check_pressed(ord("Z"))) manual_hit = true
                            
                        if(_charge_left > 0){
                            if(_charge_left < charge_excellent){
                                damage_to_deal = attack_damage * 3 * 1.5
                            } else if(_charge_left < charge_good) {
                                damage_to_deal = attack_damage * 3
                            } else if(_charge_left < charge_ok) {
                                damage_to_deal = attack_damage * 3 * 0.75
                            } else {
                                damage_to_deal = attack_damage * 3 * 0.3
                            }
                        } else {
                            damage_to_deal = attack_damage
                        }
                        
                        attacked = true
                        
                        root.anim.finish("guerreiro_pulo")
                        sprite.change(spr_guerreiro_ataque)
                        
                        call_later(1, time_source_units_frames, 
                        function(){
                            var _was_excellent = (self.charge_max - self.charge < self.charge_excellent and manual_hit)
                            
                            if(concentrating) damage_to_deal *= 2.5
                            
                            if(_was_excellent){
                                battle.turn_particles_on(target.x, target.y, 30)
                                battle.draw_black_overlay = 8
                                audio_play_sound(snd_excellent, 1, 0, 1, undefined, .8, 1.1)
                            }
                            
                            self.target.take_dmg(self.damage_to_deal, _was_excellent)
                            self.concentrating = false
                            call_later(1, time_source_units_seconds, function(){
                                self.sprite.change(spr_guerreiro_move)
                                self.sprite.image_spd = 2
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
                    manual_hit = false
                    
                    attacked = false
                    charge = 0
                    finished_action = true
                    
                    sprite.change(spr_guerreiro_idle)
                    sprite.image_spd = 1
                    sprite.xscale = 1
                }
                break
        }
    }
    
    charge_action = function() {
        if(action_state == -1){
            action_state = BattleActionStates.CHARGE_ANIM
        }
            
        switch(action_state) {
            case BattleActionStates.CHARGE_ANIM:
                if(!started_charging){
                    call_later(1, time_source_units_seconds,
                    function(){
                        self.use_mana(4)
                        
                        self.action = -1
                        self.target = -1
                        self.action_state = -1
                        
                        self.concentrating = true
                        self.started_charging = false
                        
                        call_later(1, time_source_units_seconds,
                        function(){self.finished_action = true})
                    }) 
                    started_charging = true
                }
                break;
        }
    }
    
    draw = function() {
        // draw_healthbar(draw_x - 9, draw_y + 4, draw_x + 8, draw_y + 8, charge / charge_max * 100, #081820, c_red, c_aqua, 0, true, true)
        sprite.animate(2)
    }
}

function Mago(_vida, _atk, _mag) : BattleUnit("Meg", noone) constructor {
    hp = _vida
    max_hp = 80
    
    mana = 60
    max_mana = 60
    
    attack_damage = _atk
    magic_damage = _mag
    
    sprite = new Sprite(spr_mago_idle)
    
    charge_max = 300
    magic_start_seconds = 2
    started_charging = false
    
    available_actions = [
        BattleActions.MAGIC,
        BattleActions.MEDITATE
    ]
	
	default_sprite = spr_mago_idle
	hurt_sprite = spr_mago_hit
    dead_sprite = spr_mago_morte
    happy_sprite = spr_mago_win
    
    magic_action = function(){
        if(!array_contains(battle.enemies, target) or target == -1){
            action = -1
            target = -1
            finished_action = true
            call_later(2, time_source_units_frames, function(){self.finished_action = false})
            return
        }
        
        if(action_state == -1){
            use_mana(12)
            action_state = BattleActionStates.MAGIC_STARTING
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
                sprite.change(spr_mago_move)
                
                if(keyboard_check_pressed(vk_anykey)){
                    var _inc = .2
					
					create_indicator(irandom_range(x - 12, x + 12), y, keyboard_lastchar, true)
                    
                    damage_to_deal += _inc
                    audio_stop_sound(snd_blip)
                    audio_play_sound(snd_blip, 1, 0, .8, undefined, 1 + (damage_to_deal / 20))
                }
                
                if(charge <= 0){
                    
                    action_state = BattleActionStates.MAGIC_RELEASE
                    
                    sprite.image_spd = 0
                    sprite.change(spr_mago_ataque)
                    sprite.offset.x = 0;
                    
                    var _circs = floor(point_distance(x, y, target.x + target.offset.x, target.y + target.offset.y) / 6)
                    create_beam(x + 12, y - 8, point_direction(x, y, target.x, target.y - 8), _circs, 2)
                    
                    call_later(1.35, time_source_units_seconds, 
                    function(){
                        self.damage_to_deal *=  (magic_damage / 5)
                        self.target.take_dmg(floor(damage_to_deal), (damage_to_deal > 30))
                        
                        if(damage_to_deal > 55){
                            battle.turn_particles_on(target.x, target.y, 30)
                            battle.draw_black_overlay = 8
                            audio_play_sound(snd_excellent, 1, 0, 1, undefined, .8, 1.1)
                        }
                        
                        self.action = -1
                        self.target = -1
                        self.action_state = -1
                        
                        self.started_charging = false
                        self.attacked = false
                        
                        self.sprite.change(spr_mago_idle)
                        
                        call_later(1, time_source_units_seconds,
                        function(){self.finished_action = true; self.sprite.image_spd = 1;})
                    })
                }
                break
            
            case BattleActionStates.MAGIC_RELEASE:
                // n tem nada aqui pois sou meio desprovido
                break
        }
    }
    
    heal_action = function() {
        if(action_state == -1){
            action_state = BattleActionStates.HEAL_STARTING
            use_mana(8)
        }
            
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
                    target.heal(magic_damage * 3)
                    target.sprite.change(target.happy_sprite)
                    
                    target.sprite.color = c_lime
                    healed = true
                    
                    call_later(2, time_source_units_seconds, function(){
                        self.target.sprite.change(self.target.default_sprite)
                        
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
    
    meditate_action = function() {
        if(action_state == -1){
            action_state = BattleActionStates.CHARGE_ANIM
        }
            
        switch(action_state) {
            case BattleActionStates.CHARGE_ANIM:
                if(!started_charging){
                    call_later(1, time_source_units_seconds,
                    function(){
                        self.use_mana(-20)
                        
                        self.action = -1
                        self.target = -1
                        self.action_state = -1
                        
                        self.started_charging = false
                        
                        call_later(2, time_source_units_seconds,
                        function(){self.finished_action = true})
                    }) 
                    started_charging = true
                }
                break;
        }
    }
    
    update = function(){
        if(action == BattleActions.MAGIC){
            if(action_state == BattleActionStates.MAGIC_CHARGING){
                sprite.xscale = wave(1.1 + (damage_to_deal / 30), 1, 1)
                sprite.yscale = wave(1, 1.1 + (damage_to_deal / 30), 1)
                
                var _shake = .5 + (damage_to_deal / 25)
                offset.x = irandom_range(-_shake, _shake)
                offset.y = irandom_range(-_shake, _shake)
                
                var _sproff = wave(-10, 10, 4, damage_to_deal / 5)
                sprite.offset.x = _sproff
                sprite.xscale = (_sproff != 0) ? sign(_sproff) : 1
                
            }else{
                sprite.xscale = 1
                sprite.yscale = 1
                offset.x = 0
                offset.y = 0
            }
        }
    }
    
    draw = function(){
        sprite.animate(2)
    }
}

function Dino() : BattleEnemy("Dino", noone) constructor {
    hp = 150
    max_hp = 150
    
	sprite = new Sprite(spr_dino_move)
    sprite.image_spd = .2
	
    attack_damage = 12
    
	attack_anim_seconds = 1
	
    my_delay = .25 * irandom(1_000)
    
    default_sprite = spr_dino_move
    hurt_sprite = spr_dino_hit
    
	attack_state = function() {
        if(action_state == -1) action_state = BattleActionStates.ATTACK_WALKING
        if(target == -1) find_alive_target()
        
        var _targetx, _targety, _dir, _dist
        
        switch (action_state) {
            case BattleActionStates.ATTACK_WALKING:
                var _arrived = go_to_point(target.x + 32, target.y, 1)
                
                if(target != -1) target.dodging = true
                
                if(_arrived) {
                    sprite.image_spd = 0
                    sprite.change(spr_dino_attack)
                    sprite.image_ind = 0
                    action_state = BattleActionStates.ATTACK_CHARGING
                    
                    // adicionando animação de ataque
					var _tag = $"enemy:{entity_id}_attack_anim"
                    var _duration = attack_anim_seconds
                    var _back_distance = 16 
                    
                    root.anim.add(
                        new Animation(self.sprite, "yscale", 1, .7, _duration * (2 / 3))
							.ease(ease_out_sine)
                            .tag(_tag)
                    )
					
					root.anim.add(
                        new Animation(self.sprite, "yscale", .7, 1, _duration * (1 / 3))
							.delay(_duration * (2 / 3))
							.ease(ease_out_sine)
                            .tag(_tag)
                    )
					
                    root.anim.add(
                        new Animation(self, "draw_x", draw_x, draw_x + _back_distance, _duration * (2 / 3))
							.ease(ease_out_sine)
                            .tag(_tag)
                            .complete_callback(function(_){_.sprite.image_ind = 1})
                            .callback_args(self)
                    )
                    
                    root.anim.add(
                        new Animation(self, "draw_x", draw_x + _back_distance, draw_x - 20, _duration * (1 / 3))
							.delay(_duration * (2 / 3))
                            .ease(ease_out_cubic)
                            .tag(_tag)
                    )
                    
                }
                break
            
            case BattleActionStates.ATTACK_CHARGING:
                if(!attacked){
                    attacked = true
                    call_later(attack_anim_seconds - .2, time_source_units_seconds, 
                    function(){
                        self.sprite.image_spd = 2
                        self.sprite.xscale = -1
                        self.sprite.change(spr_dino_move)
                        
                        if(!target.jumping){
                            var _damage = self.attack_damage * 3 // diminuindo dano se o parry der certo
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
                    sprite.image_spd = 1
                    sprite.xscale = 1
                    
                    target = -1
                    action_state = -1
                    
                    attacked = false
                    
                    finished_action = true
                }
                break
        }
    }
    
    update = function(){
        sprite.animate(4)
        if(battle.state != BattleStates.STARTING and action_state == -1){
            sprite.offset.x = wave(-4, 4, 2, my_delay)
        }
        
        if(dead){
            return
        }
        
        if(battle.state == BattleStates.ENEMY_ATTACKING and battle.enemies[battle.current_enemy] == self){
            
            switch(action){
                case BattleActions.ATTACK: attack_state(); break;
            }
        }
        
        if(hp > max_hp) hp = max_hp
        if(mana > max_mana) mana = max_mana
    }
}

function Peixe() : BattleEnemy("Peixe 'Voador'", noone) constructor {
    
    hp = 120
    max_hp = 120
    
	sprite = new Sprite(spr_peixe_idle)
	
    magic_damage = 8
    
    default_sprite = spr_peixe_idle
    hurt_sprite = spr_peixe_hit
	
	attack_state = function() {
        if(action_state == -1) action_state = BattleActionStates.ATTACK_WALKING
        if(target == -1) find_alive_target()
        
        var _targetx, _targety, _dir, _dist
        
        switch (action_state) {
            case BattleActionStates.ATTACK_WALKING:
                var _arrived = go_to_point(100, 70, 1)
                if(_arrived) {
                    action_state = BattleActionStates.ATTACK_CHARGING
                    
                    // adicionando animação de ataque
					var _tag = $"enemy:{entity_id}_attack_anim"
                    var _duration = attack_anim_seconds
                    
                }
                break
            
            case BattleActionStates.ATTACK_CHARGING:
                if(!attacked){
                    attacked = true
                    target.dodging = true
                    sprite.change(spr_peixe_ataque)
                    
                    create_beam(draw_x, draw_y - 8, point_direction(draw_x, draw_y, target.x, target.y), 12, 5)
                    
                    call_later(1, time_source_units_seconds, 
                    function(){
                        if(!target.jumping){
                            var _damage = self.magic_damage * 4
                            self.target.take_dmg(_damage)
                        }
                        self.target.dodging = false
                        self.target.jumping = false
                        
                        call_later(1, time_source_units_seconds,
                        function(){self.action_state = BattleActionStates.ATTACK_LEAVING})
                    })
                }
                break
            
            case BattleActionStates.ATTACK_LEAVING:
                var _arrived = go_to_point(x, y, 2)
                if(_arrived){
                    sprite.change(spr_peixe_idle)
                    
                    target = -1
                    action_state = -1
                    
                    attacked = false
                    finished_action = true
                }
                break
        }
    }
    
    update = function() {
        
        sprite.animate(2)
        offset.y = wave(-4, -10, 3, .2 * entity_id)
        
        if(dead){
            return
        }
        
        if(battle.state == BattleStates.ENEMY_ATTACKING and battle.enemies[battle.current_enemy] == self){
            
            switch(action){
                case BattleActions.ATTACK: attack_state(); break;
            }
        }
        
        if(hp > max_hp) hp = max_hp
        if(mana > max_mana) mana = max_mana
    }
}

function Cavaleiro() : BattleEnemy("O Cavaleiro", noone) constructor {
    
    hp = 350
    max_hp = 350
    
    sprite = new Sprite(spr_arm_peito_idle)
    sprite.offset.y = -1
    sprite.xscale = 1.5
    sprite.yscale = 1.5
    
    cabeca = -1
    pernas = -1
    
    offset.y = -16
    offset.x = -4
    
    action = -1
    
    ghost_time = 15
    ghost_timer = ghost_time
    draw_ghost = false
    
    attack_damage = 20
    magic_damage = 20
    
    started_charging = false
    concentrating = false
    
    fire_sprite = new Sprite(spr_fire)
    fire_sprite.alpha = .8
    
    started_jump = false
    
    root.anim.add(
        new Animation(self.fire_sprite, "xscale", 2, 3, 3)
            .ease(ease_in_out_quad)
            .type(AnimationTypes.PATROL),
        
        new Animation(self.fire_sprite, "yscale", 4, 1.5, 4.2)
            .ease(ease_in_out_quad)
            .type(AnimationTypes.PATROL)
    )
    
    die = function() {
        dead = true
    }
    
    jump_state = function() {
        if(action_state == -1) action_state = BattleBossActionStates.JUMP_PREP
        if(target == -1) find_alive_target()
        
        var _targetx, _targety
        
        switch (action_state) {
            case BattleBossActionStates.JUMP_PREP:
                if(!started_jump){
                    
                    // tirando concentracao
                    concentrating = false
                    draw_ghost = false
                    
                    audio_play_sound(snd_pick_shield, 1, 0)
                    pernas.sprite.change(spr_arm_bota_prep)
                    pernas.sprite.offset.y -= 4
                    offset.y += 4
                    
                    started_jump = true
                    
                    call_later(2, time_source_units_seconds,
                    function(){
                        // restaurando offset
                        offset.y -= 4
                        
                        // pulano
                        pernas.sprite.change(spr_arm_bota_pulo)
                        pernas.sprite.offset.y += 16
                        
                        audio_play_sound(snd_cavaleiro_jump, 1, 0)
                        action_state = BattleBossActionStates.JUMP_JUMP
                    })
                }
                break
            
            case BattleBossActionStates.JUMP_JUMP:
                target.dodging = true
                var _arrived = go_to_point(draw_x, y - 750, 6)
                if(_arrived) {
                    audio_play_sound(snd_cavaleiro_land, 1, 0)
                    
                    action_state = BattleBossActionStates.JUMP_LAND
                }
                break
            
            case BattleBossActionStates.JUMP_LAND:
                var _arrived = go_to_point(target.x + 32, target.y - 20, 6)
                if(_arrived and !attacked){
                    audio_play_sound(snd_explosion, 1, 0)
                    battle.draw_black_overlay = 20
                    obj_camera.turn_shake_on(60, 4)
                    
                    pernas.sprite.change(spr_arm_bota_ataque)
                    pernas.sprite.offset.y -= 16
                    
                    // dando dano
                    target.take_dmg(attack_damage * 3.8)
                    target.dodging = false
                    target.jumping = false
                    
                    call_later(2, time_source_units_seconds,
                    function(){
                        // redefinindo sprite
                        self.pernas.sprite.change(spr_arm_bota_idle)
                        self.pernas.sprite.offset.y = 50
                        self.action_state = BattleBossActionStates.JUMP_LEAVE
                    })
                    
                    attacked = true
                }
                break
            
            case BattleBossActionStates.JUMP_LEAVE:
                var _arrived = go_to_point(x, y, 6)
                if(_arrived){
                    
                    action = -1
                    target = -1
                    action_state = -1
                    
                    attacked = false
                    started_jump = false
                    finished_action = true
                }
                break
        }
    }
    
    beam_state = function() {
        if(action_state == -1) action_state = BattleBossActionStates.BEAM_PREP
        if(target == -1) find_alive_target()
        
        var _targetx, _targety, _dir, _dist
        
        switch (action_state) {
            case BattleBossActionStates.BEAM_PREP:
                var _arrived = go_to_point(110, 70, .25)
                if(_arrived) {
                    action_state = BattleBossActionStates.BEAM_ATTACK
                    
                    sprite.image_spd = 3
                    sprite.change(spr_arm_peito_ataque)
                    
                    pernas.sprite.change(spr_arm_bota_ataque)
                    pernas.offset.y -= 6
                    offset.y += 6
                    
                    audio_play_sound(snd_pick_shield, 1, 0)
                }
                break
            
            case BattleBossActionStates.BEAM_ATTACK:
                if(!attacked){
                    attacked = true
                    target.dodging = true
                    
                    create_beam(draw_x, draw_y - 8, point_direction(draw_x, draw_y, target.x, target.y), 13, 4)
                    
                    call_later(1, time_source_units_seconds, 
                    function(){
                        if(!target.jumping){
                            var _damage = self.magic_damage * 4
                            self.target.take_dmg(_damage)
                        }
                        self.battle.draw_black_overlay = 8
                        obj_camera.turn_shake_on(30, 3)
                        audio_play_sound(snd_explosion, 1, 0)
                        self.target.dodging = false
                        self.target.jumping = false
                        
                        call_later(1, time_source_units_seconds,
                        function(){self.action_state = BattleBossActionStates.BEAM_LEAVING})
                    })
                }
                break
            
            case BattleBossActionStates.BEAM_LEAVING:
                var _arrived = go_to_point(x, y, .25)
                if(_arrived){
                    
                    // redefinindo sprite
                    sprite.image_spd = 1
                    sprite.change(spr_arm_peito_idle)
                    
                    pernas.sprite.change(spr_arm_bota_idle)
                    pernas.offset.y += 6
                    offset.y -= 6
                    
                    action = -1
                    target = -1
                    action_state = -1
                    
                    attacked = false
                    finished_action = true
                }
                break
        }
    }
    
    charge_state = function() {
        if(action_state == -1){
            action_state = BattleBossActionStates.CHARGE_ANIM
        }
        
        switch(action_state) {
            case BattleBossActionStates.CHARGE_ANIM:
                if(!started_charging){
                    audio_play_sound(snd_pick_shield, 1, 0)
                    
                    pernas.sprite.change(spr_arm_bota_prep)
                    pernas.offset.y -= 4
                    offset.y += 4
                    
                    call_later(1, time_source_units_seconds,
                    function(){
                        self.battle.draw_black_overlay = 8
                        self.pernas.sprite.change(spr_arm_bota_idle)
                        audio_play_sound(snd_charge, 1, 0, 1, undefined, .6)
                        
                        self.pernas.offset.y += 4
                        self.offset.y -= 4
                        
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
    
    main_update = function() {
        if(!dead){
            // voltando a cor da sprite
            var _r = color_get_red(sprite.color)
            var _g = color_get_green(sprite.color)
            var _b = color_get_blue(sprite.color)
            
            _r = approach(_r, 255, 3)
            _g = approach(_g, 255, 3)
            _b = approach(_b, 255, 3)
            
            sprite.color = make_color_rgb(_r, _g, _b)
        } else {
            sprite.color = #346856
        }
        
        if(draw_ghost) ghost_timer--
    }
    
    update = function() {
        
        for(var i = 0; i < array_length(battle.enemies); i++){
            var _cur_enemy = battle.enemies[i]
            if(cabeca == -1 and is_instanceof(_cur_enemy, CavaleiroCabeca)){
                cabeca = _cur_enemy
                continue
            }
            
            if(pernas == -1 and is_instanceof(_cur_enemy, CavaleiroPernas)){
                pernas = _cur_enemy
                pernas.sprite.offset.y = 50
                continue
            }
        }
        
        if(cabeca != -1) {
            cabeca.x = x
            cabeca.y = y - 32
            
            cabeca.draw_x = cabeca.x
            cabeca.draw_y = cabeca.y
        }
        
        if(pernas != 1) {
            pernas.x = x
            pernas.y = y + 32
            
            pernas.draw_x = pernas.x
            pernas.draw_y = pernas.y
        }
        
        if(pernas.dead) {
            concentrating = false
            draw_ghost = false
        }
        
        if(hp > max_hp) hp = max_hp
        
        if(battle.state == BattleStates.ENEMY_ATTACKING and battle.enemies[battle.current_enemy] == self){
            
            if(action == -1){
                if(!concentrating){
                    if(!pernas.dead){
                        action = choose(BattleBossActions.BEAM, BattleBossActions.BEAM, BattleBossActions.CHARGE)
                    } else {
                        action = choose(BattleBossActions.BEAM)
                    }
                } else { 
                    action = BattleBossActions.JUMP_ATTACK
                }
            }
            
            switch(action){
                case BattleBossActions.BEAM: beam_state(); break;
                case BattleBossActions.CHARGE: charge_state(); break;
                case BattleBossActions.JUMP_ATTACK: jump_state(); break;
            }
        }
        
        if(concentrating){
            offset.x = wave(-2, 2, .4)
            fire_sprite.animate(1)
        }
    }
    
    main_draw = function() {
        if(concentrating){
            fire_sprite.draw(draw_x + offset.x, draw_y + offset.y + 50)
        }
        
        // pernocas
        var _pxoff = (battle.state != BattleStates.STARTING) ? pernas.offset.x : 0
        var _pyoff = (battle.state != BattleStates.STARTING) ? pernas.offset.y : 0
        
        pernas.sprite.xscale = -1
        pernas.sprite.draw(draw_x + offset.x + _pxoff - 12 - wave(0, 2, 5), draw_y + offset.y + _pyoff)
        
        pernas.sprite.xscale = 1
        pernas.sprite.draw(draw_x + offset.x + _pxoff + 12 + wave(0, 2, 5), draw_y + offset.y + _pyoff)
        pernas.sprite.animate(2)
        
        // corpo
        sprite.rotation = wave(-1, 3, 7)
        sprite.offset.y = 8 + wave(0, 2, 4)
        sprite.draw(draw_x + offset.x, draw_y + offset.y)
        sprite.animate(2)
        
        // cabeça
        var _cxoff = (battle.state != BattleStates.STARTING) ? cabeca.offset.x : 0
        var _cyoff = (battle.state != BattleStates.STARTING) ? cabeca.offset.y : 0
        
        cabeca.sprite.rotation = wave(-2, 6, 7)
        cabeca.sprite.offset.y = wave(0, 2, 4)
        
        cabeca.sprite.draw(draw_x + offset.x + _cxoff, draw_y + offset.y + _cyoff)
        cabeca.sprite.animate(1)
        
        // criando sprites
        /*
        if(ghost_timer <= 0){
            ghost_timer = ghost_time
            
            // cabeca
            var _cab = instance_create_depth(draw_x + offset.x, draw_y + offset.y + cabeca.sprite.offset.y, battle.depth - 100, obj_vanishing_sprite)
            _cab.sprite_index = cabeca.sprite.sprite
            _cab.image_index = cabeca.sprite.image_ind
            _cab.image_angle = cabeca.sprite.rotation
            
            // corpo
            var _corpo = instance_create_depth(draw_x + offset.x, draw_y + offset.y + sprite.offset.y, battle.depth - 100, obj_vanishing_sprite)
            _corpo.sprite_index = sprite.sprite
            _corpo.image_index = sprite.image_ind
            _corpo.image_angle = sprite.rotation
            _corpo.image_xscale = 1.5
            _corpo.image_yscale = 1.5
            
            // pernas
            var _p1 = instance_create_depth(draw_x + offset.x - 12 - wave(0, 2, 5), draw_y + offset.y + pernas.sprite.offset.y, battle.depth - 100, obj_vanishing_sprite)
            _p1.sprite_index = pernas.sprite.sprite
            _p1.image_index = pernas.sprite.image_ind
            _p1.image_xscale = -1
            
            
            var _p2 = instance_create_depth(draw_x + offset.x - 12 + wave(0, 2, 5), draw_y + offset.y + pernas.sprite.offset.y, battle.depth - 100, obj_vanishing_sprite)
            _p2.sprite_index = pernas.sprite.sprite
            _p2.image_index = pernas.sprite.image_ind
        }
        */
        
        // sombra do pulo
        if(action == BattleBossActions.JUMP_ATTACK and action_state == BattleBossActionStates.JUMP_LAND and !attacked){
            var _distance_mult = 1 + ((target.y - draw_y) / 300)
            draw_sprite_ext(spr_shadow, 0, target.x + 16, target.y, .8 * _distance_mult, _distance_mult, 0, c_white, .7)
        }
    }
    
}

function CavaleiroCabeca() : BattleEnemy("O Cavaleiro", noone) constructor {
    hp = 150
    max_hp = 150
    
    sprite = new Sprite(spr_arm_cabe_a_idle)
    
    finished_action = true 
    
    die = function() {
        dead = true
        battle.redefine_targets()
        sprite.offset.x = 1
    }
    
    main_update = function() {
        if(!dead){
            // voltando a cor da sprite
            var _r = color_get_red(sprite.color)
            var _g = color_get_green(sprite.color)
            var _b = color_get_blue(sprite.color)
            
            _r = approach(_r, 255, 3)
            _g = approach(_g, 255, 3)
            _b = approach(_b, 255, 3)
            
            sprite.color = make_color_rgb(_r, _g, _b)
        } else {
            sprite.color = #346856
        }
    }
    
    update = function() {
        finished_action = true
    }
    
    main_draw = function() {
        
    }
    
    draw = function() {
        
    }
}

function CavaleiroPernas() : BattleEnemy("O Cavaleiro", noone) constructor {
    hp = 300
    max_hp = 300
    
    sprite = new Sprite(spr_arm_bota_idle)
    
    finished_action = true
    
    die = function() {
        dead = true
        battle.redefine_targets()
        sprite.offset.x = 1
    }
    
    main_update = function() {
        if(!dead){
            // voltando a cor da sprite
            var _r = color_get_red(sprite.color)
            var _g = color_get_green(sprite.color)
            var _b = color_get_blue(sprite.color)
            
            _r = approach(_r, 255, 3)
            _g = approach(_g, 255, 3)
            _b = approach(_b, 255, 3)
            
            sprite.color = make_color_rgb(_r, _g, _b)
        } else {
            sprite.color = #346856
        }
    }
    
    update = function() { 
        show_debug_message(offset)
        show_debug_message(sprite.offset)
        finished_action = true
    }
    
    main_draw = function() {
        
    }
    
    draw = function() {
        
    }
}



// OUTROS
function UnitCard(_unit_link) constructor {
	static card_id = 0
	card_id++
	
	link = _unit_link
	anim_tag = $"unit_card:{card_id}_anim"
    
	// top-left
	width = 32
	height = 48
    
    x = 0
	y = 128 - height / 3
    
    resumo = false
	
	//root.anim.add(
		//new Animation(self, "y", 128, 128 - height / 3, 2)
            //.delay((root.first_battle) ? 5 : 1)
			//.ease(ease_out_cubic)
			//.tag(anim_tag)
	//)
    
    offset = {
        x : 0,
        y : 0
    }
	
	draw = function(_hp_diff = 0, _mana_diff = 0, _complementary_hp_string = "", _complementary_mana_string = "") {
        if(resumo) {
            _complementary_hp_string = ""
            _complementary_mana_string = ""
        }
        
        var _final_hp = clamp(link.hp + _hp_diff, -9999, link.max_hp)
        var _final_mana = clamp(link.mana - _mana_diff, -9999, link.max_mana)
        
		var _background_color = #E0F8D0
        
		var _hp_text_color = (_final_hp == link.hp) ? #081820 : #346856
		var _mana_text_color = (_final_mana == link.mana) ? #081820 : #346856
		
		// desenhando fundo com cabecinha redonda :/
		draw_set_color(_background_color)
		
		// a cabeça pega 1/3 da altura e o resto fica pro corpo
		draw_rectangle(x + offset.x, y + offset.y, x + width + offset.x, y + height + offset.y, false)
		
		draw_set_color(c_white)
		
		
        // nome
		var _name_text = scribble(link.name)
			.starting_format("fnt_default", #081820)
            .scale(.25)
            .padding(2, 2, 2, 2)
        
        _name_text.draw(x + offset.x, y + offset.y)
        draw_sprite(spr_heart, 0, x + offset.x + 2, y + offset.y + 8)
        
        // vida
		var _life_text = scribble($"{ceil(_final_hp)}{_complementary_hp_string}", $"hp_text{_final_hp}")
			.starting_format("fnt_default", _hp_text_color)
            .scale(.25)
            .padding(2, 2, 2, 2)
        
        if(resumo) {
            _life_text.align(2, 0)
            _life_text.draw(x + width + offset.x - 5, y + offset.y)
            draw_sprite(spr_heart, 0, x + width + offset.x - 6, y + offset.y + 2)
        } else {
            _life_text.align(0, 0)
            _life_text.draw(x + offset.x + 7, y + offset.y + 6)
            draw_sprite(spr_heart, 0, x + offset.x + 2, y + offset.y + 8)
        }
        
        // mana
		var _mana_text = scribble($"{_complementary_mana_string}{ceil(_final_mana)}", $"mana_text{_final_mana}")
			.starting_format("fnt_default", _mana_text_color)
            .scale(.25)
            .align(2, 0)
            .padding(2, 2, 2, 2)
        
        _mana_text.draw(x + width + offset.x - 6, y + offset.y + 12)
        draw_sprite(spr_mana, 0, x + width + offset.x - 6, y + offset.y + 14)
	}
}

function start_battle(_units, _enemies, _start_frames = 0, _song = msc_battle, _on_end = function(){audio_play_sound(msc_dungeon, 1, 1)}) {
	// tirando controle do player e manipulando câmera
	obj_player.control = false
	obj_camera.control_mode = "battle"
	
	audio_stop_all()
    
    // salvando informações iniciais
    root.prev_guerreiro_hp = root.guerreiro.hp
    root.prev_guerreiro_mana = root.guerreiro.mana
	
    var _inst = instance_create_depth(0, 0, -100, obj_battle)
    var _cards = [] // preencher com os cartões
	
    for(var i = 0; i < array_length(_units); i++){
        _units[i].battle = _inst
		array_push(_cards, new UnitCard(_units[i]))
    }
    
    for(var i = 0; i < array_length(_enemies); i++){
        _enemies[i].battle = _inst
    }
    
    _inst.units = _units
    _inst.enemies = _enemies
    
    // copiando todos os inimigos pro outro array
    for(var i = 0; i < array_length(_inst.enemies); i++){
        array_push(_inst.starting_enemies, variable_clone(_inst.enemies[i]))
    }
    
	_inst.cards = _cards
	_inst.music = _song
	_inst.delay_start = _start_frames
    _inst.on_end = _on_end
}

function end_battle() {
	obj_camera.control_mode = "dungeon"
	obj_camera.spawning = true
    
    obj_player.control = true
    obj_follow.following = true
    
    root.guerreiro.draw_x = -1000
    root.mago.draw_x = -1000
    
	instance_destroy(obj_battle)
}