--module: coloring
--version: b2.9.5.cri
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
        --! global inputs
        clk   : in std_logic;
        reset : in std_logic;
        --! counter data
        hcount : in std_logic_vector(9 downto 0);
        vcount : in std_logic_vector(9 downto 0);
        -- relevant data for x-y locations
        char1x : in std_logic_vector(7 downto 0); --! character 1 coordinates
        char1y : in std_logic_vector(7 downto 0); --! character 1 coordinates
        char2x : in std_logic_vector(7 downto 0); --! character 2 coordinates
        char2y : in std_logic_vector(7 downto 0); --! character 2 coordinates

        -- percentage from attack module
        percentage_p1 : in std_logic_vector(9 downto 0);

        -- RGB data outputs
        R_data : out std_logic_vector(3 downto 0); --! RGB data output
        G_data : out std_logic_vector(3 downto 0); --! RGB data output
        B_data : out std_logic_vector(3 downto 0)  --! RGB data output

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

    subtype color_val is std_logic range '0' to '1';
    type num_sprite_x is array (0 to 15) of color_val;
    type num_sprite_y is array (0 to 23) of num_sprite_x;

    constant char1_digc : num_sprite_y := (
        (('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0')),
        (('0'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('0')),
        (('0'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('0')),
        (('0'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('0')),
        (('0'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('0')),
        (('0'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('0')),
        (('0'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('0')),
        (('0'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('0')),
        (('0'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('0')),
        (('0'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('0')),
        (('0'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('1'),('0')),
        (('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0')),
        (('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0')),
        (('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0')),
        (('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0')),
        (('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0')),
        (('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('1'),('1'),('1'),('0'),('0')),
        (('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('1'),('1'),('1'),('0'),('0')),
        (('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('1'),('1'),('1'),('0'),('0')),
        (('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('1'),('1'),('1'),('0'),('0')),
        (('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('1'),('1'),('1'),('0'),('0')),
        (('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('1'),('1'),('1'),('0'),('0')),
        (('0'),('1'),('1'),('1'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('1'),('1'),('1'),('0'),('0')),
        (('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'))
        );

    -- type declaration of the digit array
    type digit_array is array (0 to 23) of std_logic_vector(0 to 15);
    -- char 1 constant digit array
    -- signal char1_digc : digit_array;
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

    -- digit signals for the number splitter
    signal digit1 : std_logic_vector(3 downto 0);
    signal digit2 : std_logic_vector(3 downto 0);
    signal digit3 : std_logic_vector(3 downto 0);

    -- character location bounds
    signal x_lowerbound_ch1 : std_logic_vector(9 downto 0); -- character 1 bounds
    signal x_upperbound_ch1 : std_logic_vector(9 downto 0); -- character 1 bounds
    signal y_lowerbound_ch1 : std_logic_vector(9 downto 0); -- character 1 bounds
    signal y_upperbound_ch1 : std_logic_vector(9 downto 0); -- character 1 bounds
    signal x_lowerbound_ch2 : std_logic_vector(9 downto 0); -- character 2 bounds
    signal x_upperbound_ch2 : std_logic_vector(9 downto 0); -- character 2 bounds
    signal y_lowerbound_ch2 : std_logic_vector(9 downto 0); -- character 2 bounds
    signal y_upperbound_ch2 : std_logic_vector(9 downto 0); -- character 2 bounds

begin

    -- character offsets
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

    -- player 1
    percentage_p1_to_digits : dig3_num_splitter port map(
        num3dig => percentage_p1, num1 => digit1, num2 => digit2, num3 => digit3);

    digit1_p1_to_sprites : number_sprite port map(
        number => digit1,
        line1  => char1_dig1(0),
        line2  => char1_dig1(1),
        line3  => char1_dig1(2),
        line4  => char1_dig1(3),
        line5  => char1_dig1(4),
        line6  => char1_dig1(5),
        line7  => char1_dig1(6),
        line8  => char1_dig1(7),
        line9  => char1_dig1(8),
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

    digit2_p1_to_sprites : number_sprite port map(
        number => digit2,
        line1  => char1_dig2(0),
        line2  => char1_dig2(1),
        line3  => char1_dig2(2),
        line4  => char1_dig2(3),
        line5  => char1_dig2(4),
        line6  => char1_dig2(5),
        line7  => char1_dig2(6),
        line8  => char1_dig2(7),
        line9  => char1_dig2(8),
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

    digit3_p1_to_sprites : number_sprite port map(
        number => digit3,
        line1  => char1_dig3(0),
        line2  => char1_dig3(1),
        line3  => char1_dig3(2),
        line4  => char1_dig3(3),
        line5  => char1_dig3(4),
        line6  => char1_dig3(5),
        line7  => char1_dig3(6),
        line8  => char1_dig3(7),
        line9  => char1_dig3(8),
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

    --constant image p1 

    -- char1_digc(0)  <= "0000000000000000";
    -- char1_digc(1)  <= "0111111111111110";
    -- char1_digc(2)  <= "0111111111111110";
    -- char1_digc(3)  <= "0111111111111110";
    -- char1_digc(4)  <= "0111111111111110";
    -- char1_digc(5)  <= "0111111111111110";
    -- char1_digc(6)  <= "0111111111111110";
    -- char1_digc(7)  <= "0111111111111110";
    -- char1_digc(8)  <= "0111111111111110";
    -- char1_digc(9)  <= "0111111111111110";
    -- char1_digc(10) <= "0111111111111110";
    -- char1_digc(11) <= "0111000000000000";
    -- char1_digc(12) <= "0111000000000000";
    -- char1_digc(13) <= "0111000000000000";
    -- char1_digc(14) <= "0111000000000000";
    -- char1_digc(15) <= "0111000000000000";
    -- char1_digc(16) <= "0111000000111100";
    -- char1_digc(17) <= "0111000000111100";
    -- char1_digc(18) <= "0111000000111100";
    -- char1_digc(19) <= "0111000000111100";
    -- char1_digc(20) <= "0111000000111100";
    -- char1_digc(21) <= "0111000000111100";
    -- char1_digc(22) <= "0111000000111100";
    -- char1_digc(23) <= "0000000000000000";

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
                R_data <= "0000";
                G_data <= "0000";
                B_data <= "0000";
            elsif (uns_hcount > 143 and uns_hcount <= 783) and (uns_vcount > 34 and uns_vcount <= 514) then -- active screen time
                -- priority -> highest priority is first, lowest is last
                if (uns_hcount > 143 and uns_hcount <= 783) and (uns_vcount > 429 and uns_vcount <= 434) then --platform horizon 4 pixels thick y = 21 (in coords from below) 
                    -- color in hex: #104000
                    R_data <= "0001";
                    G_data <= "0100";
                    B_data <= "0000";

                elsif (uns_hcount > 183 and uns_hcount <= 379) and (uns_vcount > 310 and uns_vcount <= 314) then --platform 1, (10,69) --> (59,70)
                    -- color in hex: #FFFFFF
                    R_data <= "1111";
                    G_data <= "1111";
                    B_data <= "1111";
                elsif (uns_hcount > 543 and uns_hcount <= 739) and (uns_vcount > 310 and uns_vcount <= 314) then --platform 2, (100,69) --> (149,70)
                    -- color in hex: #FFFFFF
                    R_data <= "1111";
                    G_data <= "1111";
                    B_data <= "1111";
                elsif (uns_hcount > 363 and uns_hcount <= 559) and (uns_vcount > 178     and uns_vcount <= 182) then --platform 3, (55,36) --> (104,37)
                    -- color in hex: #FFFFFF
                    R_data <= "1111";
                    G_data <= "1111";
                    B_data <= "1111";
                    --------------------------------------------------------------------------------
                    -- dynamic assignment of pixel colors due to character location
                    --------------------------------------------------------------------------------
                elsif (uns_hcount >= ch1x1 and uns_hcount <= ch1x2) and (uns_vcount >= ch1y1 and uns_vcount <= ch1y2) then --character 1
                    -- color in hex: #41FF00
                    R_data <= "0100";
                    G_data <= "1111";
                    B_data <= "0000";
                elsif (uns_hcount >= ch2x1 and uns_hcount <= ch2x2) and (uns_vcount >= ch2y1 and uns_vcount <= ch2y2) then --character 2
                    -- color in hex: #00FFFF
                    R_data <= "0000";
                    G_data <= "1111";
                    B_data <= "1111";
                    --------------------------------------------------------------------------------
                    -- p1 percentage markings
                    --------------------------------------------------------------------------------
                elsif (uns_hcount > 143 and uns_hcount <= 303) and (uns_vcount > 434 and uns_vcount <= 514) then --player 1 data: 143 to 303 horizontal
                    --------------------------------------------------------------------------------
                    -- first assign background color for numbers
                    -- if any of the following statements be true, then assign a different color
                    -- this background is different from playable game background
                    -- color in hex: #3f6f3f
                    --------------------------------------------------------------------------------
                    R_data <= "0100";
                    G_data <= "0111";
                    B_data <= "0100";

                    --143 to 183 horizontale indeling, margins: 12 left and right & 28 up and bottom
                    if (uns_hcount > 155 and uns_hcount <= 171) and (uns_vcount > 462 and uns_vcount <= 486) then -- constant digit
                        R_data(0) <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156);
                        R_data(1) <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156);
                        R_data(2) <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156);
                        R_data(3) <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156);
                        G_data(0) <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156);
                        G_data(1) <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156);
                        G_data(2) <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156);
                        G_data(3) <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156);
                        B_data(0) <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156);
                        B_data(1) <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156);
                        B_data(2) <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156);
                        B_data(3) <= char1_digc(to_integer(uns_vcount) - 463)(to_integer(uns_hcount) - 156);
                    elsif (uns_hcount > 195 and uns_hcount <= 211) and (uns_vcount > 462 and uns_vcount <= 486) then -- first digit --183 to 223 idem
                        R_data <= "1111";
                        G_data <= "1111";
                        B_data <= "1111";
                    elsif (uns_hcount > 235 and uns_hcount <= 251) and (uns_vcount > 462 and uns_vcount <= 486) then -- second digit --223 to 263 idem
                        R_data <= "1111";
                        G_data <= "1111";
                        B_data <= "1111";
                    elsif (uns_hcount > 275 and uns_hcount <= 291) and (uns_vcount > 462 and uns_vcount <= 486) then -- third digit --263 to 303 idem
                        R_data <= "1111";
                        G_data <= "1111";
                        B_data <= "1111";
                    else -- fallback for testing purposes black
                        R_data <= "0000";
                        G_data <= "0000";
                        B_data <= "0000";
                    end if;

                    --------------------------------------------------------------------------------
                    -- p2 percentage markings 
                    --------------------------------------------------------------------------------
                elsif (uns_hcount > 623 and uns_hcount <= 783) and (uns_vcount > 434 and uns_vcount <= 514) then --player 2 data: 623 to 783
                    --------------------------------------------------------------------------------
                    -- first assign background color for numbers
                    -- if any of the following statements be true, then assign a different color
                    -- this background is different from playable game background
                    -- color in hex: #3f6f3f
                    --------------------------------------------------------------------------------
                    R_data <= "0100";
                    B_data <= "0111";
                    G_data <= "0100";

                    --623 to 663 horizontale indeling, margins: 12 left and right & 28 up and bottom
                    if (uns_hcount > 635 and uns_hcount <= 651) and (uns_vcount > 462 and uns_vcount <= 486) then -- constant digit
                        R_data <= "1111";
                        G_data <= "1111";
                        B_data <= "1111";
                    elsif (uns_hcount > 675 and uns_hcount <= 691) and (uns_vcount > 462 and uns_vcount <= 486) then -- first digit -- 663 to 703 idem
                        R_data <= "1111";
                        G_data <= "1111";
                        B_data <= "1111";
                    elsif (uns_hcount > 715 and uns_hcount <= 731) and (uns_vcount > 462 and uns_vcount <= 486) then -- second digit --703 to 743 idem
                        R_data <= "1111";
                        G_data <= "1111";
                        B_data <= "1111";
                    elsif (uns_hcount > 755 and uns_hcount <= 771) and (uns_vcount > 462 and uns_vcount <= 486) then -- third digit --743 to 783 idem
                        R_data <= "1111";
                        G_data <= "1111";
                        B_data <= "1111";
                    else -- fallback for testing purposes black
                        R_data <= "0000";
                        G_data <= "0000";
                        B_data <= "0000";
                    end if;

                elsif (uns_hcount > 184 and uns_hcount <= 223) and (uns_vcount > 434 and uns_vcount <= 514) then --percentage box2-4 -> displaying the numbers
                    -- black for testing purposes
                    R_data <= "0000";
                    G_data <= "0000";
                    B_data <= "0000";

                else -- global background color
                    R_data <= "0000";
                    G_data <= "1100";
                    B_data <= "1111";
                end if;
            else -- fall back for when a case is not defined
                R_data <= "0000";
                G_data <= "0000";
                B_data <= "0000";
            end if;
        end if;
    end process;

end architecture;