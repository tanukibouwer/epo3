configuration p_dampener_behaviour_cfg of p_dampener is
   for behaviour
      for all: physics_adder use configuration work.physics_adder_behaviour_cfg;
      end for;
   end for;
end p_dampener_behaviour_cfg;
