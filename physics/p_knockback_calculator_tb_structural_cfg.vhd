configuration p_knockback_calculator_tb_structural_cfg of p_knockback_calculator_tb is
   for structural
      for all: p_knockback_calculator use configuration work.p_knockback_calculator_behaviour_cfg;
      end for;
   end for;
end p_knockback_calculator_tb_structural_cfg;
