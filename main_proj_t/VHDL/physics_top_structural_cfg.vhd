configuration physics_top_structural_cfg of physics_top is
   for structural
      for all: p_mux use configuration work.p_mux_behavioural_cfg;
      end for;
      for all: physics_system use configuration work.physics_system_behaviour_cfg;
      end for;
   end for;
end physics_top_structural_cfg;
