text = "Esse e um dialogo teste."

player = instance_find(obj_player, 0)
player.control = false

typist = scribble_typist()
typist.in(.2, 0)