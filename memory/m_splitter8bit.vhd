library IEEE;
use IEEE.std_logic_1164.ALL;

entity splitter_8b is
   port(in1  : in  std_logic_vector(15 downto 0);
        out1 : out std_logic_vector(7 downto 0);
        out2 : out std_logic_vector(7 downto 0));
end splitter_8b;

architecture structural of splitter_8b is
	
	signal s8_1,s8_2 : std_logic_vector(7 downto 0);
	signal s16: std_logic_vector(15 downto 0);

begin
	s16	<= in1;

	s8_1 	<= s16(7 downto 0);
	s8_2 	<= s16(15 downto 8);

	out1	<= s8_1;
	out2	<= s8_2;

end structural;








