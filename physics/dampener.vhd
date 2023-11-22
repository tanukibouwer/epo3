library IEEE;
use IEEE.std_logic_1164.ALL;

entity p_dampener is
   generic(dampening : std_logic_vector(9 downto 0) := "1111111011");
   port(vin_x  : in  std_logic_vector(9 downto 0);
        vin_y  : in  std_logic_vector(9 downto 0);
        vout_x : out std_logic_vector(9 downto 0);
        vout_y : out std_logic_vector(9 downto 0));
end p_dampener;

