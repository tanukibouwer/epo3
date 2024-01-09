configuration char_sprites_cfg of char_sprites is
    for behavioural
        for all : char_animation_fsm
            use configuration work.char_animation_fsm_cfg;
        end for;
    end for;
end configuration char_sprites_cfg;