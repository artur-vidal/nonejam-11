enum AnimationTypes{
    SINGLE,
    BOUNCE,
    PATROL,
    LOOP,
    REPEAT,
    BOUNCE_MANY,
    REPEAT_MANY
}

function Animation(_target, _property, _from, _to, _duration) constructor{
    
    // variáveis base obrigatórias
    target = _target
    property = _property
    from = _from
    to = _to
    duration = _duration
    
    // variáveis opcionais com valor base
    anim_delay = 0
    anim_delay_in_between = false
    easing = ease_linear
    on_complete = undefined
    on_restart = undefined
    anim_type = AnimationTypes.SINGLE
    anim_tag = ""
    
    // funçoes para mudar opcionais
    delay = function(_val, _in_between = false){
        anim_delay = _val
        initial_delay = anim_delay
        anim_delay_in_between = _in_between
        return self
    }
    
    ease = function(_val){
        easing = _val
        return self
    }
    
    tag = function(_val){
        anim_tag = _val
        return self    
    }
    
    restart_callback = function(_val){
        on_restart = _val
        return self
    }
    
    complete_callback = function(_val){
        on_complete = _val
        return self
    }
    
    type = function(_val){
        anim_type = _val
        return self
    }
    
    repeats = function(_val){
        repeat_times = _val
        return self
    }
    
    // variáveis sem alteração manual
    time = 0
    done = false
    repeat_times = 0
    
    start_from = from
    start_to = to
    initial_delay = anim_delay
    
    bounce_step = 0 // 0 - primeira parte; 1 - segunda parte; 2 - completou um 'loop'
    
    // utilitárias
    switch_from_to = function(){
        var _temp = from
        from = to
        to = _temp
    }
    
    slide_from_to = function(){
        var _temp = start_to - start_from
        from = to
        to += _temp
    }
    
    reset = function(_callback = true){
        time = 0
        if(anim_delay_in_between) anim_delay = initial_delay 
        if(_callback and is_callable(on_restart)) on_restart()
    }
    
    // função principal de atualização
    update = function(){
        
        if(!done){
            if(anim_delay > 0){
                anim_delay -= DT
                return
            }
            
            time += DT
            
            var _val = easing(time, from, to - from, duration)
            if(is_struct(target)) target[$ property] = _val
            else variable_instance_set(target, property, _val)
            
            // acabo a função aqui caso o tempo ainda esteja rodando.
            if(time / duration < 1)
                return
        }
        
        switch(anim_type){
            
            // roda apenas uma vez
            case AnimationTypes.SINGLE:
                done = true
                break
            
            // vai e volta até cancelar
            case AnimationTypes.PATROL:
                switch_from_to()
                reset(false)
                
                if(bounce_step < 2) bounce_step++
                else{
                    bounce_step = 0
                    if(is_callable(on_restart)) on_restart()
                }
                break
            
            // roda a animação múltiplas vezes até cancelar
            case AnimationTypes.LOOP:
                reset()
                break
            
            // roda múltiplas vezes, mas reinicia do final ao invés do começo
            case AnimationTypes.REPEAT:
                slide_from_to()
                reset()
                break
            
            // vai e volta X vezes (determinado por repeat_times)
            case AnimationTypes.BOUNCE:
                if(repeat_times > 0){
                    switch_from_to()
                    reset(false)
                    
                    if(bounce_step < 2) bounce_step++
                    else{
                        bounce_step = 0
                        if(is_callable(on_restart)) on_restart()
                        repeat_times--
                    }
                    
                    break
                }
                
                done = true
                break
            
            // repete baseado no fim X vezes (determinado por repeat_times)
            case AnimationTypes.REPEAT_MANY:
                if(repeat_times > 0){
                    slide_from_to()
                    reset()
                    repeat_times--
                    
                    break
                }
                
                done = true
                break
        }
    }
    
    return self
}

function AnimationRunner() constructor{
    elements = []
    
    add = function(){
        for(var i = 0; i < argument_count; i++) {
            array_push(elements, argument[i])
        }
    }
    
    run = function(){
        for(var i = 0; i < array_length(elements); i++){
            var _cur_elm = elements[i]
            
            // atualizando cada animação
            _cur_elm.update()
            
            // colocando apenas animações ainda restantes no array
            if(_cur_elm.done){
                if(is_callable(_cur_elm.on_complete)) _cur_elm.on_complete()
                array_delete(elements, i, 1)
            }
        }
    }
    
    has_animation = function(_tag){
        for(var i = 0; i < array_length(elements); i++){
            if(elements[i].anim_tag == _tag) return true
        } 
        return false
    }
    
    // transforma todas as animações com a tag em finalizadas
    finish = function(_tag){
        for(var i = 0; i < array_length(elements); i++){
            var _cur_elm = elements[i]
            if(_cur_elm.anim_tag == _tag){
                if(is_struct(_cur_elm.target)) _cur_elm.target[$ _cur_elm.property] = _cur_elm.to
                else variable_instance_set(_cur_elm.target, _cur_elm.property, to)
                
                _cur_elm.done = true
            }
        }
    }
    
    // remove todas as animações com a tag
    cancel = function(_tag){
        for(var i = 0; i < array_length(elements); i++){
            if(elements[i].anim_tag == _tag) array_delete(elements, i, 1)
        }
    }
}
