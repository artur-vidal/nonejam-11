// valeu chat GPT salvou

tile_size = 16
max_vel   = 1

// direção/sprites (troque pelos seus recursos)
sprite = new Sprite(spr_mago_mini_frente)
following = false

// estado de tiles do player (em coordenada "left" no X)
var _pleft = obj_player.x - tile_size/2
curr_left = _pleft
curr_y    = obj_player.y
prev_left = _pleft
prev_y    = obj_player.y

// destino do aliado SEMPRE é o tile anterior do player (convertendo pra centro: + tile/2)
target_x = prev_left + tile_size/2
target_y = prev_y
