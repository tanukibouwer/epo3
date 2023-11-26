--module: dig3_num_splitter
--version: 1.0
--author: Parama Fawwaz
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
--
--
--
--
--
--
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dig3_num_splitter is
    port (
        -- clk       : in std_logic;
        -- reset     : in std_logic;
        num3dig : in std_logic_vector(23 downto 0); 
        num1    : out std_logic_vector(3 downto 0);
        num2    : out std_logic_vector(3 downto 0);
        num3    : out std_logic_vector(3 downto 0);
        
    );
end entity dig3_num_splitter;
architecture behaviour of dig3_num_splitter is
    signal number                                 : unsigned(23 downto 0);


begin
    number <= unsigned(num3dig)

    lbl1 : process (number)
    begin
        if(number = 0) then
        num1 <= "0000"; --0
        num2 <= "0000"; --0
        num3 <= "0000"; --0
        elsif (number = 1) then
        num1 <= "0000"; --0
        num2 <= "0001"; --1
        elsif (number = 2) then
        num1 <= "0000"; --0
        num2 <= "0010"; --2
        elsif (number = 3) then
        num1 <= "0000"; --0
        num2 <= "0011"; --3
        elsif (number = 4) then
        num1 <= "0000"; --0
        num2 <= "0100"; --4
        elsif (number = 5) then
        num1 <= "0000"; --0
        num2 <= "0101"; --5
        elsif (number = 6) then
        num1 <= "0000"; --0
        num2 <= "0110"; --6
        elsif (number = 7) then
        num1 <= "0000"; --0
        num2 <= "0111"; --7
        elsif (number = 8) then
        num1 <= "0000"; --0
        num2 <= "1000"; --8
        elsif (number = 9) then
        num1 <= "0000"; --0
        num2 <= "1001"; --9
        elsif (number = 10) then
        num1 <= "0001"; --1
        num2 <= "0000"; --0
        elsif (number = 11) then
        num1 <= "0001"; --1
        num2 <= "0001"; --1
        elsif (number = 12) then
        num1 <= "0001"; --1
        num2 <= "0010"; --2
        elsif (number = 13) then
        num1 <= "0001"; --1
        num2 <= "0011"; --3
        elsif (number = 14) then
        num1 <= "0001"; --1
        num2 <= "0100"; --4
        elsif (number = 15) then
        num1 <= "0001"; --1
        num2 <= "0101"; --5
        elsif (number = 16) then
        num1 <= "0001"; --1
        num2 <= "0110"; --6
        elsif (number = 17) then
        num1 <= "0001"; --1
        num2 <= "0111"; --7
        elsif (number = 18) then
        num1 <= "0001"; --1
        num2 <= "1000"; --8
        elsif (number = 19) then
        num1 <= "0001"; --1
        num2 <= "1001"; --9
        elsif (number = 20) then
        num1 <= "0010"; --2
        num2 <= "0000"; --0

        elsif (number = 21) then
        num1 <= "0010"; --2
        num2 <= "0001"; --1
        elsif (number = 22) then
        num1 <= "0010"; --2
        num2 <= "0010"; --2
        elsif (number = 23) then
        num1 <= "0010"; --2
        num2 <= "0011"; --3
        elsif (number = 24) then
        num1 <= "0010"; --2
        num2 <= "0100"; --4
        elsif (number = 25) then
        num1 <= "0010"; --2
        num2 <= "0101"; --5
        elsif (number = 26) then
        num1 <= "0010"; --2
        num2 <= "0110"; --6
        elsif (number = 27) then
        num1 <= "0010"; --2
        num2 <= "0111"; --7
        elsif (number = 28) then
        num1 <= "0010"; --2
        num2 <= "1000"; --8
        elsif (number = 29) then
        num1 <= "0010"; --2
        num2 <= "1001"; --9
        elsif (number = 30) then
        num1 <= "0011"; --3
        num2 <= "0000"; --0

        elsif (number = 31) then
        num1 <= "0011"; --3
        num2 <= "0001"; --1
        elsif (number = 32) then
        num1 <= "0011"; --3
        num2 <= "0010"; --2
        elsif (number = 33) then
        num1 <= "0011"; --3
        num2 <= "0011"; --3
        elsif (number = 34) then
        num1 <= "0011"; --3
        num2 <= "0100"; --4
        elsif (number = 35) then
        num1 <= "0011"; --3
        num2 <= "0101"; --5
        elsif (number = 36) then
        num1 <= "0011"; --3
        num2 <= "0110"; --6
        elsif (number = 37) then
        num1 <= "0011"; --3
        num2 <= "0111"; --7
        elsif (number = 38) then
        num1 <= "0011"; --3
        num2 <= "1000"; --8
        elsif (number = 39) then
        num1 <= "0011"; --3
        num2 <= "1001"; --9
        elsif (number = 40) then
        num1 <= "0100"; --4
        num2 <= "0000"; --0
        elsif (number = 41) then
        num1 <= "0100"; --4
        num2 <= "0001"; --1
        elsif (number = 42) then
        num1 <= "0100"; --4
        num2 <= "0010"; --2
        elsif (number = 43) then
        num1 <= "0100"; --4
        num2 <= "0011"; --3
        elsif (number = 44) then
        num1 <= "0100"; --4
        num2 <= "0100"; --4
        elsif (number = 45) then
        num1 <= "0100"; --4
        num2 <= "0101"; --5
        elsif (number = 46) then
        num1 <= "0100"; --4
        num2 <= "0110"; --6
        elsif (number = 47) then
        num1 <= "0100"; --4
        num2 <= "0111"; --7
        elsif (number = 48) then
        num1 <= "0100"; --4
        num2 <= "1000"; --8
        elsif (number = 49) then
        num1 <= "0100"; --4
        num2 <= "1001"; --9
        elsif (number = 50) then
        num1 <= "0101"; --5
        num2 <= "0000"; --0

        elsif (number = 51) then
        num1 <= "0101"; --5
        num2 <= "0001"; --1
        elsif (number = 52) then
        num1 <= "0101"; --5
        num2 <= "0010"; --2
        elsif (number = 53) then
        num1 <= "0101"; --5
        num2 <= "0011"; --3
        elsif (number = 54) then
        num1 <= "0101"; --5
        num2 <= "0100"; --4
        elsif (number = 55) then
        num1 <= "0101"; --5
        num2 <= "0101"; --5
        elsif (number = 56) then
        num1 <= "0101"; --5
        num2 <= "0110"; --6
        elsif (number = 57) then
        num1 <= "0101"; --5
        num2 <= "0111"; --7
        elsif (number = 58) then
        num1 <= "0101"; --5
        num2 <= "1000"; --8
        elsif (number = 59) then
        num1 <= "0101"; --5
        num2 <= "1001"; --9
        elsif (number = 60) then
        num1 <= "0110"; --6
        num2 <= "0000"; --0

        elsif (number = 61) then
        num1 <= "0110"; --6
        num2 <= "0001"; --1
        elsif (number = 62) then
        num1 <= "0110"; --6
        num2 <= "0010"; --2
        elsif (number = 63) then
        num1 <= "0110"; --6
        num2 <= "0011"; --3
        elsif (number = 64) then
        num1 <= "0110"; --6
        num2 <= "0100"; --4
        elsif (number = 65) then
        num1 <= "0110"; --6
        num2 <= "0101"; --5
        elsif (number = 66) then
        num1 <= "0110"; --6
        num2 <= "0110"; --6
        elsif (number = 67) then
        num1 <= "0110"; --6
        num2 <= "0111"; --7
        elsif (number = 68) then
        num1 <= "0110"; --6
        num2 <= "1000"; --8
        elsif (number = 69) then
        num1 <= "0110"; --6
        num2 <= "1001"; --9
        elsif (number = 70) then
        num1 <= "0111"; --7
        num2 <= "0000"; --0

        elsif (number = 71) then
        num1 <= "0111"; --7
        num2 <= "0001"; --1
        elsif (number = 72) then
        num1 <= "0111"; --7
        num2 <= "0010"; --2
        elsif (number = 73) then
        num1 <= "0111"; --7
        num2 <= "0011"; --3
        elsif (number = 74) then
        num1 <= "0111"; --7
        num2 <= "0100"; --4
        elsif (number = 75) then
        num1 <= "0111"; --7
        num2 <= "0101"; --5
        elsif (number = 76) then
        num1 <= "0111"; --7
        num2 <= "0110"; --6
        elsif (number = 77) then
        num1 <= "0111"; --7
        num2 <= "0111"; --7
        elsif (number = 78) then
        num1 <= "0111"; --7
        num2 <= "1000"; --8
        elsif (number = 79) then
        num1 <= "0111"; --7
        num2 <= "1001"; --9
        elsif (number = 80) then
        num1 <= "1000"; --8
        num2 <= "0000"; --0
        elsif (number = 81) then
        num1 <= "1000"; --8
        num2 <= "0001"; --1
        elsif (number = 82) then
        num1 <= "1000"; --8
        num2 <= "0010"; --2
        elsif (number = 83) then
        num1 <= "1000"; --8
        num2 <= "0011"; --3
        elsif (number = 84) then
        num1 <= "1000"; --8
        num2 <= "0100"; --4
        elsif (number = 85) then
        num1 <= "1000"; --8
        num2 <= "0101"; --5
        elsif (number = 86) then
        num1 <= "1000"; --8
        num2 <= "0110"; --6
        elsif (number = 87) then
        num1 <= "1000"; --8
        num2 <= "0111"; --7
        elsif (number = 88) then
        num1 <= "1000"; --8
        num2 <= "1000"; --8
        elsif (number = 89) then
        num1 <= "1000"; --8
        num2 <= "1001"; --9
        elsif (number = 90) then
        num1 <= "1001"; --9
        num2 <= "0000"; --0

        elsif (number = 91) then
        num1 <= "1001"; --9
        num2 <= "0001"; --1
        elsif (number = 92) then
        num1 <= "1001"; --9
        num2 <= "0010"; --2
        elsif (number = 93) then
        num1 <= "1001"; --9
        num2 <= "0011"; --3
        elsif (number = 94) then
        num1 <= "1001"; --9
        num2 <= "0100"; --4
        elsif (number = 95) then
        num1 <= "1001"; --9
        num2 <= "0101"; --5
        elsif (number = 96) then
        num1 <= "1001"; --9
        num2 <= "0110"; --6
        elsif (number = 97) then
        num1 <= "1001"; --9
        num2 <= "0111"; --7
        elsif (number = 98) then
        num1 <= "1001"; --9
        num2 <= "1000"; --8
        else
        num1 <= "1001"; --9
        num2 <= "1001"; --9
    end if;
end process;

end architecture;


