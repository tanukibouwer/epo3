--module: Vsync counter
--version: 1.0
--author: Parama Fawwaz & Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
--
--
--
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity vsync_cnt is
    port (
        clk : in std_logic;
        reset : in std_logic;
        vcount : in std_logic_vector(9 downto 0);
        count : out std_logic
    );
end entity;

architecture behavioural of vsync_cnt is
    signal cur_count, new_count : unsigned(4 downto 0);
begin

    process (reset, vcount, new_count, cur_count) --storage of the count
    begin
        if (reset = '1' and unsigned(vcount) /= 500) then
            cur_count <= (others => '0');
        elsif (unsigned(vcount) = 500 and reset = '0') then -- add a count before the vertical frame has ran out (at 796)
            cur_count <= new_count;
        else
            cur_count <= cur_count;
        end if;
    end process;

    process (cur_count) 
    begin
        new_count <= cur_count + 1;
    end process;

    count <= std_logic_vector(cur_count)(4);
    
end architecture;

