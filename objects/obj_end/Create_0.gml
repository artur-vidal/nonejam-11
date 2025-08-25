white_alpha = 1
texto_fim = "O Cavaleiro agora está preso dentro do mundo retrô, e você finalmente poderá desfrutar do novo e ilustre [slant]Cosplay Final XV...[/slant]"
texto_agradecimento = "Programação, músicas e efeitos sonoros por: [wave]Tuta[/wave]\nArtes e Concepts por: [wave]azeddo[/wave]\nAssets utilizados estão listados na página do jogo \ne no arquivo 'créditos.txt'\n\nObrigado por jogar!"

gui = {
    x : 0,
    y : 160,
    sprite : new Sprite(spr_guerreiro_move)
}

meg = {
    x : 0,
    y : 160,
    sprite : new Sprite(spr_mago_move)
}

cav = {
    x : 0,
    y : 160,
    sprite : new Sprite(spr_arm_cabe_a_idle)
}

gui.sprite.xscale = 2
gui.sprite.yscale = 2

meg.sprite.xscale = 2
meg.sprite.yscale = 2

cav.sprite.xscale = -1.5
cav.sprite.yscale = 1.5
cav.sprite.offset.y = 10

root.anim.add(
    new Animation(gui, "x", -200, room_width + 200, 6)
        .type(AnimationTypes.LOOP),

    new Animation(meg, "x", -200, room_width + 200, 6)
        .type(AnimationTypes.LOOP),

    new Animation(cav, "x", -200, room_width + 200, 6)
        .type(AnimationTypes.LOOP),
)