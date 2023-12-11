--module: coloring
--version: a2.0.5
--author: Kevin Vermaat & Parama Fawwaz
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
--! this module is made to allow the VGA module to actually draw colours to the screen
--! this is done by only allowing the module to write a color whenever the scanning is on active screen time
--! 
--! this module also requires the different x (horizontal) and y (vertical) locations of what needs to be drawn and the colours
--!
--! This module also draw the GUI of the game, including the text
--! 
--! the current version 1.1 is ready for the first integration 'moving block'
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity coloring_new is
    port (
        --! global inputs
        clk   : in std_logic;
        reset : in std_logic;
        --! counter data
        hcount : in std_logic_vector(9 downto 0);
        vcount : in std_logic_vector(9 downto 0);
        -- relevant data for x-y locations
        x_lowerbound_ch1 : in std_logic_vector(9 downto 0); --! character 1 bounds
        x_upperbound_ch1 : in std_logic_vector(9 downto 0); --! character 1 bounds
        y_lowerbound_ch1 : in std_logic_vector(9 downto 0); --! character 1 bounds
        y_upperbound_ch1 : in std_logic_vector(9 downto 0); --! character 1 bounds

        x_lowerbound_ch2 : in std_logic_vector(9 downto 0); --! character 2 bounds
        x_upperbound_ch2 : in std_logic_vector(9 downto 0); --! character 2 bounds
        y_lowerbound_ch2 : in std_logic_vector(9 downto 0); --! character 2 bounds
        y_upperbound_ch2 : in std_logic_vector(9 downto 0); --! character 2 bounds
        -- percentage from attack module
        percentage_p1 : in std_logic_vector(9 downto 0);
        --------------------------------------------------------------------------------
        -- percentage sprites
        -- char1 dig1
        -- c1d1l1  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l2  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l3  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l4  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l5  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l6  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l7  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l8  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l9  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l10 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l11 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l12 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l13 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l14 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l15 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l16 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l17 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l18 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l19 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- c1d1l20 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
        -- -- char1 dig2
        -- c1d2l1  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l2  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l3  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l4  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l5  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l6  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l7  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l8  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l9  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l10 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l11 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l12 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l13 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l14 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l15 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l16 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l17 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l18 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l19 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- c1d2l20 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
        -- -- char1 dig 3
        -- c1d3l1  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l2  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l3  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l4  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l5  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l6  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l7  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l8  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l9  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l10 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l11 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l12 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l13 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l14 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l15 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l16 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l17 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l18 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l19 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- c1d3l20 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
        -- -- char2 dig1
        -- c2d1l1  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l2  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l3  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l4  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l5  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l6  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l7  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l8  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l9  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l10 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l11 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l12 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l13 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l14 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l15 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l16 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l17 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l18 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l19 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- c2d1l20 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 1
        -- -- char2 dig2
        -- c2d2l1  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l2  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l3  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l4  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l5  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l6  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l7  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l8  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l9  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l10 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l11 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l12 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l13 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l14 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l15 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l16 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l17 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l18 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l19 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- c2d2l20 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 2
        -- -- char2 dig 3
        -- c2d3l1  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l2  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l3  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l4  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l5  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l6  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l7  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l8  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l9  : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l10 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l11 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l12 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l13 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l14 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l15 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l16 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l17 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l18 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l19 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- c2d3l20 : in std_logic_vector(8 downto 0); --! character 2 percentage digit 3
        -- RGB data outputs
        R_data : out std_logic; --! RGB data output
        G_data : out std_logic; --! RGB data output
        B_data : out std_logic --! RGB data output

    );
end entity coloring_new;

