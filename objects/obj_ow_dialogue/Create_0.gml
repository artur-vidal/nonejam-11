depth = -100

text = ["dialogo padrao"]
cur_page = 0
prev_text = ""

pad = 3

player = instance_find(obj_player, 0)
player.control = false

typist = scribble_typist()
typist.in(0, 0)

sound = snd_text_mid
pitch_min = 1
pitch_max = 1

font = fnt_default

box_width = 144
box_height = 12 * 3

box_x = 0
box_y = 108

appearing = true
root.anim.add(
    new Animation(id, "box_y", box_y, 108 - box_height, 1.5)
        .complete_callback(function(_){_.typist.in(.2, 0); _.appearing = false;})
        .callback_args(id)
)

pass_text = function(){
	if(appearing) {
		return	
	}
	
    cur_page++
    if(cur_page > array_length(text) - 1){
		root.dialogue_create_cooldown = 30
        instance_destroy()
		return
    }
	
    typist.in(.2, 0)  
}