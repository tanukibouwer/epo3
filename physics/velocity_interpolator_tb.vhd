library IEEE;
use IEEE.std_logic_1164.ALL;

entity velocity_interpolator_tb is
end velocity_interpolator_tb;

architecture structural of velocity_interpolator_tb is
   component velocity_interpolator is
      port(vin_x : in std_logic_vector(8 downto 0);
        vout_x : out std_logic_vector(8 downto 0);
        movement_target : in std_logic_vector(5 downto 0));
   end component;

   signal vin_x : std_logic_vector(8 downto 0);
   signal vout_x : std_logic_vector(8 downto 0);
   signal movement_target : std_logic_vector(5 downto 0);
begin
   interpolator : velocity_interpolator port map (vin_x, vout_x, movement_target);
   vin_x <= (others => '0') after 0 ns,
            "000000001" after 10 ns,
            "000010101" after 20 ns,            
            "000101111" after 30 ns,
            "101011101" after 40 ns,
            "111111111" after 50 ns,
            (others => '0') after 60 ns,
            "000000001" after 70 ns,
            "000010101" after 80 ns,            
            "000101111" after 90 ns,
            "101011101" after 100 ns,
            "111111111" after 110 ns,
            (others => '0') after 120 ns,
            "000000001" after 130 ns,
            "000010101" after 140 ns,            
            "000101111" after 150 ns,
            "101011101" after 160 ns,
            "111111111" after 170 ns;
   movement_target <= "000000" after 0 ns,
                      "000101" after 60 ns,
                      "111011" after 120 ns;
                                                          
end structural;

configuration velocity_interpolator_tb_cfg of velocity_interpolator_tb is
   for structural
      for all: velocity_interpolator use configuration work.velocity_interpolator_cfg;
      end for;
   end for;
end velocity_interpolator_tb_cfg;
