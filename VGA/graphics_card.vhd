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
        char1_x : in std_logic_vector(7 downto 0); --! character 1 x-location
        char1_y : in std_logic_vector(7 downto 0); --! character 1 y-location
        char2_x : in std_logic_vector(7 downto 0); --! character 2 x-location
        char2_y : in std_logic_vector(7 downto 0); --! character 2 y-location
        -- outputs to screen (and other components)
        -- vcount : out std_logic_vector(9 downto 0);
        Vsync  : out std_logic; --! sync signals -> active low
        Hsync  : out std_logic; --! sync signals -> active low
        R_data : out std_logic; --! RGB data to screen
        G_data : out std_logic; --! RGB data to screen
        B_data : out std_logic  --! RGB data to screen
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

    component char_offset_adder is
        port (
            xpos : in std_logic_vector(7 downto 0);
            ypos : in std_logic_vector(7 downto 0);
            -- xsize     : in std_logic_vector(3 downto 0);
            -- ysize     : in std_logic_vector(3 downto 0);
            xpos_scl1 : out std_logic_vector(9 downto 0);
            xpos_scl2 : out std_logic_vector(9 downto 0);
            ypos_scl1 : out std_logic_vector(9 downto 0);
            ypos_scl2 : out std_logic_vector(9 downto 0)
        );
    end component;

    component coloring is
        port (
            clk              : in std_logic;
            reset            : in std_logic;
            hcount           : in std_logic_vector(9 downto 0);
            vcount           : in std_logic_vector(9 downto 0);

            x_lowerbound_ch1 : in std_logic_vector(9 downto 0);
            x_upperbound_ch1 : in std_logic_vector(9 downto 0);
            y_lowerbound_ch1 : in std_logic_vector(9 downto 0);
            y_upperbound_ch1 : in std_logic_vector(9 downto 0);

            x_lowerbound_ch2 : in std_logic_vector(9 downto 0);
            x_upperbound_ch2 : in std_logic_vector(9 downto 0);
            y_lowerbound_ch2 : in std_logic_vector(9 downto 0);
            y_upperbound_ch2 : in std_logic_vector(9 downto 0);

            R_data           : out std_logic;
            G_data           : out std_logic;
            B_data           : out std_logic
        );
    end component;

    signal vcount_int, hcount_int : std_logic_vector (9 downto 0);
    signal c1x1, c1x2, c1y1, c1y2 : std_logic_vector(9 downto 0); --! char1 bounds
    signal c2x1, c2x2, c2y1, c2y2 : std_logic_vector(9 downto 0); --! char2 bounds

begin

    --keep count of what pixel the screen should be on and send the synchronisation signals
    SCNR1 : screen_scan port map(
        clk => clk, reset => reset, Hsync => Hsync, Vsync => Vsync, vcount_out => vcount_int, hcount_out => hcount_int
    );

    --gib color to pixel
    CLR1 : coloring port map(
        clk => clk, reset => reset, vcount => vcount_int, hcount => hcount_int,
        x_lowerbound_ch1 => c1x1, x_upperbound_ch1 => c1x2, y_lowerbound_ch1 => c1y1, y_upperbound_ch1 => c1y2,
        x_lowerbound_ch2 => c2x1, x_upperbound_ch2 => c2x2, y_lowerbound_ch2 => c2y1, y_upperbound_ch2 => c2y2,
        R_data => R_data, G_data => G_data, B_data => B_data
    );

    --scale and place char1 on active screen
    O_P1 : char_offset_adder port map(
        xpos => char1_x, ypos => char1_y, 
        xpos_scl1 => c1x1, xpos_scl2 => c1x2, ypos_scl1 => c1y1, ypos_scl2 => c1y2
    );

    --scale and place char1 on active screen
    O_P2 : char_offset_adder port map(
        xpos => char2_x, ypos => char2_y,
        xpos_scl1 => c2x1, xpos_scl2 => c2x2, ypos_scl1 => c2y1, ypos_scl2 => c2y2
    );

    -- vcount <= vcount_int;

end architecture;

