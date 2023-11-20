--module: graphics_card
--version: 1.0
--author: Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
-- This module is the RTL description of the full VGA graphics card of the EPO3 chip - Super Smash Bros
-- This component consists of 3 subcomponents, screen_scan, mem_vid and coloring
-- screen_scan to scan the screen, mem_vid as a frame buffer, coloring as logic to find the color at a pixel
--
--
--
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity graphics_card is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        Hsync : out std_logic;
        Vsync : out std_logic;
        R_data : out std_logic;
        G_data : out std_logic;
        B_data : out std_logic
    );
end entity graphics_card;

architecture rtl of graphics_card is

    component screen_scan is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            Hsync : out std_logic;
            Vsync : out std_logic
        );
    end component;

    -- component mem_vid is
    --     port (
    --         clk   : in std_logic;
    --         reset : in std_logic;
            
    --     );
    -- end component;
    -- component coloring is
    --     port (
    --         clk   : in std_logic;
    --         reset : in std_logic;
            
    --     );
    -- end component;
begin

    R_data <= '1';
    G_data <= '1';
    B_data <= '1';
    
    SCNR1: screen_scan port map (
        clk => clk, reset => reset, Hsync => Hsync, Vsync => Vsync
    );

end architecture;