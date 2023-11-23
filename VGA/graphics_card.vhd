--module: graphics_card
--version: 1.1.1
--author: Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
-- This module is the RTL description of the full VGA graphics card of the EPO3 chip - Super Smash Bros
-- This component consists of 3 subcomponents, screen_scan, mem_vid and coloring
-- screen_scan to scan the screen, mem_vid as a frame buffer, coloring as logic to find the color at a pixel
-- offset adder to coordinates from frame buffer to pixel bounds
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
        clk    : in std_logic;
        reset  : in std_logic;
        -- inputs from memory -> relevant data to be displayed on screen

        -- outputs to screen (and other components)
        vcount : out std_logic_vector(9 downto 0);
        Hsync  : out std_logic;
        Vsync  : out std_logic;
        R_data : out std_logic;
        G_data : out std_logic;
        B_data : out std_logic
    );
end entity graphics_card;

architecture rtl of graphics_card is

    component screen_scan is
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            Hsync      : out std_logic;
            Vsync      : out std_logic;
            hcount_out : out std_logic;
            vcount_out : out std_logic
        );
    end component;

    -- component mem_vid is
    --     port (
    --         clk   : in std_logic;
    --         reset : in std_logic;

    --     );
    -- end component;

    -- component offset_adder is
    --     port (
    --         clk   : in std_logic;
    --         reset : in std_logic;
            
    --     );
    -- end component;

    component coloring is
        port (
            clk    : in std_logic;
            reset  : in std_logic;
            hcount : in std_logic_vector(9 downto 0);
            vcount : in std_logic_vector(9 downto 0);
            R_data : out std_logic;
            G_data : out std_logic;
            B_data : out std_logic
        );
    end component;
    signal vcount_int, hcount_int : std_logic_vector (9 downto 0);
    
begin

    SCNR1 : screen_scan port map(
        clk => clk, reset => reset, Hsync => Hsync, Vsync => Vsync, vcount_out => vcount_int, hcount_out => hcount_int
    );

    CLR1 : coloring port map(
        clk => clk, reset => reset, vcount => vcount_int, hcount => hcount_int,
        R_data => R_data, G_data => G_data, B_data => B_data
    );

    vcount <= vcount_int;

end architecture;