library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

architecture behaviour of physics_adder is
   signal intermediate : std_logic_vector(width downto 0);
begin
   intermediate <= ('0' & a) + ('1' & b);
   result <= intermediate(width-1 downto 0);
end behaviour;

