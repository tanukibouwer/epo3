configuration screen_scan_cfg of screen_scan is
    for structural
        for all : Vsync_gen
            use configuration work.Vsync_gen_cfg;
        end for;
        for all : Hsync_gen
            use configuration work.Hsync_gen_cfg;
        end for;
        for all : V_line_cnt
            use configuration work.V_line_cnt_cfg;
        end for;
        for all : H_pix_cnt
            use configuration work.H_pix_cnt_cfg;
        end for;
    end for;
end configuration screen_scan_cfg;