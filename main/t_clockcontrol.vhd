-----------------------------------------------------------------------------
-- clock control, can stop the clock and progress it a single clock cycle when requested, for testing specific states
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity t_clockcontrol is
port (	clk		: in std_logic;
		stop	: in std_logic;
		step	: in std_logic;
		clkint	: out std_logic);
end t_clockcontrol;

architecture behavioral of t_clockcontrol is
begin
	process(clk)
	begin
		if (stop = '0') then
			clkint <= clk;
		else
			clkint <= step;
		end if;
	end process;
end architecture behavioral;









