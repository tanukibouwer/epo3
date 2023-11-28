--module: char_offset_adder
--version: 1.1.1
--author: Kevin Vermaat & Parama Fawwaz
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--! this module takes the player centerpoint data from the game loop and the memory and scales it to the right size to make sure  
--! the resolution scaling is done correctly and then shifts the locations so the characters appear on the active screen time
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

entity char_offset_adder is
    port (
        xpos : in std_logic_vector(7 downto 0); --! character center coordinate
        ypos : in std_logic_vector(7 downto 0); --! character center coordinate
        -- xsize     : in std_logic_vector(3 downto 0);
        -- ysize     : in std_logic_vector(3 downto 0);
        xpos_scl1 : out std_logic_vector(9 downto 0); --! scaled and moved character box bounds
        xpos_scl2 : out std_logic_vector(9 downto 0); --! scaled and moved character box bounds
        ypos_scl1 : out std_logic_vector(9 downto 0); --! scaled and moved character box bounds
        ypos_scl2 : out std_logic_vector(9 downto 0)  --! scaled and moved character box bounds
    );
end entity char_offset_adder;

architecture behavioural of char_offset_adder is
    -- signal xpos_int, ypos_int : unsigned(7 downto 0);
    signal xpos_int                                   : integer; 
    signal ypos_int                                   : integer; 
    signal xpos_int1, xpos_int2, ypos_int1, ypos_int2 : integer; 

begin
    -- first make integers for easy calculations
    xpos_int <= to_integer(unsigned(xpos));
    ypos_int <= to_integer(unsigned(ypos));
    -- then do the transformation
    xpos_int1 <= ((xpos_int * 4) - (4 * 4) + 108);
    xpos_int2 <= ((xpos_int * 4) + (4 * 4) + 108);
    ypos_int1 <= ((ypos_int * 4) - (4 * 4));
    ypos_int2 <= ((ypos_int * 4) + (4 * 4));
    -- then return to a vector output
    xpos_scl1 <= std_logic_vector(to_unsigned(xpos_int1, xpos_scl1'length));
    xpos_scl2 <= std_logic_vector(to_unsigned(xpos_int2, xpos_scl1'length));
    ypos_scl1 <= std_logic_vector(to_unsigned(ypos_int1, xpos_scl1'length));
    ypos_scl2 <= std_logic_vector(to_unsigned(ypos_int2, xpos_scl1'length));
    

end architecture;