architecture behavioural of coloring_new is
    signal uns_hcount, uns_vcount                                 : unsigned(9 downto 0);
    signal ch1x1, ch1x2, ch1y1, ch1y2, ch2x1, ch2x2, ch2y1, ch2y2 : unsigned(9 downto 0);

    component dig3_num_splitter is
        port (
            -- clk       : in std_logic;
            -- reset     : in std_logic;
            num3dig : in std_logic_vector(9 downto 0);
            num1    : out std_logic_vector(3 downto 0);
            num2    : out std_logic_vector(3 downto 0);
            num3    : out std_logic_vector(3 downto 0)
    
        );
    end component;

    component number_sprite is
        port (
        -- clk         : in std_logic;
        number : in std_logic_vector(3 downto 0); -- 9 (max is 1001 in binary)

        line1  : out std_logic_vector(15 downto 0);
        line2  : out std_logic_vector(15 downto 0);
        line3  : out std_logic_vector(15 downto 0);
        line4  : out std_logic_vector(15 downto 0);
        line5  : out std_logic_vector(15 downto 0);
        line6  : out std_logic_vector(15 downto 0);
        line7  : out std_logic_vector(15 downto 0);
        line8  : out std_logic_vector(15 downto 0);
        line9  : out std_logic_vector(15 downto 0);
        line10 : out std_logic_vector(15 downto 0);
        line11 : out std_logic_vector(15 downto 0);
        line12 : out std_logic_vector(15 downto 0);
        line13 : out std_logic_vector(15 downto 0);
        line14 : out std_logic_vector(15 downto 0);
        line15 : out std_logic_vector(15 downto 0);
        line16 : out std_logic_vector(15 downto 0);
        line17 : out std_logic_vector(15 downto 0);
        line18 : out std_logic_vector(15 downto 0);
        line19 : out std_logic_vector(15 downto 0);
        line20 : out std_logic_vector(15 downto 0);
        line21 : out std_logic_vector(15 downto 0);
        line22 : out std_logic_vector(15 downto 0);
        line23 : out std_logic_vector(15 downto 0);
        line24 : out std_logic_vector(15 downto 0)

    );
    end component;



    -- type declaration of the digit array
    type digit_array is array (0 to 23) of std_logic_vector(15 downto 0);
    -- char 1 digit 1 array
    signal char1_dig1 : digit_array;
    -- char 1 digit 2 array
    signal char1_dig2 : digit_array;
    -- char 1 digit 3 array
    signal char1_dig3 : digit_array;
    -- char 2 digit 1 array
    signal char2_dig1 : digit_array;
    -- char 2 digit 2 array
    signal char2_dig2 : digit_array;
    -- char 2 digit 3 array
    signal char2_dig3 : digit_array;


    --digit signals for the number splitter
    signal digit1 : std_logic_vector(3 downto 0);
    signal digit2 : std_logic_vector(3 downto 0);
    signal digit3 : std_logic_vector(3 downto 0);


    -- number sprites player 1 digit1
    -- signal c1d1l1  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l2  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l3  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l4  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l5  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l6  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l7  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l8  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l9  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l10 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l11 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l12 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l13 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l14 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l15 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l16 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l17 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l18 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l19 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1
    -- signal c1d1l20 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 1

    -- -- number sprites player 1 digit 2
    -- signal c1d2l1  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l2  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l3  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l4  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l5  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l6  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l7  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l8  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l9  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l10 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l11 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l12 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l13 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l14 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l15 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l16 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l17 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l18 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l19 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2
    -- signal c1d2l20 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 2

    --     -- number sprites player 1 digit 3
    -- signal c1d3l1  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l2  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l3  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l4  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l5  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l6  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l7  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l8  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l9  : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l10 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l11 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l12 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l13 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l14 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l15 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l16 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l17 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l18 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l19 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3
    -- signal c1d3l20 : in std_logic_vector(8 downto 0); --! character 1 percentage digit 3

    

