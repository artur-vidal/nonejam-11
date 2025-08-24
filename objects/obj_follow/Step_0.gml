if(following){
    // --- detectar quando o player entrou em um novo tile (mesma lógica do seu player)
    var _pleft = obj_player.x - tile_size/2
    var _py    = obj_player.y
    
    if ( (_pleft % tile_size == 0) && (_py % tile_size == 0) ) {
        // mudou de tile?
        if (_pleft != curr_left || _py != curr_y) {
            // avança histórico
            prev_left = curr_left
            prev_y    = curr_y
            curr_left = _pleft
            curr_y    = _py
    
            // destino do aliado é SEMPRE o tile anterior do player
            target_x = prev_left + tile_size/2 // <-- aqui corrigimos o X (centro)
            target_y = prev_y
        }
    }
    
    // --- movimento (mesma cadência do seu player: vel/2 por step)
    var spd = max_vel / 2
    var _moved = false
    
    // mover estritamente em um eixo por vez (grid)
    if (x != target_x) {
        var dx = target_x - x
        if (abs(dx) <= spd) x = target_x
        else x += spd * sign(dx)
        
        var _moved = true
        
        // direção lateral
        sprite.change(spr_mago_mini_lado)
        sprite.xscale = (dx > 0) ? 1 : -1
    }
    else if (y != target_y) {
        var dy = target_y - y
        if (abs(dy) <= spd) y = target_y
        else y += spd * sign(dy)
        
        var _moved = true
    
        // direção vertical
        if (dy > 0) sprite.change(spr_mago_mini_frente)
        else        sprite.change(spr_mago_mini_tras)
    }
    
    if(_moved) sprite.animate(4)
    else sprite.image_ind = 0
}