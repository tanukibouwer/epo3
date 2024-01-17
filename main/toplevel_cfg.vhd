configuration toplevel_cfg of chip_toplevel is
    for structural
        for all : input_toplevel use configuration work.input_toplevel_structural_cfg;
        end for;
        for all : topattack use configuration work.toplevelattack_structural_cfg;
        end for;
        for all : physics_top use configuration work.physics_top_cfg;
        end for;
        for all : VDC use configuration work.graphics_card_cfg;
        end for;
        for all : memory use configuration work.memory_structural_cfg;
        end for;
        for all : t_8bregs use configuration work.t_8bregs_cfg;
        end for;
        for all : game_state_fsm use configuration work.game_state_fsm_cfg;
        end for;
    end for;
end configuration toplevel_cfg;