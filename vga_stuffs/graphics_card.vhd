library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity graphics_card is
    port (
        clk   : in std_logic;
        reset : in std_logic;

    );
end entity graphics_card;

architecture rtl of graphics_card is

    component scanner is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            Hsync : out std_logic;
            Vsync : out std_logic
        );
    end component;
begin

    

end architecture;