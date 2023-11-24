library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity merger_9b is
   port(in1  : in  std_logic_vector(8 downto 0);
        in2  : in  std_logic_vector(8 downto 0);
        out1 : out std_logic_vector(17 downto 0));
end merger_9b;

architecture structural of merger_9b is
	
	signal s9_1,s9_2 : std_logic_vector(8 downto 0);
	signal s18: std_logic_vector(17 downto 0);

begin
	s9_1	<= in1;
	s9_2	<= in2;

	s18(8 downto 0) <= s9_1;
	s18(17 downto 9) <= s9_2;

	out1	<= s18;

end structural;

configuration merger_9b_structural_cfg of merger_9b is
   for structural
   end for;
end merger_9b_structural_cfg;