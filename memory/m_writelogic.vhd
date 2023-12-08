library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity writelogic is 
port(
	clk		: in std_logic;
	reset		: in std_logic;
	vsync		: in std_logic;
	write 		: out std_logic);
end writelogic;

architecture behaviour of writelogic is
	type	writestate is	(	off,
				on1,
				on2,
				on3);
	signal state, new_state :	writestate;
begin
	process(clk) is
	begin
		if (rising_edge (clk)) then
		if (reset = '1') then
			state <= off;
		else
			state <= new_state;
		end if;
		end if;
	end process;
	process(vsync, state) is
	begin
		case state is
			when off =>
				write <= '0';
				if (vsync = '0') then	
					new_state <= on1;
				else
					new_state <= off;
				end if;
			when on1 =>
				write <= '1';
					new_state <= on2;
			when on2 =>
				write <= '1';
					new_state <= on3;	
			when on3 =>
				write <= '0';
				if (vsync = '0') then
					new_state <= on3;	
				else
					new_state <= off;
				end if;
		end case;
	end process;
end behaviour;
