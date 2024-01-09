configuration char_animation_fsm_cfg of char_animation_fsm is
    for behaviour
        for all : frame_cnt use configuration work.frame_cnt_cfg; 
        end for;
    end for;
end configuration char_animation_fsm_cfg;