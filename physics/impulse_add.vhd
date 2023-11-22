library IEEE;
use IEEE.std_logic_1164.ALL;

entity p_impulse_add is
   port(vin_x     : in  std_logic_vector(9 downto 0);
        vin_y     : in  std_logic_vector(9 downto 0);
        impulse_x : in  std_logic_vector(9 downto 0);
        impulse_y : in  std_logic_vector(9 downto 0);
        vout_x    : out std_logic_vector(9 downto 0);
        vout_y    : out std_logic_vector(9 downto 0));
end p_impulse_add;

