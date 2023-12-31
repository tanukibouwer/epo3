--module: coloring_new
--version: 3.2.9
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
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity coloring_new is
    port (
        -- global inputs
        clk   : in std_logic;
        reset : in std_logic;
        -- counter data
        hcount : in std_logic_vector(9 downto 0);
        vcount : in std_logic_vector(9 downto 0);
        -- relevant data for x-y locations
        char1x : in std_logic_vector(7 downto 0); --! character 1 coordinates
        char1y : in std_logic_vector(7 downto 0); --! character 1 coordinates
        char2x : in std_logic_vector(7 downto 0); --! character 2 coordinates
        char2y : in std_logic_vector(7 downto 0); --! character 2 coordinates
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
        R_data : out std_logic_vector(3 downto 0); --! RGB data output
        G_data : out std_logic_vector(3 downto 0); --! RGB data output
        B_data : out std_logic_vector(3 downto 0)  --! RGB data output

    );
end entity coloring_new;

architecture behavioural of coloring_new is

    component dig3_num_splitter is
        port (
            num3dig : in std_logic_vector(7 downto 0);
            num1    : out std_logic_vector(3 downto 0);
            num2    : out std_logic_vector(3 downto 0);
            num3    : out std_logic_vector(3 downto 0)

        );
    end component;

    component number_sprite is
        port (
            reset  : in std_logic;
            number : in std_logic_vector(3 downto 0); -- 9 (max is 1001 in binary)
            hcount : in std_logic_vector(9 downto 0);
            vcount : in std_logic_vector(9 downto 0);
            boundx : in std_logic_vector(9 downto 0);
            boundy : in std_logic_vector(9 downto 0);

            R_data : out std_logic_vector(3 downto 0);
            G_data : out std_logic_vector(3 downto 0);
            B_data : out std_logic_vector(3 downto 0)

        );
    end component;

    component char_offset_adder is
        port (
            xpos      : in std_logic_vector(7 downto 0);
            ypos      : in std_logic_vector(7 downto 0);
            xpos_scl1 : out std_logic_vector(9 downto 0);
            xpos_scl2 : out std_logic_vector(9 downto 0);
            ypos_scl1 : out std_logic_vector(9 downto 0);
            ypos_scl2 : out std_logic_vector(9 downto 0)
        );
    end component;

    component char_sprites is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            -- controller input information
            orientation : in std_logic;
            controller  : in std_logic_vector(7 downto 0);
            -- going through the array
            -- count for where one is
            hcount : in std_logic_vector(9 downto 0);
            vcount : in std_logic_vector(9 downto 0);
            -- top and left bounds for normalisation
            boundx : in std_logic_vector(9 downto 0);
            boundy : in std_logic_vector(9 downto 0);
    
            -- RGB outputs
            R_data : out std_logic_vector(3 downto 0);
            G_data : out std_logic_vector(3 downto 0);
            B_data : out std_logic_vector(3 downto 0)
    
        );
    end component;

    -- subtype color_val is std_logic range '0' to '1';
    subtype color_val is std_logic_vector(11 downto 0); -- R(11,10,9,8) G(7,6,5,4) B(3,2,1,0)
    type num_sprite_x is array (0 to 15) of color_val;
    type num_sprite_y is array (0 to 23) of num_sprite_x;

    constant char1_digc : num_sprite_y := ((("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111011101110"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"))
    );
    constant char2_digc : num_sprite_y := ((("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111011101110"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("001101100011"), ("001101100011"), ("111111111111"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("111111111111"), ("111111111111"), ("111111111111"), ("111111111111"), ("001101100011"), ("001101100011")),
    (("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"), ("001101100011"))
    );

    -- unsigned count values
    signal uns_hcount, uns_vcount : unsigned(9 downto 0);

    --------------------------------------------------------------------------------
    -- signals for the number sprite output module
    --------------------------------------------------------------------------------
    -- seperated digits
    signal p1digit1 : std_logic_vector(3 downto 0);
    signal p1digit2 : std_logic_vector(3 downto 0);
    signal p1digit3 : std_logic_vector(3 downto 0);
    signal p2digit1 : std_logic_vector(3 downto 0);
    signal p2digit2 : std_logic_vector(3 downto 0);
    signal p2digit3 : std_logic_vector(3 downto 0);

    -- RGB outputs for digits --> get assigned to the outputs when required
    signal p1d1R, p1d1G, p1d1B : std_logic_vector(3 downto 0); -- player 1 digit 1 RGB outputs
    signal p1d2R, p1d2G, p1d2B : std_logic_vector(3 downto 0); -- player 1 digit 2 RGB outputs
    signal p1d3R, p1d3G, p1d3B : std_logic_vector(3 downto 0); -- player 1 digit 3 RGB outputs
    signal p2d1R, p2d1G, p2d1B : std_logic_vector(3 downto 0); -- player 2 digit 1 RGB outputs
    signal p2d2R, p2d2G, p2d2B : std_logic_vector(3 downto 0); -- player 2 digit 2 RGB outputs
    signal p2d3R, p2d3G, p2d3B : std_logic_vector(3 downto 0); -- player 2 digit 3 RGB outputs

    -- top (y) and left (x) bounds for number sprite locations --> these are the box bounds in which the number sprites occur
    signal digsby                 : std_logic_vector(9 downto 0);
    signal p1d1bx, p1d2bx, p1d3bx : std_logic_vector(9 downto 0);
    signal p2d1bx, p2d2bx, p2d3bx : std_logic_vector(9 downto 0);

    -- constants for the box bounds for numbers
    -- to move the digit locations change these variables
    constant int_digsby : integer := 462; -- global y location for digits -> keep them on the same height
    constant int_p1dcbx : integer := 155; -- x location for player 1 constant image
    constant int_p1d1bx : integer := 196; -- x location for player 1 digit 1
    constant int_p1d2bx : integer := 236; -- x location for player 1 digit 2
    constant int_p1d3bx : integer := 276; -- x location for player 1 digit 3
    constant int_p2dcbx : integer := 635; -- x location for player 2 constant image
    constant int_p2d1bx : integer := 675; -- x location for player 2 digit 1
    constant int_p2d2bx : integer := 715; -- x location for player 2 digit 2
    constant int_p2d3bx : integer := 755; -- x location for player 2 digit 3


    --------------------------------------------------------------------------------
    -- signals for the character sprites
    --------------------------------------------------------------------------------
    --
    signal p1R : std_logic_vector(3 downto 0);
    signal p1G : std_logic_vector(3 downto 0);
    signal p1B : std_logic_vector(3 downto 0);
    signal p2R : std_logic_vector(3 downto 0);
    signal p2G : std_logic_vector(3 downto 0);
    signal p2B : std_logic_vector(3 downto 0);
    --------------------------------------------------------------------------------
    -- signals for character bounds
    --------------------------------------------------------------------------------

    -- output signals from the offset adders
    signal x_lowerbound_ch1 : std_logic_vector(9 downto 0); -- character 1 bounds
    signal x_upperbound_ch1 : std_logic_vector(9 downto 0); -- character 1 bounds
    signal y_lowerbound_ch1 : std_logic_vector(9 downto 0); -- character 1 bounds
    signal y_upperbound_ch1 : std_logic_vector(9 downto 0); -- character 1 bounds
    signal x_lowerbound_ch2 : std_logic_vector(9 downto 0); -- character 2 bounds
    signal x_upperbound_ch2 : std_logic_vector(9 downto 0); -- character 2 bounds
    signal y_lowerbound_ch2 : std_logic_vector(9 downto 0); -- character 2 bounds
    signal y_upperbound_ch2 : std_logic_vector(9 downto 0); -- character 2 bounds

    -- unsigned version of the above signals
    signal ch1x1, ch1x2, ch1y1, ch1y2, ch2x1, ch2x2, ch2y1, ch2y2 : unsigned(9 downto 0);
begin
    --------------------------------------------------------------------------------
    -- character offsets --> see label name for which character
    --------------------------------------------------------------------------------
    char_offset1 : char_offset_adder port map(
        xpos => char1x, ypos => char1y,
        xpos_scl1 => x_lowerbound_ch1, xpos_scl2 => x_upperbound_ch1,
        ypos_scl1 => y_lowerbound_ch1, ypos_scl2 => y_upperbound_ch1
    );
    char_offset2 : char_offset_adder port map(
        xpos => char2x, ypos => char2y,
        xpos_scl1 => x_lowerbound_ch2, xpos_scl2 => x_upperbound_ch2,
        ypos_scl1 => y_lowerbound_ch2, ypos_scl2 => y_upperbound_ch2
    );

    --------------------------------------------------------------------------------
    -- extract digit sprites from the numbers
    --------------------------------------------------------------------------------
    -- seperate player 1 dmg percentage
    percentage_p1_to_digits : dig3_num_splitter port map(
        num3dig => percentage_p1, num1 => p1digit1, num2 => p1digit2, num3 => p1digit3
    );
    -- assign the RGB outputs according to the sprites
    data_dig1_p1 : number_sprite port map(
        reset => reset, number => p1digit1, boundx => p1d1bx,
        boundy => digsby, hcount => hcount, vcount => vcount,
        R_data => p1d1R, B_data => p1d1B, G_data => p1d1G
    );
    data_dig2_p1 : number_sprite port map(
        reset => reset, number => p1digit2, boundx => p1d2bx,
        boundy => digsby, hcount => hcount, vcount => vcount,
        R_data => p1d2R, B_data => p1d2B, G_data => p1d2G
    );
    data_dig3_p1 : number_sprite port map(
        reset => reset, number => p1digit3, boundx => p1d3bx,
        boundy => digsby, hcount => hcount, vcount => vcount,
        R_data => p1d3R, B_data => p1d3B, G_data => p1d3G
    );
    -- seperate player 2 dmg percentage
    percentage_p2_to_digits : dig3_num_splitter port map(
        num3dig => percentage_p2, num1 => p2digit1, num2 => p2digit2, num3 => p2digit3
    );
    -- assign the RGB outputs according to the sprites
    data_dig1_p2 : number_sprite port map(
        reset => reset, number => p2digit1, boundx => p2d1bx,
        boundy => digsby, hcount => hcount, vcount => vcount,
        R_data => p2d1R, B_data => p2d1B, G_data => p2d1G
    );
    data_dig2_p2 : number_sprite port map(
        reset => reset, number => p2digit2, boundx => p2d2bx,
        boundy => digsby, hcount => hcount, vcount => vcount,
        R_data => p2d2R, B_data => p2d2B, G_data => p2d2G
    );
    data_dig3_p2 : number_sprite port map(
        reset => reset, number => p2digit3, boundx => p2d3bx,
        boundy => digsby, hcount => hcount, vcount => vcount,
        R_data => p2d3R, B_data => p2d3B, G_data => p2d3G
    );

    --------------------------------------------------------------------------------
    -- assign the correct character sprite for the animations
    --------------------------------------------------------------------------------
    -- player 1
    char1_sprite : char_sprites port map (
        clk => clk,
        reset => reset,
        orientation => orientationp1,
        controller => controllerp1,
        hcount => hcount,
        vcount => vcount,
        boundx => x_lowerbound_ch1,
        boundy => y_lowerbound_ch1,
        R_data => p1R,
        G_data => p1G,
        B_data => p1B
    );
    -- player 2
    char2_sprite : char_sprites port map (
        clk => clk,
        reset => reset,
        orientation => orientationp2,
        controller => controllerp2,
        hcount => hcount,
        vcount => vcount,
        boundx => x_lowerbound_ch2,
        boundy => y_lowerbound_ch2,
        R_data => p2R,
        G_data => p2G,
        B_data => p2B
    );
    --------------------------------------------------------------------------------
    -- standard/global assignments
    --------------------------------------------------------------------------------
    -- assign the unsigned counts
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
    -- convert constant integers to vectors to enter into the number sprite modules
    digsby <= std_logic_vector(to_unsigned(int_digsby, digsby'length));
    p1d1bx <= std_logic_vector(to_unsigned(int_p1d1bx, p1d1bx'length));
    p1d2bx <= std_logic_vector(to_unsigned(int_p1d2bx, p1d2bx'length));
    p1d3bx <= std_logic_vector(to_unsigned(int_p1d3bx, p1d3bx'length));
    p2d1bx <= std_logic_vector(to_unsigned(int_p2d1bx, p1d1bx'length));
    p2d2bx <= std_logic_vector(to_unsigned(int_p2d2bx, p1d2bx'length));
    p2d3bx <= std_logic_vector(to_unsigned(int_p2d3bx, p1d3bx'length));

    --------------------------------------------------------------------------------
    -- color choice process
    --------------------------------------------------------------------------------
    process (clk, hcount, vcount)
    begin
        if rising_edge(clk) then
            if reset = '1' then --when reset send low signal
                R_data <= "0000";
                G_data <= "0000";
                B_data <= "0000";
            elsif (uns_hcount > 143 and uns_hcount <= 783) and (uns_vcount > 34 and uns_vcount <= 514) then -- active screen time
                -- assuming priority -> highest priority is first, lowest is last -> think of placing images on top of each other
                --------------------------------------------------------------------------------
                -- show platforms
                --------------------------------------------------------------------------------
                -- ground platform
                if (uns_hcount > 143 and uns_hcount <= 783) and (uns_vcount > 429 and uns_vcount <= 434) then --platform horizon 4 pixels thick y = 21 (in coords from below) 
                    -- color in hex: #104000
                    R_data <= "0001";
                    G_data <= "0100";
                    B_data <= "0000";
                    -- floating platforms
                elsif (uns_hcount > 183 and uns_hcount <= 379) and (uns_vcount > 314 and uns_vcount <= 318) then --platform 1, (10,69) --> (59,70)
                    -- color in hex: #FFFFFF
                    R_data <= "1111";
                    G_data <= "1111";
                    B_data <= "1111";
                elsif (uns_hcount > 543 and uns_hcount <= 739) and (uns_vcount > 314 and uns_vcount <= 318) then --platform 2, (100,69) --> (149,70)
                    -- color in hex: #FFFFFF
                    R_data <= "1111";
                    G_data <= "1111";
                    B_data <= "1111";
                elsif (uns_hcount > 363 and uns_hcount <= 559) and (uns_vcount > 182 and uns_vcount <= 186) then --platform 3, (55,36) --> (104,37)
                    -- color in hex: #FFFFFF
                    R_data <= "1111";
                    G_data <= "1111";
                    B_data <= "1111";
                    --------------------------------------------------------------------------------
                    -- dynamic assignment of pixel colors due to character location
                    --------------------------------------------------------------------------------
                elsif (uns_hcount >= ch1x1 and uns_hcount <= ch1x2) and (uns_vcount >= ch1y1 and uns_vcount <= ch1y2) then --character 1
                    -- color in hex: #41FF00
                    R_data <= p1R;
                    G_data <= p1G;
                    B_data <= p1B;
                elsif (uns_hcount >= ch2x1 and uns_hcount <= ch2x2) and (uns_vcount >= ch2y1 and uns_vcount <= ch2y2) then --character 2
                    -- color in hex: #00FFFF
                    R_data <= p2R;
                    G_data <= p2G;
                    B_data <= p2B;

                    --------------------------------------------------------------------------------
                    -- percentage markings and displaying game data on screen
                    --------------------------------------------------------------------------------
                elsif (uns_hcount > 143 and uns_hcount <= 783) and (uns_vcount > 434 and uns_vcount <= 514) then
                    ----------------------------------------------------------------------------
                    -- first assign background color for numbers -> data background when not displaying numbers
                    -- then assign the appropriate number sprite colours
                    -- this background is different from playable game background
                    -- color in hex: #3f6f3f
                    ----------------------------------------------------------------------------
                    R_data <= "0011";
                    G_data <= "0110";
                    B_data <= "0011";

                    --------------------------------------------------------------------------------
                    -- p1 percentage markings
                    --------------------------------------------------------------------------------
                    --143 to 183 horizontale indeling, margins: 12 left and right & 28 up and bottom
                    if (uns_hcount > int_p1dcbx and uns_hcount <= int_p1dcbx + 16) and (uns_vcount > 462 and uns_vcount <= int_digsby + 24) then -- constant digit
                        R_data <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156)(11 downto 8);
                        G_data <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156)(7 downto 4);
                        B_data <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156)(3 downto 0);
                    elsif (uns_hcount > int_p1d1bx and uns_hcount <= int_p1d1bx + 16) and (uns_vcount > int_digsby and uns_vcount <= int_digsby + 24) then -- first digit --183 to 223 idem
                        R_data <= p1d1R;
                        G_data <= p1d1G;
                        B_data <= p1d1B;
                    elsif (uns_hcount > int_p1d2bx and uns_hcount <= int_p1d2bx + 16) and (uns_vcount > int_digsby and uns_vcount <= int_digsby + 24) then -- second digit --223 to 263 idem
                        R_data <= p1d2R;
                        G_data <= p1d2G;
                        B_data <= p1d2B;
                    elsif (uns_hcount > int_p1d3bx and uns_hcount <= int_p1d3bx + 16) and (uns_vcount > int_digsby and uns_vcount <= int_digsby + 24) then -- third digit --263 to 303 idem
                        R_data <= p1d3R;
                        G_data <= p1d3G;
                        B_data <= p1d3B;
                    --------------------------------------------------------------------------------
                    -- p2 percentage markings 
                    --------------------------------------------------------------------------------
                    --623 to 663 horizontale indeling, margins: 12 left and right & 28 up and bottom
                    elsif (uns_hcount > int_p2dcbx and uns_hcount <= int_p2dcbx + 16) and (uns_vcount > 462 and uns_vcount <= int_digsby + 24) then -- constant digit
                        R_data <= char2_digc(to_integer(uns_vcount) - int_digsby)(to_integer(uns_hcount) - 635)(11 downto 8);
                        G_data <= char2_digc(to_integer(uns_vcount) - int_digsby)(to_integer(uns_hcount) - 635)(7 downto 4);
                        B_data <= char2_digc(to_integer(uns_vcount) - int_digsby)(to_integer(uns_hcount) - 635)(3 downto 0);
                    elsif (uns_hcount > int_p2d1bx and uns_hcount <= int_p2d1bx + 16) and (uns_vcount > int_digsby and uns_vcount <= int_digsby + 24) then -- first digit -- 663 to 703 idem
                        R_data <= p2d1R;
                        G_data <= p2d1G;
                        B_data <= p2d1B;
                    elsif (uns_hcount > int_p2d2bx and uns_hcount <= int_p2d2bx + 16) and (uns_vcount > int_digsby and uns_vcount <= int_digsby + 24) then -- second digit --703 to 743 idem
                        R_data <= p2d2R;
                        G_data <= p2d2G;
                        B_data <= p2d2B;
                    elsif (uns_hcount > int_p2d3bx and uns_hcount <= int_p2d3bx + 16) and (uns_vcount > int_digsby and uns_vcount <= int_digsby + 24) then -- third digit --743 to 783 idem
                        R_data <= p2d3R;
                        G_data <= p2d3G;
                        B_data <= p2d3B;
                    else -- fallback -> for when no sprite is active such that no sprite colours are wrongly bleeding through
                        -- color in hex: #3f6f3f
                        R_data <= "0011";
                        G_data <= "0110";
                        B_data <= "0011";
                    end if;

                else -- global background color --> the sky background in the playable stage
                    R_data <= "0000";
                    G_data <= "1100";
                    B_data <= "1111";
                end if;
            else -- fall back for when a case is not defined --> easy to find if there is an error
                R_data <= "0000";
                G_data <= "0000";
                B_data <= "0000";
            end if;
        end if;
    end process;

end architecture;