configuration p_impulse_add_tb_behaviour_cfg of p_impulse_add_tb is
   for behaviour
      for all: p_impulse_add use configuration work.p_impulse_add_behaviour_cfg;
      end for;
   end for;
end p_impulse_add_tb_behaviour_cfg;
