-- configuration h_pix_cnt_behavioural_cfg of h_pix_cnt is
--     for behavioural
--     end for;
-- end configuration h_pix_cnt_behavioural_cfg;

-- configuration hsync_gen_rtl_cfg of hsync_gen is
--     for rtl
--     end for;
-- end configuration hsync_gen_rtl_cfg;

-- configuration v_line_cnt_behavioural_cfg of v_line_cnt is
--     for behavioural
--     end for;
-- end configuration v_line_cnt_behavioural_cfg;

-- configuration vsync_gen_rtl_cfg of vsyn_gen is
--     for rtl
--     end for;
-- end configuration vsync_gen_rtl_cfg;

-- configuration screen_scan_rtl_cfg of screen_scan is
--     for rtl
--         for all : vsync_gen
--             use configuration work.vsync_gen_rtl_cfg;
--         end for;
--         for all : hsync_gen
--             use configuration work.hsync_gen_rtl_cfg;
--         end for;
--         for all : v_line_cnt
--             use configuration work.v_line_cnt_behavioural_cfg;
--         end for;
--         for all : h_pix_cnt
--             use configuration work.h_pix_cnt_behavioural_cfg;
--         end for;
--     end for;
-- end configuration screen_scan_rtl_cfg;

-- configuration coloring_behavioural_cfg of coloring is
--     for behavioural
--     end for;
-- end configuration coloring_behavioural_cfg;

-- configuration char_offset_adder_behaviour_cfg of char_offset_adder is
--     for behavioural
--     end for;
-- end configuration char_offset_adder_behaviour_cfg;