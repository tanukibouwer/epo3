--module: H_pix_cnt
--version: 1.1
--author: Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
--! A 10 bit counter to keep track of which pixel of the lines the display is on
--
--
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity H_pix_cnt is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        count : out std_logic_vector(9 downto 0)
    );
end entity;

architecture behavioural of H_pix_cnt is
    signal cur_count, new_count : unsigned(9 downto 0);
begin

    process (clk) --storage of the count
    begin
        if rising_edge(clk) then
            if reset = '1' then
                cur_count <= (others => '0');
            else
                cur_count <= new_count;
            end if;
        end if;
    end process;

    process (cur_count, clk) --count on clock/input
    begin
        new_count <= cur_count + 1;
    end process;

    count <= std_logic_vector(cur_count);
    
end architecture;