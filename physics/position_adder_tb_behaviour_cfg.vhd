configuration position_adder_tb_behaviour_cfg of position_adder_tb is
   for behaviour
      for all: position_adder use configuration work.position_adder_behaviour_cfg;
      end for;
   end for;
end position_adder_tb_behaviour_cfg;
