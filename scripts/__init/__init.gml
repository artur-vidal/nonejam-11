#macro DT delta_time / 1000000
#macro RELATIVE_DT delta_time / 1000000 * root.GAME_SPEED

window_set_size(800, 640)
window_center()

enum Direction {
    RIGHT,
    UP,
    LEFT,
    DOWN
}