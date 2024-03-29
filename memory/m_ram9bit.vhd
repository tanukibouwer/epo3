library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_9b is -- 4 of these
port(
	clk			: in std_logic;
	reset		: in std_logic;
	initial		: in std_logic_vector(8 downto 0);
	data_in 	: in std_logic_vector(8 downto 0);
	data_out 	: out std_logic_vector(8 downto 0);
	write 		: in std_logic);
end ram_9b;

architecture behaviour of ram_9b is
	type mem_type is array(0 to 0)
	of std_logic_vector(data_in'range);
	signal mem : mem_type;
begin
	ram_ff: process(clk) is
	begin
		if (rising_edge (clk)) then
			if (reset = '1') then
				mem(0) <= initial;
			else
				if (write = '1') then 
					mem(0) <= data_in;
				end if;
			end if;
		end if;
	end process;
	data_out <= mem(0);
end behaviour;
