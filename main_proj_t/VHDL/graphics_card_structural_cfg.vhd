configuration graphics_card_structural_cfg of graphics_card is
   for structural
      for all: screen_scan use configuration work.screen_scan_cfg;
      end for;
      for all: coloring use configuration work.coloring_cfg;
      end for;
   end for;
end graphics_card_structural_cfg;