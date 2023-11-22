library IEEE;
use IEEE.std_logic_1164.ALL;

architecture behaviour of p_impulse_add is
   component physics_adder
      generic(width : INTEGER := 10);
      port(a      : in  std_logic_vector(width-1 downto 0);
           b      : in  std_logic_vector(width-1 downto 0);
           result : out std_logic_vector(width-1 downto 0));
   end component;
begin
   x_adder : physics_adder port map (vin_x, impulse_x, vout_x);
   y_adder : physics_adder port map (vin_y, impulse_y, vout_y);
end behaviour;

