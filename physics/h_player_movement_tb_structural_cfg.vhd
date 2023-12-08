configuration h_player_movement_tb_structural_cfg of h_player_movement_tb is
   for structural
      for all: h_player_movement use configuration work.h_player_movement_behaviour_cfg;
      end for;
   end for;
end h_player_movement_tb_structural_cfg;
