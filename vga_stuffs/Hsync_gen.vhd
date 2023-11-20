--module: Hsync_gen
--version: 1.0
--author: Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
-- This module is the control module for the horizontal sync signal and horizontal pixel counter
-- The full horizontal vga line is described in pixels
-- screen = 0 to 639
-- front porch = 640 to 655
-- sync pulse = 656 to 751
-- back porch = 752 to 799
--
-- the inputs:
-- The device is clocked, so has clk and reset
-- count is the count out from H_pix_cnt
--
-- the outputs:
-- The sync signal (hsync this case) is active low
-- The counter reset is active high
--
-- TODO:
-- Fix the line subdivisions
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
        count     : in std_logic_vector (10 downto 0);
        sync      : out std_logic;
        cnt_reset : out std_logic
    );
end entity Hsync_gen;

architecture rtl of Hsync_gen is

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                sync      <= '0';
                cnt_reset <= '1';
            elsif reset = '0' then
                if count    <= 639 then --screen
                    sync        <= '1';
                    cnt_reset   <= '0';
                elsif count <= 655 and count > 639 then --front porch
                    sync        <= '1';
                    cnt_reset   <= '0';
                elsif count <= 751 and count > 655 then --sync pulse
                    sync        <= '0';
                    cnt_reset   <= '0';
                elsif count <= 799 and count > 751 then --back porch
                    sync        <= '1';
                    cnt_reset   <= '0';
                else
                    sync      <= '1';
                    cnt_reset <= '1';
                end if;
            end if;
        end if;
    end process;

end architecture;