begin
    --player 1
    percentage_p1_to_digits: dig3_num_splitter port map (num3dig => percentage_p1, num1 => digit1, num2 => digit2, num3 => digit3);
    digit1_p1_to_sprites: number_sprite port map (number => num1, 
    line1 => char1_dig1(0), 
    line2 => char1_dig1(1),
    line3 => char1_dig1(2),
    line4 => char1_dig1(3),
    line5 => char1_dig1(4),
    line6 => char1_dig1(5),
    line7 => char1_dig1(6),
    line8 => char1_dig1(7),
    line9 => char1_dig1(8),
    line10 => char1_dig1(9),
    line11 => char1_dig1(10),
    line12 => char1_dig1(11),
    line13 => char1_dig1(12),
    line14 => char1_dig1(13),
    line15 => char1_dig1(14),
    line16 => char1_dig1(15),
    line17 => char1_dig1(16),
    line18 => char1_dig1(17),
    line19 => char1_dig1(18),
    line20 => char1_dig1(19),
    line21 => char1_dig1(20),
    line22 => char1_dig1(21),
    line23 => char1_dig1(22),
    line24 => char1_dig1(23));

    digit2_p1_to_sprites: number_sprite port map (number => num2, 
    line1 => char1_dig2(0), 
    line2 => char1_dig2(1),
    line3 => char1_dig2(2),
    line4 => char1_dig2(3),
    line5 => char1_dig2(4),
    line6 => char1_dig2(5),
    line7 => char1_dig2(6),
    line8 => char1_dig2(7),
    line9 => char1_dig2(8),
    line10 => char1_dig2(9),
    line11 => char1_dig2(10),
    line12 => char1_dig2(11),
    line13 => char1_dig2(12),
    line14 => char1_dig2(13),
    line15 => char1_dig2(14),
    line16 => char1_dig2(15),
    line17 => char1_dig2(16),
    line18 => char1_dig2(17),
    line19 => char1_dig2(18),
    line20 => char1_dig2(19),
    line21 => char1_dig2(20),
    line22 => char1_dig2(21),
    line23 => char1_dig2(22),
    line24 => char1_dig2(23));

    digit3_p1_to_sprites: number_sprite port map (number => num3, 
    line1 => char1_dig3(0), 
    line2 => char1_dig3(1),
    line3 => char1_dig3(2),
    line4 => char1_dig3(3),
    line5 => char1_dig3(4),
    line6 => char1_dig3(5),
    line7 => char1_dig3(6),
    line8 => char1_dig3(7),
    line9 => char1_dig3(8),
    line10 => char1_dig3(9),
    line11 => char1_dig3(10),
    line12 => char1_dig3(11),
    line13 => char1_dig3(12),
    line14 => char1_dig3(13),
    line15 => char1_dig3(14),
    line16 => char1_dig3(15),
    line17 => char1_dig3(16),
    line18 => char1_dig3(17),
    line19 => char1_dig3(18),
    line20 => char1_dig3(19),
    line21 => char1_dig3(20),
    line22 => char1_dig3(21),
    line23 => char1_dig3(22),
    line24 => char1_dig3(23));

    

   


    uns_hcount <= unsigned(hcount);
    uns_vcount <= unsigned(vcount);
    -- char1 intermediate location assignment
    ch1x1 <= unsigned(x_lowerbound_ch1);
    ch1x2 <= unsigned(x_upperbound_ch1);
    ch1y1 <= unsigned(y_lowerbound_ch1);
    ch1y2 <= unsigned(y_upperbound_ch1);
    -- char2 intermediate location assignment
    ch2x1 <= unsigned(x_lowerbound_ch2);
    ch2x2 <= unsigned(x_upperbound_ch2);
    ch2y1 <= unsigned(y_lowerbound_ch2);
    ch2y2 <= unsigned(y_upperbound_ch2);
   
   

    process (clk, hcount, vcount)
    begin
        if rising_edge(clk) then
            if reset = '1' then --when reset send low signal
                R_data <= '0';
                G_data <= '0';
                B_data <= '0';
            elsif (uns_hcount > 143 and uns_hcount <= 783) and (uns_vcount > 34 and uns_vcount <= 514) then -- active screen time
                -- priority -> highest priority is first, lowest is last
                if (uns_hcount > 143 and uns_hcount <= 783) and (uns_vcount > 429 and uns_vcount <= 434) then --platform horizon (4) pixels thick y = 21 (in coords from below) 
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';

                    --------------------------------------------------------------------------------
                    -- dynamic assignment of pixel colors due to character location
                    --------------------------------------------------------------------------------
                elsif (uns_hcount >= ch1x1 and uns_hcount <= ch1x2) and (uns_vcount >= ch1y1 and uns_vcount <= ch1y2) then --character 1
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                    ------------------------------------------------------------------------------------
                elsif (uns_hcount >= ch2x1 and uns_hcount <= ch2x2) and (uns_vcount >= ch2y1 and uns_vcount <= ch2y2) then --character 2
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                    --------------------------------------------------------------------------------
                    --------------------------------------------------------------------------------
                    -- p1 percentage markings
                    --------------------------------------------------------------------------------
                elsif (uns_hcount > 143 and uns_hcount <= 303) and (uns_vcount > 434 and uns_vcount <= 514) then --player 1 data

                    -- margins we dont need margins right? coz the numbers overwrite the background color (last else statement)  -Parama 
                    -- if (uns_hcount > 143 and uns_hcount <= 151) and (uns_vcount > 434 and uns_vcount <= 514) then -- left margin
                    --     R_data <= '1';
                    --     G_data <= '1';
                    --     B_data <= '1';
                    -- if (uns_hcount > 143 and uns_hcount <= 303) and (uns_vcount > 434 and uns_vcount <= 442) then -- top margin
                    --     R_data <= '1';
                    --     G_data <= '1';
                    --     B_data <= '1';
                    -- elsif (uns_hcount > 143 and uns_hcount <= 303) and (uns_vcount > 506 and uns_vcount <= 514) then -- bottom margin
                    --     R_data <= '1';
                    --     G_data <= '1';
                    --     B_data <= '1';
                    -- elsif (uns_hcount > 219 and uns_hcount <= 303) and (uns_vcount > 434 and uns_vcount <= 514) then -- right margin
                    --     R_data <= '1';
                    --     G_data <= '1';
                    --     B_data <= '1';
                    -- elsif (uns_hcount > 143 and uns_hcount <= 303) and (uns_vcount > 442 and uns_vcount <= 506) then -- inside the margins
                    elsif (uns_hcount > 143 and uns_hcount <= 183) and (uns_vcount > 442 and uns_vcount <= 506) then -- constant P1 image -> entirely white for now
                            R_data <= '1';
                            G_data <= '1';
                            B_data <= '1';
                    elsif (uns_hcount > something and uns_hcount <= something) and (uns_vcount > something and uns_vcount <= something) then -- first digit
                            R_data <= char1_dig1(uns_vcount - something)(uns_hcount - something);
                            G_data <= char1_dig1(uns_vcount - something)(uns_hcount - something);
                            B_data <= char1_dig1(uns_vcount - something)(uns_hcount - something);
                    elsif (uns_hcount > something and uns_hcount <= something) and (uns_vcount > something and uns_vcount <= something) then -- second digit
                            R_data <= char1_dig1(uns_vcount - something)(uns_hcount - something);
                            G_data <= char1_dig1(uns_vcount - something)(uns_hcount - something);
                            B_data <= char1_dig1(uns_vcount - something)(uns_hcount - something);
                    elsif (uns_hcount > something and uns_hcount <= something) and (uns_vcount > something and uns_vcount <= something) then -- second digit
                            R_data <= char1_dig1(uns_vcount - something)(uns_hcount - something);
                            G_data <= char1_dig1(uns_vcount - something)(uns_hcount - something);
                            B_data <= char1_dig1(uns_vcount - something)(uns_hcount - something);
             
             
             


                    else -- fall back for when nothing works -> draw background color: black I wanna test the size of the numbers first -Parama
                        R_data <= '0';
                        G_data <= '0';
                        B_data <= '0';
                    end if;
                elsif (uns_hcount > 184 and uns_hcount <= 223) and (uns_vcount > 434 and uns_vcount <= 514) then --percentage box2-4 -> displaying the numbers

                    -- elsif (uns_hcount > 189 and uns_hcount <= 195) and (uns_vcount > 446 and uns_vcount <= 454) then --line1(0)
                    --     if (p1_dig1_line1(0) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 195 and uns_hcount <= 203) and (uns_vcount > 446 and uns_vcount <= 454) then --line1(1)
                    --     if (p1_dig1_line1(1) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 203 and uns_hcount <= 211) and (uns_vcount > 446 and uns_vcount <= 454) then --line1(2)
                    --     if (p1_dig1_line1(2) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;
                    -- elsif (uns_hcount > 211 and uns_hcount <= 219) and (uns_vcount > 446 and uns_vcount <= 454) then --line1(3)
                    --     if (p1_dig1_line1(3) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 187 and uns_hcount <= 195) and (uns_vcount > 454 and uns_vcount <= 462) then --line2(0)
                    --     if (p1_dig1_line2(0) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 195 and uns_hcount <= 203) and (uns_vcount > 454 and uns_vcount <= 462) then --line2(1)
                    --     if (p1_dig1_line2(1) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 203 and uns_hcount <= 211) and (uns_vcount > 454 and uns_vcount <= 462) then --line2(2)
                    --     if (p1_dig1_line2(2) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;
                    -- elsif (uns_hcount > 211 and uns_hcount <= 219) and (uns_vcount > 454 and uns_vcount <= 462) then --line2(3)
                    --     if (p1_dig1_line2(3) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 187 and uns_hcount <= 195) and (uns_vcount > 462 and uns_vcount <= 470) then --line3(0)
                    --     if (p1_dig1_line3(0) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 195 and uns_hcount <= 203) and (uns_vcount > 462 and uns_vcount <= 470) then --line3(1)
                    --     if (p1_dig1_line3(1) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 203 and uns_hcount <= 211) and (uns_vcount > 462 and uns_vcount <= 470) then --line3(2)
                    --     if (p1_dig1_line3(2) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;
                    -- elsif (uns_hcount > 211 and uns_hcount <= 219) and (uns_vcount > 462 and uns_vcount <= 470) then --line3(3)
                    --     if (p1_dig1_line3(3) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 187 and uns_hcount <= 195) and (uns_vcount > 470 and uns_vcount <= 478) then --line4(0)
                    --     if (p1_dig1_line4(0) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 195 and uns_hcount <= 203) and (uns_vcount > 470 and uns_vcount <= 478) then --line4(1)
                    --     if (p1_dig1_line4(1) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 203 and uns_hcount <= 211) and (uns_vcount > 470 and uns_vcount <= 478) then --line4(2)
                    --     if (p1_dig1_line4(2) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;
                    -- elsif (uns_hcount > 211 and uns_hcount <= 219) and (uns_vcount > 470 and uns_vcount <= 478) then --line4(3)
                    --     if (p1_dig1_line4(3) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 187 and uns_hcount <= 195) and (uns_vcount > 478 and uns_vcount <= 486) then --line5(0)
                    --     if (p1_dig1_line5(0) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 195 and uns_hcount <= 203) and (uns_vcount > 478 and uns_vcount <= 486) then --line5(1)
                    --     if (p1_dig1_line5(1) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 203 and uns_hcount <= 211) and (uns_vcount > 478 and uns_vcount <= 486) then --line5(2)
                    --     if (p1_dig1_line1(2) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;
                    -- elsif (uns_hcount > 211 and uns_hcount <= 219) and (uns_vcount > 478 and uns_vcount <= 486) then --line5(3)
                    --     if (p1_dig1_line5(3) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 187 and uns_hcount <= 195) and (uns_vcount > 486 and uns_vcount <= 494) then --line6(0)
                    --     if (p1_dig1_line6(0) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 195 and uns_hcount <= 203) and (uns_vcount > 486 and uns_vcount <= 494) then --line6(1)
                    --     if (p1_dig1_line6(1) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 203 and uns_hcount <= 211) and (uns_vcount > 486 and uns_vcount <= 494) then --line6(2)
                    --     if (p1_dig1_line6(2) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;
                    -- elsif (uns_hcount > 211 and uns_hcount <= 219) and (uns_vcount > 486 and uns_vcount <= 494) then --line6(3)
                    --     if (p1_dig1_line6(3) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 187 and uns_hcount <= 195) and (uns_vcount > 494 and uns_vcount <= 502) then --line7(0)
                    --     if (p1_dig1_line7(0) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 195 and uns_hcount <= 203) and (uns_vcount > 494 and uns_vcount <= 502) then --line7(1)
                    --     if (p1_dig1_line7(1) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                    -- elsif (uns_hcount > 203 and uns_hcount <= 211) and (uns_vcount > 494 and uns_vcount <= 502) then --line7(2)
                    --     if (p1_dig1_line7(2) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;
                    -- elsif (uns_hcount > 211 and uns_hcount <= 219) and (uns_vcount > 494 and uns_vcount <= 502) then --line7(3)
                    --     if (p1_dig1_line7(3) = 1) then
                    --         R_data <= '1';
                    --         G_data <= '1';
                    --         B_data <= '1';
                    --     else
                    --         R_data <= '0';
                    --         G_data <= '0';
                    --         B_data <= '0';
                    --     end if;

                elsif (uns_hcount > 223 and uns_hcount <= 263) and (uns_vcount > 434 and uns_vcount <= 514) then --percentage box3 player 1

                    --idem (ik wil nu even aan lindiff werken haha)

                elsif (uns_hcount > 263 and uns_hcount <= 303) and (uns_vcount > 434 and uns_vcount <= 514) then --percentage box4 player 1

                    --idem
                elsif (uns_hcount >= 624 and uns_hcount <= 663) and (uns_vcount >= 497 and uns_vcount <= 514) then --percentage box1 player 2
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                elsif (uns_hcount >= 664 and uns_hcount <= 703) and (uns_vcount >= 497 and uns_vcount <= 514) then --percentage box2 player 2 
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                elsif (uns_hcount >= 704 and uns_hcount <= 743) and (uns_vcount >= 497 and uns_vcount <= 514) then --percentage box3 player 2
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                elsif (uns_hcount >= 744 and uns_hcount <= 783) and (uns_vcount >= 497 and uns_vcount <= 514) then --percentage box4 player 2
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';

                else -- when not on active screen time send low signal
                    R_data <= '0';
                    G_data <= '0';
                    B_data <= '0';
                end if;
            else
                R_data <= '0';
                G_data <= '0';
                B_data <= '0';
            end if;
        end if;
    end process;

end architecture;