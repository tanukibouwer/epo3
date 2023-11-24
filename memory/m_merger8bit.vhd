library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity merger_8b is
   port(in1  : in  std_logic_vector(7 downto 0);
        in2  : in  std_logic_vector(7 downto 0);
        out1 : out std_logic_vector(15 downto 0));
end merger_8b;

architecture structural of merger_8b is
	
	signal s8_1,s8_2 : std_logic_vector(7 downto 0);
	signal s16: std_logic_vector(15 downto 0);

begin
	s8_1	<= in1;
	s8_2	<= in2;

	s16(7 downto 0) <= s8_1;
	s16(15 downto 8) <= s8_2;

	out1	<= s16;

end structural;

configuration merger_8b_structural_cfg of merger_8b is
   for structural
   end for;
end merger_8b_structural_cfg;





