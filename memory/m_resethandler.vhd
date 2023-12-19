-- 2 player version
library IEEE;
use IEEE.std_logic_1164.ALL;

entity m_resethandler is
   port(reset      : in  std_logic;
        resetp1    : in  std_logic;
        resetp2    : in  std_logic;
        resetp1out : out std_logic;
        resetp2out : out std_logic);
end m_resethandler;

architecture structural of m_resethandler is

begin
	process(reset, resetp1, resetp2) is
	begin
	if (reset = '1') then
		resetp1out	<= reset;
		resetp2out	<= reset;
	else
		resetp1out <= resetp1;
		resetp2out <= resetp2;
	end if;
	end process;
end architecture structural;


