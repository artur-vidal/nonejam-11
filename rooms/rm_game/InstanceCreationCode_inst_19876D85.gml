text = [
    "Gui: Mais deles... Peixes? E serio?",
    "Meg: Tem um cara enorme na nossa frente e voce ta olhando pros peixes?!",
    "Gui: ...Ah! [delay, 1000]Quem e voce?",
    "???: [fnt_cavaleiro]Eu sou [shake][delay, 500]O CAVALEIRO.[/shake] Eu sou aquele que trouxe vocês aqui.",
    "Gui: Ah, ta. senhor cavaleiro, porque estamos aqui???",
    "Meg: [scale, 0.75]ele sempre foi lerdo assim?",
    "O Cavaleiro: [fnt_cavaleiro]Eu faço parte desse mundo, um mundo abandonado no passado e na nostalgia.",
    "O Cavaleiro: [fnt_cavaleiro]Depois de tanto tempo preso, eu entendi a verdade. Entendi que, se todos esquecerem, se nao houver mais \"retrô\"...",
    "O Cavaleiro: [fnt_cavaleiro]Esse mundo desapare-",
    "Gui: Voce fala demais! Meg, vamo pra cima!",
    "O Cavaleiro: [fnt_cavaleiro]Não vou perder meu tempo com vocês. Capangas, acabem com eles."
]

on_start = function(){
    audio_stop_all()
    audio_play_sound(msc_tension_mid, 1, 1)
}

on_dialogue_end = function(){
    create_transition(120, function(){
        start_battle([root.guerreiro, root.mago], [new Peixe(), new Peixe(), new Dino()], 30, msc_boss_1, function(){
            create_dialogue([
                "Gui: Vamos, temos que achar esse cavaleiro!",
                "Meg: Sim, precisamos. Ele se acha demais!"
            ])
            audio_play_sound(msc_dungeon, 1, 1)
        });
        instance_destroy(inst_3B8E67A9);
        instance_destroy(inst_3A46FAB3);
        instance_destroy(inst_25B42C45);
    })
}