player = noone

cx = camera_get_view_x(view_camera[0])
cy = camera_get_view_y(view_camera[0])
move_speed = 2

width = 160
height = 120

target_x = 0
target_y = 0

spawning = true

control_mode = "dungeon"

shake_time = 0
shake_intensity = 5

move = function(){
	if(control_mode = "dungeon"){
		var _dir = point_direction(cx, cy, target_x, target_y)
	
		cx += lengthdir_x(move_speed, _dir)
		cy += lengthdir_y(move_speed, _dir)
	
		var _dist = point_distance(cx, cy, target_x, target_y)
		if(_dist <= move_speed){
			cx = target_x
			cy = target_y
		}
	
	} else if(control_mode = "battle") {
		cx = 0
		cy = 0
	}
	
    var _shake = (shake_time > 0) ? irandom_range(-shake_intensity, shake_intensity) : 0
	camera_set_view_pos(view_camera[0], cx + _shake, cy)		
}

turn_shake_on = function(_frame_duration, _intensity = shake_intensity) {
    shake_time = _frame_duration
}