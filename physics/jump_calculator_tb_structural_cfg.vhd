configuration jump_calculator_tb_structural_cfg of jump_calculator_tb is
   for structural
      for all: jump_calculator use configuration work.jump_calculator_behaviour_cfg;
      end for;
   end for;
end jump_calculator_tb_structural_cfg;
