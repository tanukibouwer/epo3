configuration velocity_interpolator_tb_structural_cfg of velocity_interpolator_tb is
   for structural
      for all: velocity_interpolator use configuration work.velocity_interpolator_behaviour_cfg;
      end for;
   end for;
end velocity_interpolator_tb_structural_cfg;
