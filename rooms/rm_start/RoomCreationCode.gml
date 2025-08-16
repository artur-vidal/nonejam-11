create_menu(new MenuGroup([
    new MenuOption("Caralho"),
    new MenuOption("Cacete"),
    new MenuOption("Caramba"),
    
    new MenuOption("Volume", "chmenu", 1),

    new MenuGroup([
        new MenuSelection("Volume", ["oi"]),
        new MenuOption("Voltar", "bkmenu")
    ], "Opções de Volume")

], "Menu Principal"))