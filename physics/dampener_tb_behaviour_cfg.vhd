configuration p_dampener_tb_behaviour_cfg of p_dampener_tb is
   for behaviour
      for all: p_dampener use configuration work.p_dampener_behaviour_cfg;
      end for;
   end for;
end p_dampener_tb_behaviour_cfg;
