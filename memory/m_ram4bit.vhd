library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_4b is -- 2 of these
port(
	clk		: in std_logic;
	data_in 	: in std_logic_vector(3 downto 0);
	data_out 	: out std_logic_vector(3 downto 0);
	write 		: in std_logic);
end ram_4b;

architecture behaviour of ram_4b is
	type mem_type is array(0 to (2**1)-1)
	of std_logic_vector(data_in'range);
	signal mem : mem_type;
begin
	ram_ff: process(clk) is
	begin
		if (rising_edge (clk)) and write = '1' then
			mem(1) <= data_in;
		end if;
	end process;
	data_out <= mem(1);
end behaviour;


configuration ram_4b_behaviour_cfg of ram_4b is
   for behaviour
   end for;
end ram_4b_behaviour_cfg;



