player = noone

cx = camera_get_view_x(view_camera[0])
cy = camera_get_view_y(view_camera[0])
move_speed = 2

width = 144
height = 108

target_x = 0
target_y = 0

move = function(){
	var _dir = point_direction(cx, cy, target_x, target_y)
	
	cx += lengthdir_x(move_speed, _dir)
	cy += lengthdir_y(move_speed, _dir)
	
	var _dist = point_distance(cx, cy, target_x, target_y)
	if(_dist <= move_speed){
		cx = target_x
		cy = target_y
	}
	
	camera_set_view_pos(view_camera[0], cx, cy)
}