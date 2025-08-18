create_menu(new MenuGroup([
    new MenuOption("Batalha", room_goto, rm_battle),
    
    new MenuOption("Volume", "chmenu", 1),

    new MenuGroup([
        new MenuSelection("Volume", ["oi"]),
        new MenuOption("Voltar", "bkmenu")
    ], "Opções de Volume")

], "Menu Principal"))