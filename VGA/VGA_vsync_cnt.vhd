--module: Vsync counter
--version: 1.0
--author: Parama Fawwaz
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
--! 
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
        vcount : in std_logic_vector(9 downto 0);
        reset : in std_logic;
        count : out std_logic_vector(1 downto 0)
    );
end entity;

architecture behavioural of vsync_cnt is
    signal cur_count, new_count : unsigned(1 downto 0);
begin

    process (vcount, reset, new_count) --storage of the count
    begin
        if reset = '1' then
            cur_count <= (others => '0');
        else
            cur_count <= new_count;
        end if;
    end process;

    process (cur_count, vcount, new_count) --count on clock/input
    begin
        if unsigned(vcount) = 780 then
            new_count <= cur_count + 1;
        else 
            new_count <= cur_count;
        end if;

    end process;

    count <= std_logic_vector(cur_count);
    
end architecture;

