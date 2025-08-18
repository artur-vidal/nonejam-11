switch(state) {
    case BattleStates.PLAYER_TURN: state_player(); break;
    case BattleStates.PLAYER_ACT: state_player_actions(); break;
    case BattleStates.ENEMY_ATTACKING: state_enemy_attacks(); break;
}