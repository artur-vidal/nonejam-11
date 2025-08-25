text = [
    "Gui: Meg! Tem inimigos aqui!",
    "Meg: [scale, .75]Gui! Para de gritar!",
    "Gui: [scale, .75]Ta bom![delay, 1000][scale, 1] Voce ainda lembra como brigar?",
    "Meg: Claro! E so fazer tipo \"APSIOCJDKBEQW\" e eu solto minha magia! E voce, ainda sabe pular?",
    "Gui: Nunca vou esquecer. Vamo pra cima!"
]

on_start = function(){
    audio_stop_all()
    audio_play_sound(msc_tension_mid, 1, 1)
}

on_dialogue_end = function(){
    create_transition(120, function(){
        start_battle([root.guerreiro, root.mago], [new Dino(), new Dino()], 30, msc_battle, function(){
            create_dialogue([
                "Gui: Ufa, conseguimos.",
                "Meg: Sim... Voce nao se sente meio travado?",
                "Gui: Aham. Pareco enferrujado, to me sentindo um velhinho.",
                "Meg: ...Ei, acho que estou vendo algo ali na frente.",
            ])
            audio_play_sound(msc_dungeon, 1, 1)
        });
        instance_destroy(inst_30781A7C);
        instance_destroy(inst_26B2B936);
    })
}