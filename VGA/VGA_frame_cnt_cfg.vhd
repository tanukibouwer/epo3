configuration frame_cnt_cfg of frame_cnt is
    for behaviour
        for all : frame_c
            use entity work.frame_cnt_cfg;
        end for;
    end for;
end configuration frame_cnt_cfg;