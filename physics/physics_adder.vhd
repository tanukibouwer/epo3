library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity physics_adder is
   generic(width : INTEGER := 10);
   port(a      : in  std_logic_vector(width-1 downto 0);
        b      : in  std_logic_vector(width-1 downto 0);
        result : out std_logic_vector(width-1 downto 0));
end physics_adder;

architecture behaviour of physics_adder is
   signal intermediate : std_logic_vector(width downto 0);
begin
   intermediate <= ('0' & a) + ('1' & b);
   result <= intermediate(width-1 downto 0);
end behaviour;

configuration physics_adder_behaviour_cfg of physics_adder is
   for behaviour
   end for;
end physics_adder_behaviour_cfg;
