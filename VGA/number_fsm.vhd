--module: number_sprite
--version: a2.0
--author: Parama Fawwaz & Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
--! This module is the static ROM for the sprites regarding the numbers that can be shown on screen
--! 
--! The resolution of the sprites is 9 x 20 which will be scaled up by 4 on the actual screen. 
--! This will be done by the coloring module
--! 
--! 
--! 
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity number_sprite is
    port (
        -- clk         : in std_logic;
        number : in std_logic_vector(3 downto 0); -- 9 (max is 1001 in binary)

        line1  : out std_logic_vector(8 downto 0);
        line2  : out std_logic_vector(8 downto 0);
        line3  : out std_logic_vector(8 downto 0);
        line4  : out std_logic_vector(8 downto 0);
        line5  : out std_logic_vector(8 downto 0);
        line6  : out std_logic_vector(8 downto 0);
        line7  : out std_logic_vector(8 downto 0);
        line8  : out std_logic_vector(8 downto 0);
        line9  : out std_logic_vector(8 downto 0);
        line10 : out std_logic_vector(8 downto 0);
        line11 : out std_logic_vector(8 downto 0);
        line12 : out std_logic_vector(8 downto 0);
        line13 : out std_logic_vector(8 downto 0);
        line14 : out std_logic_vector(8 downto 0);
        line15 : out std_logic_vector(8 downto 0);
        line16 : out std_logic_vector(8 downto 0);
        line17 : out std_logic_vector(8 downto 0);
        line18 : out std_logic_vector(8 downto 0);
        line19 : out std_logic_vector(8 downto 0);
        line20 : out std_logic_vector(8 downto 0)

    );
end number_sprite;

