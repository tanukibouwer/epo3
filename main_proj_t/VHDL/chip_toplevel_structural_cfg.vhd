configuration chip_toplevel_structural_cfg of chip_toplevel is
   for structural
      for all: memory use configuration work.memory_structural_cfg;
      end for;
      for all: graphics_card use configuration work.graphics_card_structural_cfg;
      end for;
      for all: physics_top use configuration work.physics_top_structural_cfg;
      end for;
      for all: topattack use configuration work.toplevelattack_structural_cfg;
      end for;
      for all: t_8bregs use configuration work.t_8bregs_rtl_cfg;
      end for;
      for all: input_toplevel use configuration work.input_toplevel_structural_cfg;
      end for;
   end for;
end chip_toplevel_structural_cfg;
