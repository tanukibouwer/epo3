--module: timer_cnt
--version: 1.0
--author: Parama Fawwaz & Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
-- this module counts how many frames have passed to keep track of time
--
--
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity timer_cnt is
    port (
        clk : in std_logic;
        reset : in std_logic;
        vcount : in std_logic_vector(9 downto 0);
        hcount : in std_logic_vector(9 downto 0);
        count : out std_logic_vector(13 downto 0)
    );
end entity;

architecture behavioural of timer_cnt is
    signal cur_count, new_count : unsigned(13 downto 0);
begin

    process (clk) --storage of the count --> MAKE SURE THIS IS A REGISTER!
    begin
        if rising_edge(clk) then
            if reset = '1' then
                cur_count <= "10101111110010";
            elsif (unsigned(hcount) = 790 and unsigned(vcount) = 500) then -- add a count whenever the vertical frame is close to finishing, only once per frame
                cur_count <= new_count;
            end if;
        end if;
    end process;

    process (cur_count) --count on clock/input
    begin
        new_count <= cur_count - 1;
    end process;

    count <= std_logic_vector(cur_count);
    
end architecture;

