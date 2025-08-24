#macro DT delta_time / 1000000
#macro RELATIVE_DT delta_time / 1000000 * root.GAME_SPEED

window_set_size(1000, 800)
window_center()

audio_master_gain(.5)

enum Direction {
    RIGHT,
    UP,
    LEFT,
    DOWN
}