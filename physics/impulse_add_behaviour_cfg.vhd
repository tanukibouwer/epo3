configuration p_impulse_add_behaviour_cfg of p_impulse_add is
   for behaviour
      for all: physics_adder use configuration work.physics_adder_behaviour_cfg;
      end for;
   end for;
end p_impulse_add_behaviour_cfg;
