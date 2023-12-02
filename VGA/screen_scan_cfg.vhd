configuration screen_scan_cfg of screen_scan is
    for structural
        for all : vsync_gen
            use configuration work.vsync_gen_rtl_cfg;
        end for;
        for all : hsync_gen
            use configuration work.hsync_gen_rtl_cfg;
        end for;
        for all : v_line_cnt
            use configuration work.v_line_cnt_behavioural_cfg;
        end for;
        for all : h_pix_cnt
            use configuration work.h_pix_cnt_behavioural_cfg;
        end for;
    end for;
end configuration screen_scan_cfg;