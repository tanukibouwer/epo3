configuration chip_toplevel_tb_behaviour_cfg of chip_toplevel_tb is
   for behaviour
      for all: chip_toplevel use configuration work.toplevel_cfg;
      end for;
   end for;
end chip_toplevel_tb_behaviour_cfg;
