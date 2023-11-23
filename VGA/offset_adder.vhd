--module: offset_adder
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

entity offset_adder is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        -- inputs from memory
        -- outputs to coloring module
    );
end entity offset_adder;

architecture rtl of offset_adder is

begin


    -- scale with 4
    -- add x with 108 and y with 0
    -- scale up the x and y values to the display resolution, see the above
    -- to be done for all the characters, attacks and platform locations

    -- offset the x signals to make sure the zero is at the active screen time

end architecture;