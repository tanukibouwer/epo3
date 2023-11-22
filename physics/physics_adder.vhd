library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity physics_adder is
   generic(width : INTEGER := 10);
   port(a      : in  std_logic_vector(width-1 downto 0);
        b      : in  std_logic_vector(width-1 downto 0);
        result : out std_logic_vector(width-1 downto 0));
end physics_adder;
