--module: VDC
--version: 2.0
--author: Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
-- This module is the RTL description of the full VDC of the EPO3 chip - Super Smash Bros. 
-- 
-- This component consists of 2 subcomponents, screen_scan and coloring 
-- 
-- screen_scan to scan the screen, coloring as logic to find the color at a pixel 
-- 
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity VDC is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        -- inputs from memory -> relevant data to be displayed on screen
        char1_x       : in std_logic_vector(8 downto 0); -- character 1 x-location
        char1_y       : in std_logic_vector(8 downto 0); -- character 1 y-location
        char2_x       : in std_logic_vector(8 downto 0); -- character 2 x-location
        char2_y       : in std_logic_vector(8 downto 0); -- character 2 y-location
        percentage_p1 : in std_logic_vector(7 downto 0);
        percentage_p2 : in std_logic_vector(7 downto 0);
        -- inputs from attack and input
        controllerp1 : in std_logic_vector(7 downto 0);
        controllerp2 : in std_logic_vector(7 downto 0);
        orientationp1 : in std_logic;
        orientationp2 : in std_logic;
        -- outputs to screen (and other components)
        hcount : out std_logic_vector(9 downto 0);
        vcount : out std_logic_vector(9 downto 0);
        Vsync  : out std_logic; -- sync signals -> active low
        Hsync  : out std_logic; -- sync signals -> active low
        R_data : out std_logic_vector(3 downto 0); -- RGB data to screen
        G_data : out std_logic_vector(3 downto 0); -- RGB data to screen
        B_data : out std_logic_vector(3 downto 0); -- RGB data to screen

        -- game states
        game : in std_logic;
        p1_wins : in std_logic;
        p2_wins : in std_logic
    );
end entity VDC;

architecture structural of VDC is

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

    component coloring is
        port (
            -- global inputs
            clk   : in std_logic;
            reset : in std_logic;
            -- counter data
            hcount : in std_logic_vector(9 downto 0);
            vcount : in std_logic_vector(9 downto 0);
            -- relevant data for x-y locations
            char1x : in std_logic_vector(8 downto 0); -- character 1 coordinates
            char1y : in std_logic_vector(8 downto 0); -- character 1 coordinates
            char2x : in std_logic_vector(8 downto 0); -- character 2 coordinates
            char2y : in std_logic_vector(8 downto 0); -- character 2 coordinates
            -- player orientation information
            orientationp1 : in std_logic;
            orientationp2 : in std_logic;
    
            -- percentage from attack module
            percentage_p1 : in std_logic_vector(7 downto 0);
            percentage_p2 : in std_logic_vector(7 downto 0);
    
            -- controller inputs
            controllerp1 : in std_logic_vector(7 downto 0);
            controllerp2 : in std_logic_vector(7 downto 0);
    
            -- RGB data outputs
            R_data : out std_logic_vector(3 downto 0); -- RGB data output
            G_data : out std_logic_vector(3 downto 0); -- RGB data output
            B_data : out std_logic_vector(3 downto 0);  -- RGB data output

             -- game states
            game : in std_logic;
            p1_wins : in std_logic;
            p2_wins : in std_logic
    
        );
    end component;

    signal vcount_int, hcount_int : std_logic_vector (9 downto 0);

begin

    --keep count of what pixel the screen should be on and send the synchronisation signals
    SCNR1 : screen_scan port map(
        clk => clk, reset => reset, Hsync => Hsync, Vsync => Vsync, vcount_out => vcount_int, hcount_out => hcount_int
    );

    --give color to pixel
    CLR1 : coloring port map(
        clk => clk, reset => reset,
        hcount => hcount_int, vcount => vcount_int,
        char1x => char1_x, char1y => char1_y, char2x => char2_x, char2y => char2_y,
        percentage_p1 => percentage_p1, percentage_p2 => percentage_p2,
        orientationp1 => orientationp1, orientationp2 => orientationp2, controllerp1 => controllerp1, controllerp2 => controllerp2,
        R_data => R_data, G_data => G_data, B_data => B_data, game => game, p1_wins => p1_wins, p2_wins => p2_wins
    );
    
    vcount <= vcount_int;
    hcount <= hcount_int;
end architecture;
