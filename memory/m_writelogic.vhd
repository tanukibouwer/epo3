library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity writelogic is 
port(
	clk			: in std_logic;
	vsync		: in std_logic;
	write 		: out std_logic);
end writelogic;

architecture behaviour of writelogic is
	signal writeint : std_logic;
begin
	process(clk) is
	begin
		if (rising_edge (clk)) and vsync = '0' then
			writeint <= '1';
		else
			writeint <= '0';
		end if;
	end process;
	write <= writeint;
end behaviour;

configuration writelogic_behaviour_cfg of writelogic is
   for behaviour
   end for;
end writelogic_behaviour_cfg;
