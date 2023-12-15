--module: graphics_card
--version: 1.1.3
--author: Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
--! This module is the RTL description of the full VGA graphics card of the EPO3 chip - Super Smash Bros. 
--! 
--! This component consists of 3 subcomponents, screen_scan, mem_vid and coloring 
--! 
--! screen_scan to scan the screen, mem_vid as a frame buffer, coloring as logic to find the color at a pixel 
--! 
--! offset adder to coordinates from frame buffer to pixel bounds.
--!
--! current version 1.1.3 is ready for the 'moving block' integration
--! 
--! TODO:
--! move char_offset_adder into the coloring module
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
        -- inputs from memory -> relevant data to be displayed on screen
        -- char1_x : in std_logic_vector(7 downto 0); --! character 1 x-location
        -- char1_y : in std_logic_vector(7 downto 0); --! character 1 y-location
        -- char2_x : in std_logic_vector(7 downto 0); --! character 2 x-location
        -- char2_y : in std_logic_vector(7 downto 0); --! character 2 y-location
        -- outputs to screen (and other components)
        -- vcount : out std_logic_vector(9 downto 0);
        Vsync  : out std_logic; --! sync signals -> active low
        Hsync  : out std_logic; --! sync signals -> active low
        R_data : out std_logic_vector(3 downto 0); --! RGB data to screen
        G_data : out std_logic_vector(3 downto 0); --! RGB data to screen
        B_data : out std_logic_vector(3 downto 0) --! RGB data to screen
    );
end entity graphics_card;

architecture structural of graphics_card is

    component screen_scan is
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            Hsync      : out std_logic;
            Vsync      : out std_logic;
            hcount_out : out std_logic_vector(9 downto 0);
            vcount_out : out std_logic_vector(9 downto 0)
        );
    end component;

    component coloring_new is
        port map(
            clk           => clk,
            reset         => reset,
            hcount        => hcount,
            vcount        => vcount,
            char1x        => char1x,
            char1y        => char1y,
            char2x        => char2x,
            char2y        => char2y,
            percentage_p1 => percentage_p1,
            R_data        => R_data,
            G_data        => G_data,
            B_data        => B_data
        );
    end component;

    signal vcount_int, hcount_int             : std_logic_vector (9 downto 0);
    signal char1_x, char1_y, char2_x, char2_y : std_logic_vector(7 downto 0);
    signal percentagep1 : std_logic_vector(9 downto 0);
    

begin

    --keep count of what pixel the screen should be on and send the synchronisation signals
    SCNR1 : screen_scan port map(
        clk => clk, reset => reset, Hsync => Hsync, Vsync => Vsync, vcount_out => vcount_int, hcount_out => hcount_int
    );

    --gib color to pixel
    CLR1 : coloring port map(
        clk => clk, reset => reset,
        hcount => hcount_int, vcount => vcount_int,
        char1x => char1_x, char1y => char1_y, char2x => char2_x, char2y => char2_y,
        percentage_p1 => percentage_p1,
        R_data => R_data, G_data => G_data, B_data => B_data
    );

    char1_x <= std_logic_vector(to_unsigned(50, char1_x'length));
    char1_y <= std_logic_vector(to_unsigned(75, char1_x'length));
    char2_x <= std_logic_vector(to_unsigned(150, char1_x'length));
    char2_y <= std_logic_vector(to_unsigned(75, char1_x'length));
    percentagep1 <= std_logic_vector(to_unsigned(123, percentagep1'length));

end architecture;