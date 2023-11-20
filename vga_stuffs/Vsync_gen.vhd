--module: Hsync_gen
--version: 1.0
--author: Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
-- This module is the control module for the vertical sync signal and vertical line counter
-- The full vertical vga frame is described in pixels
-- screen = 0 to 479
-- front porch = 480 to 489
-- sync pulse = 490 to 491
-- back porch = 492 to 524
--
-- the inputs:
-- The device is clocked, so has clk and reset
-- count is the count out from V_line_cnt
--
-- the outputs:
-- The sync signal (vsync this case) is active low
-- The counter reset is active high
--
-- TODO:
-- Fix the fame subdivisions
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity Vsync_gen is
    port (
        clk       : in std_logic;
        reset     : in std_logic;
        count     : in std_logic_vector (10 downto 0);
        sync      : out std_logic;
        cnt_reset : out std_logic
    );
end entity Vsync_gen;

architecture rtl of Vsync_gen is

begin

    process (clk, count)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                sync      <= '0';
                cnt_reset <= '1';
            elsif reset = '0' then
                if count    <= 479 then --screen
                    sync        <= '1';
                    cnt_reset   <= '0';
                elsif count <= 489 and count > 479 then --front porch
                    sync        <= '1';
                    cnt_reset   <= '0';
                elsif count <= 491 and count > 489 then --sync pulse
                    sync        <= '0';
                    cnt_reset   <= '0';
                elsif count <= 524 and count > 491 then --back porch
                    sync        <= '1';
                    cnt_reset   <= '0';
                else --reset counter
                    sync      <= '1';
                    cnt_reset <= '1';
                end if;
            end if;
        end if;
    end process;

end architecture;