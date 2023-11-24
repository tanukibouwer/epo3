library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity physics_9bit_adder is
   port(a      : in  std_logic_vector(8 downto 0);
        b      : in  std_logic_vector(8 downto 0);
        result : out std_logic_vector(8 downto 0));
end physics_9bit_adder;

architecture behaviour of physics_9bit_adder is
   signal intermediate : std_logic_vector(9 downto 0);
begin
   intermediate <= ('0' & a) + ('1' & b);
   result <= intermediate(8 downto 0);
end behaviour;

configuration physics_9bit_adder_behaviour_cfg of physics_9bit_adder is
   for behaviour
   end for;
end physics_9bit_adder_behaviour_cfg;
