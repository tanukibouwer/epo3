-----------------------------------------------------------------------------
-- module isolator, prevents modules from communicating during testing
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity t_isolator is
port (	normal	: in std_logic;
		testing	: in std_logic;
		status	: in std_logic_vector(2 downto 0);
		output	: out std_logic);
end t_isolator;

architecture behavioral of t_isolator is
begin
	process(clk)
	begin
		if (status = "0") then
			output <= normal;
		else
			output <= testing;
		end if;
	end process;
end architecture behavioral;









