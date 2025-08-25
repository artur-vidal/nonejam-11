text = [
    "Gui: Senhor cavaleiro!",
    "O Cavaleiro: [fnt_cavaleiro][speed, .75]Então... vocês realmente acham que podem me vencer.",
    "Meg: Somos muito mais do que capazes! Seu tamanho nao significa nada!",
    "O Cavaleiro: [fnt_cavaleiro][speed, .75]Vocês não entendem. Esse mundo se tornou seu lar. [delay, 500]Vocês nunca sairão daqui.",
    "O Cavaleiro: [fnt_cavaleiro][speed, .75]E, ainda assim, querem lutar? Se preferem assim, nao tenho objeções.",
    "Gui: Nos vamos sair desse pequeno mundinho verde e limitado, e voltar para casa!",
    "Meg: Seu plano nao vai funcionar, cavaleiro. Vamos te manter preso aqui para sempre!",
    "O Cavaleiro: [fnt_cavaleiro][speed, .75]Entendo... Se é assim que querem morrer, garantirei seus desejos.",
    "O Cavaleiro: [fnt_cavaleiro][speed, .5][shake]Engarde!"
]

on_start = function(){
    audio_stop_all()
    audio_play_sound(msc_tension_max, 1, 1)
    
    obj_follow.x = (obj_player.x > 560) ? obj_player.x - 16 : obj_player.x + 16
    
    obj_follow.y = obj_player.y
    obj_follow.sprite.change(spr_mago_mini_tras)
    obj_follow.sprite.image_ind = 0
}

on_dialogue_end = function() {
    obj_follow.following = false
    create_transition(120, function(){
        root.guerreiro.hp = root.guerreiro.max_hp
        root.guerreiro.mana = root.guerreiro.max_mana
        
        root.mago.hp = root.mago.max_hp
        root.mago.mana = root.mago.max_mana
        
        start_battle([root.guerreiro, root.mago], [new CavaleiroCabeca(), new Cavaleiro(), new CavaleiroPernas()], 370, msc_final_boss_loop)
    })
}