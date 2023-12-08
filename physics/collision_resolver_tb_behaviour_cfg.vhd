configuration collision_resolver_tb_behaviour_cfg of collision_resolver_tb is
   for behaviour
      for all: collision_resolver use configuration work.collision_resolver_behaviour_cfg;
      end for;
   end for;
end collision_resolver_tb_behaviour_cfg;
