library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity mem_vid is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        ld : in std_logic;
        --inputs of all data
    );
end entity mem_vid;

architecture rtl of mem_vid is

begin

    --when ld is low then copy all the values that are available at the inputs

end architecture;