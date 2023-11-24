library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_18b is
port(
	clk			: in std_logic;
	reset		: in std_logic;
	address 	: in std_logic_vector(1 downto 0);
	data_in 	: in std_logic_vector(17 downto 0);
	data_out 	: out std_logic_vector(17 downto 0);
	write 		: in std_logic);
end ram_18b;

architecture behaviour of ram_18b is
	type mem_type is array(0 to (2**address'length)-1)
	of std_logic_vector(data_in'range);
	signal mem : mem_type;
begin
	ram_ff: process(clk) is
	begin
		if (rising_edge (clk)) and write = '1' then
			mem(to_integer(unsigned(address))) <= data_in;
		end if;
	end process;
	data_out <= mem(to_integer(unsigned(address)));
end behaviour;

configuration ram_18b_behaviour_cfg of ram_18b is
   for behaviour
   end for;
end ram_18b_behaviour_cfg;