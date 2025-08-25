anim = new AnimationRunner()

GAME_PAUSED = false
GAME_SPEED = 1

relative_current_time = 0

first_battle = true

dialogue_create_cooldown = 0

ow_cam_width = 120
ow_cam_height = 90

guerreiro = new Guerreiro(130, 10, 0)
mago = new Mago(80, 0, 10)

prev_guerreiro_hp = guerreiro.hp
prev_guerreiro_mana = guerreiro.mana

prev_mago_hp = mago.hp
prev_mano_mana = mago.mana

// particulas
part_sys = part_system_create()
part_system_depth(part_sys, -2000)

beat_game = false