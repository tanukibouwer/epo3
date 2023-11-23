library IEEE;
use IEEE.std_logic_1164.ALL;

entity p_dampener is
   generic(dampening : std_logic_vector(9 downto 0) := "1111111011");
   port(vin_x  : in  std_logic_vector(9 downto 0);
        vin_y  : in  std_logic_vector(9 downto 0);
        vout_x : out std_logic_vector(9 downto 0);
        vout_y : out std_logic_vector(9 downto 0));
end p_dampener;

architecture behaviour of p_dampener is
   component physics_adder
      generic(width : INTEGER := 10);
      port(a      : in  std_logic_vector(width-1 downto 0);
           b      : in  std_logic_vector(width-1 downto 0);
           result : out std_logic_vector(width-1 downto 0));
   end component;
begin
   x_adder : physics_adder port map (vin_x, dampening, vout_x);
   y_adder : physics_adder port map (vin_y, dampening, vout_y);
end behaviour;

configuration p_dampener_behaviour_cfg of p_dampener is
   for behaviour
      for all: physics_adder use configuration work.physics_adder_behaviour_cfg;
      end for;
   end for;
end p_dampener_behaviour_cfg;

