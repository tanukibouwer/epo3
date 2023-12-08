configuration physics_system_behaviour_cfg of physics_system is
   for behaviour
      for all: p_knockback_calculator use configuration work.p_knockback_calculator_behaviour_cfg;
      end for;
      for all: h_player_movement use configuration work.h_player_movement_behaviour_cfg;
      end for;
      for all: velocity_interpolator use configuration work.velocity_interpolator_behaviour_cfg;
      end for;
      for all: gravity use configuration work.gravity_behaviour_cfg;
      end for;
      for all: position_adder use configuration work.position_adder_behaviour_cfg;
      end for;
      for all: collision_resolver use configuration work.collision_resolver_behaviour_cfg;
      end for;
      for all: jump_calculator use configuration work.jump_calculator_behaviour_cfg;
      end for;
   end for;
end physics_system_behaviour_cfg;
