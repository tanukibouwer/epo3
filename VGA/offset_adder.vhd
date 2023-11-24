--module: offset_adder
--version: 1.1
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
        clk       : in std_logic;
        reset     : in std_logic;
        xpos      : in std_logic_vector(7 downto 0);
        ypos      : in std_logic_vector(7 downto 0);
        xpos_scl1 : out std_logic_vector(7 downto 0);
        xpos_scl2 : out std_logic_vector(7 downto 0);
        ypos_scl1 : out std_logic_vector(7 downto 0);
        ypos_scl2 : out std_logic_vector(7 downto 0)
    );
end entity offset_adder;

--shouldnt rtl be behaviour?
architecture behaviour of offset_adder is
    signal xpos_int, ypos_int : integer;

begin
    xpos_int <= to_integer(unsigned(xpos));
    ypos_int <= to_integer(unsigned(ypos));
    xpos_scl1 <= std_logic_vector(to_unsigned((xpos_int * 4) - 6, xpos_scl'length));
    xpos_scl2 <= std_logic_vector(to_unsigned((xpos_int * 4) + 6, xpos_scl'length));
    ypos_scl1 <= std_logic_vector(to_unsigned((ypos_int * 4) - 6, ypos_scl'length));
    ypos_scl2 <= std_logic_vector(to_unsigned((ypos_int * 4) + 6, ypos_scl'length));

end architecture;