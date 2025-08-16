#macro DT delta_time / 1000000
#macro RELATIVE_DT delta_time / 1000000 * root.GAME_SPEED

enum Direction {
    RIGHT,
    UP,
    LEFT,
    DOWN
}