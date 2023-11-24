library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity att_offset_adder is
    port (
        clk   : in std_logic;
        reset : in std_logic;
		data_in8b1 		: in std_logic_vector(7 downto 0);--attack x char1
        
    );
end entity att_offset_adder;

architecture behavioural of att_offset_adder is

begin

    

end architecture;