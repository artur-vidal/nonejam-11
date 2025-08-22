vol_option = new MenuSelection("Volume", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
vol_option.set_index(5)

vol_option.on_change = function(){
    audio_master_gain(vol_option.options[vol_option.index] / 10)
}
audio_master_gain(.5)

create_menu(new MenuGroup([
    new MenuOption("Continuar", game_start),
    new MenuOption("Batalha", room_goto, rm_battle),
    vol_option
]))