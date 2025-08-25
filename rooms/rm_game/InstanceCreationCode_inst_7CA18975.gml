text = [
    "Gui: Senhor dinossauro, voce pode nos dar um espacinho? Acho que tem um botao ai.",
    "Dino: AARJRASJHGFGRFAGRARHGRAHGRJHAGSJHAASDGHAJHGAFAJHGSDASFGAJSDHFGSDJGFGAH",
    "Meg: Dinossauro, estamos tentando sair daqui. Pode sair do personagem um po-",
    "Dino: GRAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH!!!!!!",
    "Gui: ...",
    "Meg: ..."
]

dir = 0


on_dialogue_end = function() {
    obj_follow.following = false
    create_transition(120, function(){
        instance_destroy(inst_5B39B201)
        
        start_battle([root.guerreiro, root.mago], [new Dino(), new Dino()], 30, msc_battle)
    })
}