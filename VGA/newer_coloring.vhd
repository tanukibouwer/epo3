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

        -- x_lowerbound_ch1 : in std_logic_vector(9 downto 0); --! character 1 bounds
        -- x_upperbound_ch1 : in std_logic_vector(9 downto 0); --! character 1 bounds
        -- y_lowerbound_ch1 : in std_logic_vector(9 downto 0); --! character 1 bounds
        -- y_upperbound_ch1 : in std_logic_vector(9 downto 0); --! character 1 bounds

        -- x_lowerbound_ch2 : in std_logic_vector(9 downto 0); --! character 2 bounds
        -- x_upperbound_ch2 : in std_logic_vector(9 downto 0); --! character 2 bounds
        -- y_lowerbound_ch2 : in std_logic_vector(9 downto 0); --! character 2 bounds
        -- y_upperbound_ch2 : in std_logic_vector(9 downto 0); --! character 2 bounds
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

    -- type declaration of the digit array
    type digit_array is array (0 to 23) of std_logic_vector(0 to 15);
    -- char 1 constant digit array
    signal char1_digc : digit_array;
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
    signal char1_digctest   : std_logic_vector(15 downto 0);

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

    char1_digc(0)  <= "0000000000000000";
    char1_digc(1)  <= "0111111111111110";
    char1_digc(2)  <= "0111111111111110";
    char1_digc(3)  <= "0111111111111110";
    char1_digc(4)  <= "0111111111111110";
    char1_digc(5)  <= "0111111111111110";
    char1_digc(6)  <= "0111111111111110";
    char1_digc(7)  <= "0111111111111110";
    char1_digc(8)  <= "0111111111111110";
    char1_digc(9)  <= "0111111111111110";
    char1_digc(10) <= "0111111111111110";
    char1_digc(11) <= "0111000000000000";
    char1_digc(12) <= "0111000000000000";
    char1_digc(13) <= "0111000000000000";
    char1_digc(14) <= "0111000000000000";
    char1_digc(15) <= "0111000000000000";
    char1_digc(16) <= "0111000000111100";
    char1_digc(17) <= "0111000000111100";
    char1_digc(18) <= "0111000000111100";
    char1_digc(19) <= "0111000000111100";
    char1_digc(20) <= "0111000000111100";
    char1_digc(21) <= "0111000000111100";
    char1_digc(22) <= "0111000000111100";
    char1_digc(23) <= "0000000000000000";
    char1_digctest <= char1_digc(1);

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
                    R_data <= "1111";
                    G_data <= "1111";
                    B_data <= "1111";

                elsif (uns_hcount > 183 and uns_hcount <= 379) and (uns_vcount > 310 and uns_vcount <= 314) then --platform 1, (10,69) --> (59,70)
                    R_data <= "1111";
                    G_data <= "1111";
                    B_data <= "1111";
                elsif (uns_hcount > 543 and uns_hcount <= 739) and (uns_vcount > 310 and uns_vcount <= 314) then --platform 2, (100,69) --> (149,70)
                    R_data <= "1111";
                    G_data <= "1111";
                    B_data <= "1111";
                elsif (uns_hcount > 363 and uns_hcount <= 559) and (uns_vcount > 178 and uns_vcount <= 182) then --platform 3, (55,36) --> (104,37)
                    R_data <= "1111";
                    G_data <= "1111";
                    B_data <= "1111";
                    --------------------------------------------------------------------------------
                    -- dynamic assignment of pixel colors due to character location
                    --------------------------------------------------------------------------------
                elsif (uns_hcount >= ch1x1 and uns_hcount <= ch1x2) and (uns_vcount >= ch1y1 and uns_vcount <= ch1y2) then --character 1
                    R_data <= "1111";
                    G_data <= "1111";
                    B_data <= "1111";
                    ------------------------------------------------------------------------------------
                elsif (uns_hcount >= ch2x1 and uns_hcount <= ch2x2) and (uns_vcount >= ch2y1 and uns_vcount <= ch2y2) then --character 2
                    R_data <= "1111";
                    G_data <= "1111";
                    B_data <= "1111";

                    --------------------------------------------------------------------------------
                    -- p1 percentage markings
                    --------------------------------------------------------------------------------
                elsif (uns_hcount > 143 and uns_hcount <= 303) and (uns_vcount > 434 and uns_vcount <= 514) then --player 1 data: 143 to 303 horizontal
                    if (uns_hcount > 155 and uns_hcount <= 171) and (uns_vcount > 462 and uns_vcount <= 486) then    --143 to 183 horizontale indeling, margins: 12 left and right & 28 up and bottom

                        if    (char1_digc(0)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 0))) then --line 0
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(1)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 1))) then -- line 1
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(2)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 2))) then --line 2
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(3)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 3))) then -- line 3
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(4)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 4))) then -- line 4
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(5)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 5))) then -- line 5
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(6)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 6))) then -- line 6
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(7)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 6))) then -- line 7
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(8)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 7))) then -- line 8
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(9)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 8))) then -- line 9
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(10)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 9))) then -- line 10
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(11)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 11))) then -- line 11
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(12)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 12))) then -- line 12
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(13)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 13))) then -- line 13
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(14)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 14))) then -- line 14
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(15)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 15))) then -- line 15
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(16)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 16))) then -- line 16
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(17)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 17))) then -- line 17
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(18)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 18))) then -- line 18
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(19)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 19))) then -- line 19
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(20)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 20))) then -- line 20
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(21)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 21))) then -- line 21
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(22)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 22))) then -- line 22
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(23)(0 ) = '1' and ((uns_hcount - 156 = 0 ) and (uns_vcount - 463 = 23))) then -- line 23
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(1 ) = '1' and ((uns_hcount - 156 = 1 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(2 ) = '1' and ((uns_hcount - 156 = 2 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(3 ) = '1' and ((uns_hcount - 156 = 3 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(4 ) = '1' and ((uns_hcount - 156 = 4 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(5 ) = '1' and ((uns_hcount - 156 = 5 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(6 ) = '1' and ((uns_hcount - 156 = 6 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(7 ) = '1' and ((uns_hcount - 156 = 7 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(8 ) = '1' and ((uns_hcount - 156 = 8 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(9 ) = '1' and ((uns_hcount - 156 = 9 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(10) = '1' and ((uns_hcount - 156 = 10) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(11) = '1' and ((uns_hcount - 156 = 11) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(12) = '1' and ((uns_hcount - 156 = 12) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(13) = '1' and ((uns_hcount - 156 = 13) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(14) = '1' and ((uns_hcount - 156 = 14) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(15) = '1' and ((uns_hcount - 156 = 15) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;

                    elsif (uns_hcount > 195 and uns_hcount <= 211) and (uns_vcount > 462 and uns_vcount <= 486) then -- first digit --183 to 223 idem
                        
                        if    (char1_dig1(0 )(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 0))) then --line 0
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(1 )(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 1))) then -- line 1
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(2 )(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 2))) then --line 2
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(3 )(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 3))) then -- line 3
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(4 )(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 4))) then -- line 4
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(5 )(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 5))) then -- line 5
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(6 )(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 6))) then -- line 6
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(7 )(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 6))) then -- line 7
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(8 )(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 7))) then -- line 8
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(9 )(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 8))) then -- line 9
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(10)(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 9))) then -- line 10
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(11)(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 11))) then -- line 11
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(12)(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 12))) then -- line 12
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(13)(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 13))) then -- line 13
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(14)(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 14))) then -- line 14
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(15)(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 15))) then -- line 15
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(16)(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 16))) then -- line 16
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(17)(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 17))) then -- line 17
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(18)(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 18))) then -- line 18
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(19)(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 19))) then -- line 19
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(20)(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 20))) then -- line 20
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(21)(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 21))) then -- line 21
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(22)(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 22))) then -- line 22
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(23)(0 ) = '1' and ((uns_hcount - 196 = 0 ) and (uns_vcount - 463 = 23))) then -- line 23
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(1 ) = '1' and ((uns_hcount - 196 = 1 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(2 ) = '1' and ((uns_hcount - 196 = 2 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(3 ) = '1' and ((uns_hcount - 196 = 3 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(4 ) = '1' and ((uns_hcount - 196 = 4 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(5 ) = '1' and ((uns_hcount - 196 = 5 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(6 ) = '1' and ((uns_hcount - 196 = 6 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(7 ) = '1' and ((uns_hcount - 196 = 7 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(8 ) = '1' and ((uns_hcount - 196 = 8 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(9 ) = '1' and ((uns_hcount - 196 = 9 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(10) = '1' and ((uns_hcount - 196 = 10) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(11) = '1' and ((uns_hcount - 196 = 11) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(12) = '1' and ((uns_hcount - 196 = 12) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(13) = '1' and ((uns_hcount - 196 = 13) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(14) = '1' and ((uns_hcount - 196 = 14) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(15) = '1' and ((uns_hcount - 196 = 15) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                    elsif (uns_hcount > 235 and uns_hcount <= 251) and (uns_vcount > 462 and uns_vcount <= 486) then -- second digit --223 to 263 idem
                        
                        if    (char1_dig2(0 )(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 0))) then --line 0
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(1 )(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 1))) then -- line 1
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(2 )(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 2))) then --line 2
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(3 )(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 3))) then -- line 3
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(4 )(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 4))) then -- line 4
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(5 )(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 5))) then -- line 5
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(6 )(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 6))) then -- line 6
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(7 )(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 6))) then -- line 7
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(8 )(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 7))) then -- line 8
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(9 )(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 8))) then -- line 9
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(10)(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 9))) then -- line 10
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(11)(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 11))) then -- line 11
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(12)(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 12))) then -- line 12
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(13)(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 13))) then -- line 13
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(14)(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 14))) then -- line 14
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(15)(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 15))) then -- line 15
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(16)(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 16))) then -- line 16
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(17)(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 17))) then -- line 17
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(18)(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 18))) then -- line 18
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(19)(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 19))) then -- line 19
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(20)(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 20))) then -- line 20
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(21)(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 21))) then -- line 21
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(22)(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 22))) then -- line 22
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(23)(0 ) = '1' and ((uns_hcount - 236 = 0 ) and (uns_vcount - 463 = 23))) then -- line 23
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(1 ) = '1' and ((uns_hcount - 236 = 1 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(2 ) = '1' and ((uns_hcount - 236 = 2 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(3 ) = '1' and ((uns_hcount - 236 = 3 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(4 ) = '1' and ((uns_hcount - 236 = 4 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(5 ) = '1' and ((uns_hcount - 236 = 5 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(6 ) = '1' and ((uns_hcount - 236 = 6 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(7 ) = '1' and ((uns_hcount - 236 = 7 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(8 ) = '1' and ((uns_hcount - 236 = 8 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(9 ) = '1' and ((uns_hcount - 236 = 9 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(10) = '1' and ((uns_hcount - 236 = 10) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(11) = '1' and ((uns_hcount - 236 = 11) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(12) = '1' and ((uns_hcount - 236 = 12) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(13) = '1' and ((uns_hcount - 236 = 13) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(14) = '1' and ((uns_hcount - 236 = 14) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(15) = '1' and ((uns_hcount - 236 = 15) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                    elsif (uns_hcount > 275 and uns_hcount <= 291) and (uns_vcount > 462 and uns_vcount <= 486) then -- third digit --263 to 303 idem
                        
                        if    (char1_dig3(0 )(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 0))) then --line 0
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(1 )(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 1))) then -- line 1
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(2 )(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 2))) then --line 2
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(3 )(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 3))) then -- line 3
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(4 )(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 4))) then -- line 4
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(5 )(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 5))) then -- line 5
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(6 )(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 6))) then -- line 6
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(7 )(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 6))) then -- line 7
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(8 )(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 7))) then -- line 8
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(9 )(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 8))) then -- line 9
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(10)(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 9))) then -- line 10
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(11)(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 11))) then -- line 11
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(12)(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 12))) then -- line 12
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(13)(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 13))) then -- line 13
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(14)(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 14))) then -- line 14
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(15)(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 15))) then -- line 15
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(16)(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 16))) then -- line 16
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(17)(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 17))) then -- line 17
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(18)(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 18))) then -- line 18
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(19)(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 19))) then -- line 19
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(20)(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 20))) then -- line 20
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(21)(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 21))) then -- line 21
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(22)(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 22))) then -- line 22
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(23)(0 ) = '1' and ((uns_hcount - 276 = 0 ) and (uns_vcount - 463 = 23))) then -- line 23
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(1 ) = '1' and ((uns_hcount - 276 = 1 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(2 ) = '1' and ((uns_hcount - 276 = 2 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(3 ) = '1' and ((uns_hcount - 276 = 3 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(4 ) = '1' and ((uns_hcount - 276 = 4 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(5 ) = '1' and ((uns_hcount - 276 = 5 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(6 ) = '1' and ((uns_hcount - 276 = 6 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(7 ) = '1' and ((uns_hcount - 276 = 7 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(8 ) = '1' and ((uns_hcount - 276 = 8 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(9 ) = '1' and ((uns_hcount - 276 = 9 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(10) = '1' and ((uns_hcount - 276 = 10) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(11) = '1' and ((uns_hcount - 276 = 11) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(12) = '1' and ((uns_hcount - 276 = 12) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(13) = '1' and ((uns_hcount - 276 = 13) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(14) = '1' and ((uns_hcount - 276 = 14) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(15) = '1' and ((uns_hcount - 276 = 15) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                    else -- background "canvas" -> also functions as a fall back
                        R_data <= "0000";
                        G_data <= "0000";
                        B_data <= "0000";
                    end if;

                    --------------------------------------------------------------------------------
                    -- p2 percentage markings [Player 1 data for now, as I wanna see the measurements on the screen]
                    --------------------------------------------------------------------------------
                elsif (uns_hcount > 623 and uns_hcount <= 783) and (uns_vcount > 434 and uns_vcount <= 514) then --player 2 data: 623 to 783
                    if (uns_hcount > 635 and uns_hcount <= 651) and (uns_vcount > 462 and uns_vcount <= 486) then    --623 to 663 horizontale indeling, margins: 12 left and right & 28 up and bottom
                        
                        if    (char1_digc(0 )(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 0))) then --line 0
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(0 )(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(1 )(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 1))) then -- line 1
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(1 )(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(2 )(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 2))) then --line 2
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(2 )(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(3 )(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 3))) then -- line 3
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(3 )(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(4 )(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 4))) then -- line 4
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(4 )(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(5 )(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 5))) then -- line 5
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(5 )(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(6 )(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 6))) then -- line 6
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(6 )(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(7 )(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 6))) then -- line 7
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(7 )(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(8 )(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 7))) then -- line 8
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(8 )(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(9 )(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 8))) then -- line 9
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(9 )(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(10)(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 9))) then -- line 10
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(10)(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(11)(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 11))) then -- line 11
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(11)(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(12)(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 12))) then -- line 12
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(12)(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(13)(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 13))) then -- line 13
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(13)(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(14)(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 14))) then -- line 14
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(14)(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(15)(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 15))) then -- line 15
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(15)(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(16)(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 16))) then -- line 16
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(16)(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(17)(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 17))) then -- line 17
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(17)(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(18)(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 18))) then -- line 18
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(18)(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(19)(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 19))) then -- line 19
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(19)(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(20)(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 20))) then -- line 20
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(20)(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(21)(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 21))) then -- line 21
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(21)(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(22)(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 22))) then -- line 22
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(22)(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_digc(23)(0 ) = '1' and ((uns_hcount - 636 = 0 ) and (uns_vcount - 463 = 23))) then -- line 23
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(1 ) = '1' and ((uns_hcount - 636 = 1 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(2 ) = '1' and ((uns_hcount - 636 = 2 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(3 ) = '1' and ((uns_hcount - 636 = 3 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(4 ) = '1' and ((uns_hcount - 636 = 4 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(5 ) = '1' and ((uns_hcount - 636 = 5 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(6 ) = '1' and ((uns_hcount - 636 = 6 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(7 ) = '1' and ((uns_hcount - 636 = 7 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(8 ) = '1' and ((uns_hcount - 636 = 8 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(9 ) = '1' and ((uns_hcount - 636 = 9 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(10) = '1' and ((uns_hcount - 636 = 10) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(11) = '1' and ((uns_hcount - 636 = 11) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(12) = '1' and ((uns_hcount - 636 = 12) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(13) = '1' and ((uns_hcount - 636 = 13) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(14) = '1' and ((uns_hcount - 636 = 14) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_digc(23)(15) = '1' and ((uns_hcount - 636 = 15) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                    elsif (uns_hcount > 675 and uns_hcount <= 691) and (uns_vcount > 462 and uns_vcount <= 486) then -- first digit -- 663 to 703 idem
                        
                        if    (char1_dig1(0 )(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 0))) then --line 0
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(0 )(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(1 )(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 1))) then -- line 1
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(1 )(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(2 )(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 2))) then --line 2
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(2 )(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(3 )(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 3))) then -- line 3
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(3 )(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(4 )(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 4))) then -- line 4
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(4 )(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(5 )(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 5))) then -- line 5
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(5 )(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(6 )(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 6))) then -- line 6
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(6 )(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(7 )(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 6))) then -- line 7
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(7 )(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(8 )(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 7))) then -- line 8
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(8 )(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(9 )(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 8))) then -- line 9
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(9 )(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(10)(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 9))) then -- line 10
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(10)(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(11)(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 11))) then -- line 11
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(11)(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(12)(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 12))) then -- line 12
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(12)(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(13)(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 13))) then -- line 13
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(13)(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(14)(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 14))) then -- line 14
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(14)(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(15)(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 15))) then -- line 15
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(15)(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(16)(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 16))) then -- line 16
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(16)(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(17)(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 17))) then -- line 17
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(17)(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(18)(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 18))) then -- line 18
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(18)(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(19)(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 19))) then -- line 19
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(19)(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(20)(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 20))) then -- line 20
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(20)(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(21)(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 21))) then -- line 21
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(21)(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(22)(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 22))) then -- line 22
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(22)(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig1(23)(0 ) = '1' and ((uns_hcount - 676 = 0 ) and (uns_vcount - 463 = 23))) then -- line 23
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(1 ) = '1' and ((uns_hcount - 676 = 1 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(2 ) = '1' and ((uns_hcount - 676 = 2 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(3 ) = '1' and ((uns_hcount - 676 = 3 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(4 ) = '1' and ((uns_hcount - 676 = 4 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(5 ) = '1' and ((uns_hcount - 676 = 5 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(6 ) = '1' and ((uns_hcount - 676 = 6 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(7 ) = '1' and ((uns_hcount - 676 = 7 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(8 ) = '1' and ((uns_hcount - 676 = 8 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(9 ) = '1' and ((uns_hcount - 676 = 9 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(10) = '1' and ((uns_hcount - 676 = 10) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(11) = '1' and ((uns_hcount - 676 = 11) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(12) = '1' and ((uns_hcount - 676 = 12) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(13) = '1' and ((uns_hcount - 676 = 13) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(14) = '1' and ((uns_hcount - 676 = 14) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig1(23)(15) = '1' and ((uns_hcount - 676 = 15) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                    elsif (uns_hcount > 715 and uns_hcount <= 731) and (uns_vcount > 462 and uns_vcount <= 486) then -- second digit --703 to 743 idem

                        if    (char1_dig2(0 )(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 0))) then --line 0
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(0 )(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(1 )(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 1))) then -- line 1
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(1 )(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(2 )(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 2))) then --line 2
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(2 )(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(3 )(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 3))) then -- line 3
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(3 )(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(4 )(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 4))) then -- line 4
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(4 )(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(5 )(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 5))) then -- line 5
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(5 )(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(6 )(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 6))) then -- line 6
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(6 )(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(7 )(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 6))) then -- line 7
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(7 )(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(8 )(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 7))) then -- line 8
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(8 )(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(9 )(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 8))) then -- line 9
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(9 )(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(10)(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 9))) then -- line 10
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(10)(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(11)(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 11))) then -- line 11
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(11)(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(12)(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 12))) then -- line 12
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(12)(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(13)(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 13))) then -- line 13
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(13)(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(14)(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 14))) then -- line 14
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(14)(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(15)(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 15))) then -- line 15
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(15)(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(16)(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 16))) then -- line 16
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(16)(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(17)(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 17))) then -- line 17
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(17)(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(18)(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 18))) then -- line 18
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(18)(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(19)(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 19))) then -- line 19
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(19)(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(20)(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 20))) then -- line 20
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(20)(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(21)(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 21))) then -- line 21
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(21)(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(22)(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 22))) then -- line 22
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(22)(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig2(23)(0 ) = '1' and ((uns_hcount - 716 = 0 ) and (uns_vcount - 463 = 23))) then -- line 23
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(1 ) = '1' and ((uns_hcount - 716 = 1 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(2 ) = '1' and ((uns_hcount - 716 = 2 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(3 ) = '1' and ((uns_hcount - 716 = 3 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(4 ) = '1' and ((uns_hcount - 716 = 4 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(5 ) = '1' and ((uns_hcount - 716 = 5 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(6 ) = '1' and ((uns_hcount - 716 = 6 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(7 ) = '1' and ((uns_hcount - 716 = 7 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(8 ) = '1' and ((uns_hcount - 716 = 8 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(9 ) = '1' and ((uns_hcount - 716 = 9 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(10) = '1' and ((uns_hcount - 716 = 10) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(11) = '1' and ((uns_hcount - 716 = 11) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(12) = '1' and ((uns_hcount - 716 = 12) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(13) = '1' and ((uns_hcount - 716 = 13) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(14) = '1' and ((uns_hcount - 716 = 14) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig2(23)(15) = '1' and ((uns_hcount - 716 = 15) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                    elsif (uns_hcount > 755 and uns_hcount <= 771) and (uns_vcount > 462 and uns_vcount <= 486) then -- third digit --743 to 783 idem

                        if    (char1_dig3(0 )(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 0))) then --line 0
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(0 )(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 0))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(1 )(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 1))) then -- line 1
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(1 )(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 1))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(2 )(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 2))) then --line 2
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(2 )(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 2))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(3 )(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 3))) then -- line 3
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(3 )(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 3))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(4 )(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 4))) then -- line 4
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(4 )(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 4))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(5 )(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 5))) then -- line 5
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(5 )(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 5))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(6 )(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 6))) then -- line 6
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(6 )(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(7 )(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 6))) then -- line 7
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(7 )(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 6))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(8 )(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 7))) then -- line 8
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(8 )(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 7))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(9 )(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 8))) then -- line 9
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(9 )(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 8))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(10)(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 9))) then -- line 10
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(10)(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 9))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(11)(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 11))) then -- line 11
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(11)(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 11))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(12)(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 12))) then -- line 12
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(12)(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 12))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(13)(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 13))) then -- line 13
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(13)(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 13))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(14)(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 14))) then -- line 14
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(14)(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 14))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(15)(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 15))) then -- line 15
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(15)(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 15))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(16)(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 16))) then -- line 16
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(16)(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 16))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(17)(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 17))) then -- line 17
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(17)(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 17))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(18)(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 18))) then -- line 18
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(18)(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 18))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(19)(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 19))) then -- line 19
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(19)(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 19))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(20)(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 20))) then -- line 20
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(20)(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 20))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(21)(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 21))) then -- line 21
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(21)(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 21))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(22)(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 22))) then -- line 22
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(22)(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 22))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;
                        if    (char1_dig3(23)(0 ) = '1' and ((uns_hcount - 756 = 0 ) and (uns_vcount - 463 = 23))) then -- line 23
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(1 ) = '1' and ((uns_hcount - 756 = 1 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(2 ) = '1' and ((uns_hcount - 756 = 2 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(3 ) = '1' and ((uns_hcount - 756 = 3 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(4 ) = '1' and ((uns_hcount - 756 = 4 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(5 ) = '1' and ((uns_hcount - 756 = 5 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(6 ) = '1' and ((uns_hcount - 756 = 6 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(7 ) = '1' and ((uns_hcount - 756 = 7 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(8 ) = '1' and ((uns_hcount - 756 = 8 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(9 ) = '1' and ((uns_hcount - 756 = 9 ) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(10) = '1' and ((uns_hcount - 756 = 10) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(11) = '1' and ((uns_hcount - 756 = 11) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(12) = '1' and ((uns_hcount - 756 = 12) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(13) = '1' and ((uns_hcount - 756 = 13) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(14) = '1' and ((uns_hcount - 756 = 14) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";
                        elsif (char1_dig3(23)(15) = '1' and ((uns_hcount - 756 = 15) and (uns_vcount - 463 = 23))) then
                            R_data <= "1111";
                            G_data <= "1111";
                            B_data <= "1111";end if;

                    else -- background "canvas" -> also functions as a fall back
                        R_data <= "0000";
                        G_data <= "0000";
                        B_data <= "0000";
                    end if;
                elsif (uns_hcount > 184 and uns_hcount <= 223) and (uns_vcount > 434 and uns_vcount <= 514) then --percentage box2-4 -> displaying the numbers
                    R_data <= "0000";
                    G_data <= "0000";
                    B_data <= "0000";

                else -- when not on active screen time send low signal
                    R_data <= "0000";
                    G_data <= "0000";
                    B_data <= "0000";
                end if;
            else
                R_data <= "0000";
                G_data <= "0000";
                B_data <= "0000";
            end if;
        end if;
    end process;

end architecture;