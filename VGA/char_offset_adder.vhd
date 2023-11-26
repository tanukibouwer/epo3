--module: char_offset_adder
--version: 1.1.1
--author: Kevin Vermaat & Parama Fawwaz
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
-- this module takes the player centerpoint data from the game loop and the memory and scales it to the right size to make sure 
-- the resolution scaling is done correctly and then shifts the locations so the characters appear on the active screen time
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
        xpos      : in std_logic_vector(7 downto 0);
        ypos      : in std_logic_vector(7 downto 0);
        xpos_scl1 : out std_logic_vector(7 downto 0);
        xpos_scl2 : out std_logic_vector(7 downto 0);
        ypos_scl1 : out std_logic_vector(7 downto 0);
        ypos_scl2 : out std_logic_vector(7 downto 0)
    );
end entity char_offset_adder;

architecture behaviour of char_offset_adder is
    signal xpos_int, ypos_int : unsigned(7 downto 0);

begin
    process (xpos, ypos)
    begin
        xpos_scl1 <= std_logic_vector((xpos_int * 4) - (4 * 4) + 108);
        xpos_scl2 <= std_logic_vector((xpos_int * 4) + (4 * 4) + 108);
        ypos_scl1 <= std_logic_vector((ypos_int * 4) - (4 * 4));
        ypos_scl2 <= std_logic_vector((ypos_int * 4) + (4 * 4));

    end process;

    xpos_int <= unsigned(xpos);
    ypos_int <= unsigned(ypos);

end architecture;