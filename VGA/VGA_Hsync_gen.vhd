--module: Hsync_gen
--version: 1.0.1
--author: Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
-- This module is the control module for the horizontal sync signal and horizontal pixel counter
--
-- the inputs:
-- The device is clocked, so has clk and reset
-- count is the count out from H_pix_cnt
--
-- the outputs:
-- The sync signal (hsync this case) is active low
-- The counter reset is active high
--
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity Hsync_gen is
    port (
        clk       : in std_logic;
        reset     : in std_logic;
        count     : in std_logic_vector (9 downto 0);
        sync      : out std_logic;
        cnt_reset : out std_logic
    );
end entity Hsync_gen;

architecture rtl of Hsync_gen is
    signal uns_count : unsigned(9 downto 0);
begin

    process (clk, uns_count)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                sync      <= '1';
                cnt_reset <= '1';
            elsif reset = '0' then
                if uns_count    <= 95 then --sync pulse
                    sync            <= '0';
                    cnt_reset       <= '0';
                elsif uns_count <= 143 and uns_count > 95 then --back porch
                    sync            <= '1';
                    cnt_reset       <= '0';
                elsif uns_count <= 783 and uns_count > 143 then --screen
                    sync            <= '1';
                    cnt_reset       <= '0';
                elsif uns_count <= 796 and uns_count > 783 then --front porch
                    sync            <= '1';
                    cnt_reset       <= '0';
                else --reset counter
                    sync      <= '1';
                    cnt_reset <= '1';
                end if;
            end if;
        end if;
    end process;

    uns_count <= unsigned(count);

end architecture;
