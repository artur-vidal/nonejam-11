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

box_width = 120
box_height = 12 * 3

box_x = 0
box_y = room_height

root.anim.add(
    new Animation(id, "box_y", box_y, room_height - box_height, 1.5)
        .complete_callback(function(_){_.typist.in(.2, 0)})
        .callback_args(id)
)

pass_text = function(){
    cur_page++
    if(cur_page > array_length(text) - 1){
        instance_destroy()
    }else{
        typist.in(.2, 0)
    }
}