architecture behavioural of number_sprite is
begin
    process (number) --inverted colored numbers! 
    begin

        case number is
            when "0000" => -- zero
                line1  <= "000000000";
                line2  <= "011111110";
                line3  <= "010000110";
                line4  <= "010000110";
                line5  <= "010000110";
                line6  <= "010001010";
                line7  <= "010001010";
                line8  <= "010001010";
                line9  <= "010010010";
                line10 <= "010010010";
                line11 <= "010010010";
                line12 <= "010010010";
                line13 <= "010100010";
                line14 <= "010100010";
                line15 <= "010100010";
                line16 <= "011000010";
                line17 <= "011000010";
                line18 <= "011000010";
                line19 <= "011111110";
                line20 <= "000000000";
            when "0001" => -- one
                line1  <= "000000000";
                line2  <= "000000110";
                line3  <= "000011110";
                line4  <= "011111110";
                line5  <= "011111110";
                line6  <= "000000110";
                line7  <= "000000110";
                line8  <= "000000110";
                line9  <= "000000110";
                line10 <= "000000110";
                line11 <= "000000110";
                line12 <= "000000110";
                line13 <= "000000110";
                line14 <= "000000110";
                line15 <= "000000110";
                line16 <= "000000110";
                line17 <= "000000110";
                line18 <= "000000110";
                line19 <= "000000110";
                line20 <= "000000000";
            when "0010" => -- two
                line1  <= "000000000";
                line2  <= "011111110";
                line3  <= "011111110";
                line4  <= "000000110";
                line5  <= "000000110";
                line6  <= "000000110";
                line7  <= "000000110";
                line8  <= "000000110";
                line9  <= "000000110";
                line10 <= "011111110";
                line11 <= "011111110";
                line12 <= "011000000";
                line13 <= "011000000";
                line14 <= "011000000";
                line15 <= "011000000";
                line16 <= "011000000";
                line17 <= "011000000";
                line18 <= "011111110";
                line19 <= "011111110";
                line20 <= "000000000";
            when "0011" => -- three
                line1  <= "000000000";
                line2  <= "011111110";
                line3  <= "011111110";
                line4  <= "000000110";
                line5  <= "000000110";
                line6  <= "000000110";
                line7  <= "000000110";
                line8  <= "000000110";
                line9  <= "000000110";
                line10 <= "011111110";
                line11 <= "011111110";
                line12 <= "000000110";
                line13 <= "000000110";
                line14 <= "000000110";
                line15 <= "000000110";
                line16 <= "000000110";
                line17 <= "000000110";
                line18 <= "011111110";
                line19 <= "011111110";
                line20 <= "000000000";
            when "0100" => -- four
                line1  <= "000000000";
                line2  <= "011000110";
                line3  <= "011000110";
                line4  <= "011000110";
                line5  <= "011000110";
                line6  <= "011000110";
                line7  <= "011000110";
                line8  <= "011000110";
                line9  <= "011000110";
                line10 <= "011111110";
                line11 <= "011111110";
                line12 <= "000000110";
                line13 <= "000000110";
                line14 <= "000000110";
                line15 <= "000000110";
                line16 <= "000000110";
                line17 <= "000000110";
                line18 <= "000000110";
                line19 <= "000000110";
                line20 <= "000000000";
            when "0101" => -- five
                line1  <= "000000000";
                line2  <= "011111110";
                line3  <= "011111110";
                line4  <= "011000000";
                line5  <= "011000000";
                line6  <= "011000000";
                line7  <= "011000000";
                line8  <= "011000000";
                line9  <= "011000000";
                line10 <= "011111110";
                line11 <= "011111110";
                line12 <= "000000110";
                line13 <= "000000110";
                line14 <= "000000110";
                line15 <= "000000110";
                line16 <= "000000110";
                line17 <= "000000110";
                line18 <= "011111110";
                line19 <= "011111110";
                line20 <= "000000000";
            when "0110" => -- six
                line1  <= "000000000";
                line2  <= "011111110";
                line3  <= "011111110";
                line4  <= "000000110";
                line5  <= "000000110";
                line6  <= "000000110";
                line7  <= "000000110";
                line8  <= "000000110";
                line9  <= "000000110";
                line10 <= "011111110";
                line11 <= "011111110";
                line12 <= "011000110";
                line13 <= "011000110";
                line14 <= "011000110";
                line15 <= "011000110";
                line16 <= "011000110";
                line17 <= "011000110";
                line18 <= "011111110";
                line19 <= "011111110";
                line20 <= "000000000";
            when "0111" => -- seven
                line1  <= "000000000";
                line2  <= "011111110";
                line3  <= "011111110";
                line4  <= "000000110";
                line5  <= "000000110";
                line6  <= "000000110";
                line7  <= "000000110";
                line8  <= "000000110";
                line9  <= "000011110";
                line10 <= "000011110";
                line11 <= "000000110";
                line12 <= "000000110";
                line13 <= "000000110";
                line14 <= "000000110";
                line15 <= "000000110";
                line16 <= "000000110";
                line17 <= "000000110";
                line18 <= "000000110";
                line19 <= "000000110";
                line20 <= "000000000";
            when "1000" => -- eight
                line1  <= "000000000";
                line2  <= "011111110";
                line3  <= "011111110";
                line4  <= "011000110";
                line5  <= "011000110";
                line6  <= "011000110";
                line7  <= "011000110";
                line8  <= "011000110";
                line9  <= "011000110";
                line10 <= "011111110";
                line11 <= "011111110";
                line12 <= "011000110";
                line13 <= "011000110";
                line14 <= "011000110";
                line15 <= "011000110";
                line16 <= "011000110";
                line17 <= "011000110";
                line18 <= "011111110";
                line19 <= "011111110";
                line20 <= "000000000";
            when "1001" => -- nine
                line1  <= "000000000";
                line2  <= "011111110";
                line3  <= "011111110";
                line4  <= "011000110";
                line5  <= "011000110";
                line6  <= "011000110";
                line7  <= "011000110";
                line8  <= "011000110";
                line9  <= "011000110";
                line10 <= "011111110";
                line11 <= "011111110";
                line12 <= "000000110";
                line13 <= "000000110";
                line14 <= "000000110";
                line15 <= "000000110";
                line16 <= "000000110";
                line17 <= "000000110";
                line18 <= "011111110";
                line19 <= "011111110";
                line20 <= "000000000";
            when others =>
                null;
        end case;

    end process;

end behavioural;