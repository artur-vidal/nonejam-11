depth = -100

text = ["dialogo padrao"]
cur_page = 0
prev_text = ""

pad = 3

player = instance_find(obj_player, 0)
player.control = false
obj_follow.following = false

typist = scribble_typist()
typist.in(0, 0)

sound = snd_text_mid
pitch_min = 1
pitch_max = 1

font = fnt_default

box_width = 160
box_height = 16 * 3

box_x = 0
box_y = 128

appearing = true

start = function(_dir) {
    
    if(_dir == 0){
        root.anim.add(
            new Animation(id, "box_y", 0 - box_height, 0, 1)
                .complete_callback(function(_){_.typist.in(.3, 0); _.appearing = false;})
                .callback_args(id)
        )
    } else {
        root.anim.add(
            new Animation(id, "box_y", box_y, box_y - box_height, 1)
                .complete_callback(function(_){_.typist.in(.3, 0); _.appearing = false;})
                .callback_args(id)
        )
    }
}

on_dialogue_end = function() {}

pass_text = function(){
	if(appearing) {
		return	
	}
	
    cur_page++
    if(cur_page > array_length(text) - 1){
		root.dialogue_create_cooldown = 30
        instance_destroy()
        on_dialogue_end()
		return
    }
	
    typist.in(.3, 0)
}