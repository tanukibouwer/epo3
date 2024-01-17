configuration graphics_card_cfg of VDC is
    for structural
        for all : screen_scan
            use configuration work.screen_scan_cfg;
        end for;
        for all : coloring
            use configuration work.coloring_cfg;
        end for;
    end for;
end configuration graphics_card_cfg;
