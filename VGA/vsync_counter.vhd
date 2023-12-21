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
        vsync   : in std_logic;
        reset : in std_logic;
        count : out std_logic_vector(3 downto 0)
    );
end entity;

architecture behavioural of vsync_cnt is
    signal cur_count, new_count : unsigned(3 downto 0);
begin

    process (vsync) --storage of the count
    begin
        if rising_edge(vsync) then
            if reset = '1' then
                cur_count <= (others => '0');
            else
                cur_count <= new_count;
            end if;
        end if;
    end process;

    process (cur_count, vsync) --count on clock/input
    begin
        new_count <= cur_count + 1;
    end process;

    count <= std_logic_vector(cur_count);
    
end architecture;

