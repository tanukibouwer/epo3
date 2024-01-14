configuration game_state_fsm_cfg of game_state_fsm is
    for behaviour
        for all : game_state_fsm use configuration work.game_state_fsm_cfg;
        end for;
    end for;
end configuration game_state_fsm_cfg;