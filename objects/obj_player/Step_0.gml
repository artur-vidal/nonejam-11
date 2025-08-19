var _horizontal = keyboard_check(vk_right) - keyboard_check(vk_left)
var _vertical = keyboard_check(vk_down) - keyboard_check(vk_up)


if((x - 6) % tile_size == 0 and y % tile_size == 0){
    if(_horizontal != 0 xor _vertical != 0 and control) {
        velh = _horizontal * max_vel
        velv = _vertical * max_vel
    } else {
        velh = 0
        velv = 0
    }
}

x += velh
y += velv