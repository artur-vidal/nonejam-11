text = [
    "Meg: GUI! UM PEIXE VOADOR!",
    "Gui: Ah![delay, 1000] Meg, a gente praticamente acabou de passar por uns 2 desse.",
    "Meg: [scale, 0.75]...[shake]desculpa.",
    "Peixe: blub",
]

dir = 0

on_dialogue_end = function() {
    obj_follow.following = false
    create_transition(120, function(){
        instance_destroy(inst_910FAD8)
        
        start_battle([root.guerreiro, root.mago], [new Peixe(), new Peixe(), new Peixe()], 30, msc_battle)
    })
}