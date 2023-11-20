--module: coloring
--version: 1.0
--author: Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
--
--
--
--
--
--
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity coloring is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        
    );
end entity coloring;

architecture behavioural of coloring is

begin

    --bunch of logic to decide what color to draw on what space

end architecture;