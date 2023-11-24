--module: char_offset_adder
--version: 1.1.1
--author: Kevin Vermaat & Parama Fawwaz
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
-- this module takes the player centerpoint data from the game loop and the memory and scales it to the right size to
-- accomodate the pixelcount and then shifts it so it is on the active screen time
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
        -- clk       : in std_logic;
        -- reset     : in std_logic;
        xpos      : in std_logic_vector(7 downto 0);
        ypos      : in std_logic_vector(7 downto 0);
        xpos_scl1 : out std_logic_vector(7 downto 0);
        xpos_scl2 : out std_logic_vector(7 downto 0);
        ypos_scl1 : out std_logic_vector(7 downto 0);
        ypos_scl2 : out std_logic_vector(7 downto 0)
    );
end entity char_offset_adder;

--shouldnt rtl be behaviour?
architecture behaviour of char_offset_adder is
    signal xpos_int, ypos_int : ;unsigned(7 downto 0);

begin
    process (xpos, ypos)
    begin
        xpos_scl1 <= std_logic_vector((xpos_int * 4) - (6 * 4) + 108);
        xpos_scl2 <= std_logic_vector((xpos_int * 4) + (6 * 4) + 108);
        ypos_scl1 <= std_logic_vector((ypos_int * 4) - (6 * 4));
        ypos_scl2 <= std_logic_vector((ypos_int * 4) + (6 * 4));

    end process;

    xpos_int <= unsigned(xpos);
    ypos_int <= unsigned(ypos);

end architecture;