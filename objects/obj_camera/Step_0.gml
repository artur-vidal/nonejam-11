move()
camera_set_view_size(view_camera[0], width, height)

show_debug_message($"{cx}, {cy}")

player = instance_find(obj_player, 0)
if(!instance_exists(player)){
	exit
}

// var _player_in_camera = point_in_rectangle(player.x, player.y, cx, cy, cx + width, cy + height)

target_x = (player.x div width) * width
target_y = ((player.y - 12) div height) * height