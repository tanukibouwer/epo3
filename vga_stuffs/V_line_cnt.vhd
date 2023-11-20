--module: V_line_cnt
--version: 1.0
--author: Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
-- A 10 bit counter to keep track of the lines of the VGA screen. 
--
--
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity V_line_cnt is
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        cnt_clk : in std_logic;
        count   : out std_logic_vector(9 downto 0)
    );
end entity;

architecture behavioural of V_line_cnt is
    signal cur_count, new_count : unsigned(9 downto 0);
begin

    process (clk, cnt_clk) --storage of the count
    begin
        if rising_edge(cnt_clk) then
            cur_count <= new_count;
        elsif rising_edge(clk) then
            if reset = '1' then
                cur_count <= (others => '0');
            end if;
        end if;
    end process;

    process (cur_count, cnt_clk) --count on clock/input
    begin
        new_count <= cur_count + 1;
    end process;

    count <= std_logic_vector(cur_count);

end architecture;