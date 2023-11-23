--module: offset_adder
--version: 1.0
--author: Kevin Vermaat & Parama Fawwaz
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
        xpos  : in STD_LOGIC_VECTOR(7 downto 0);
        ypos  : in STD_LOGIC_VECTOR(7 downto 0);
        xpos_scl : out STD_LOGIC_VECTOR(7 downto 0);
        ypos_scl  : out STD_LOGIC_VECTOR(7 downto 0));
end entity offset_adder;

--shouldnt rtl be behaviour?
architecture behaviour of offset_adder is
    signal xpos_int, ypos_int : integer;

begin
    xpos_int <= to_integer(unsigned(xpos));
    ypos_int <= to_integer(unsigned(ypos));


    xpos_scl <= std_logic_vector(to_unsigned(xpos_int*4, xpos_scl'length));
    ypos_scl <= std_logic_vector(to_unsigned(ypos_int*4, ypos_scl'length));
    
    -- scale with 4
    -- add x with 108 and y with 0
    -- scale up the x and y values to the display resolution, see the above
    -- to be done for all the characters, attacks and platform locations
    -- offset the x signals to make sure the zero is at the active screen time

end architecture;