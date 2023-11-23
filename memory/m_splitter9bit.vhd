library IEEE;
use IEEE.std_logic_1164.ALL;

entity splitter_9b is
   port(in1  : in  std_logic_vector(17 downto 0);
        out1 : out std_logic_vector(8 downto 0);
        out2 : out std_logic_vector(8 downto 0));
end splitter_9b;

architecture structural of splitter_9b is
	
	signal s9_1,s9_2 : std_logic_vector(8 downto 0);
	signal s18: std_logic_vector(17 downto 0);

begin
	s18	<= in1;

	s9_1 	<= s16(8 downto 0);
	s9_2 	<= s18(17 downto 9);

	out1	<= s9_1;
	out2	<= s9_2;

end structural;








