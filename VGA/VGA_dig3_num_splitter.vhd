--module: dig3_num_splitter
--version: 1.0
--author: Parama Fawwaz
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
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
        num3dig : in std_logic_vector(7 downto 0);
        num1    : out std_logic_vector(3 downto 0);
        num2    : out std_logic_vector(3 downto 0);
        num3    : out std_logic_vector(3 downto 0)

    );
end entity dig3_num_splitter;
architecture behavioural of dig3_num_splitter is
    signal number : unsigned(7 downto 0);
begin
    number <= unsigned(num3dig);

    lbl1 : process (number)
    begin
        if (number = 0) then
            num1 <= "0000"; --0
            num2 <= "0000"; --0
            num3 <= "0000"; --0
        elsif (number = 1) then
            num1 <= "0000"; --0
            num2 <= "0000"; --0
            num3 <= "0001"; --1
        elsif (number = 2) then
            num1 <= "0000"; --0
            num2 <= "0000"; --0
            num3 <= "0010"; --2
        elsif (number = 3) then
            num1 <= "0000"; --0
            num2 <= "0000"; --0
            num3 <= "0011"; --3
        elsif (number = 4) then
            num1 <= "0000"; --0
            num2 <= "0000"; --0
            num3 <= "0100"; --4
        elsif (number = 5) then
            num1 <= "0000"; --0
            num2 <= "0000"; --0
            num3 <= "0101"; --5
        elsif (number = 6) then
            num1 <= "0000"; --0
            num2 <= "0000"; --0
            num3 <= "0110"; --6
        elsif (number = 7) then
            num1 <= "0000"; --0
            num2 <= "0000"; --0
            num3 <= "0111"; --7
        elsif (number = 8) then
            num1 <= "0000"; --0
            num2 <= "0000"; --0
            num3 <= "1000"; --8
        elsif (number = 9) then
            num1 <= "0000"; --0
            num2 <= "0000"; --0
            num3 <= "1001"; --9
        elsif (number = 10) then
            num1 <= "0000"; --0
            num2 <= "0001"; --1
            num3 <= "0000"; --0
        elsif (number = 11) then
            num1 <= "0000"; --0
            num2 <= "0001"; --1
            num3 <= "0001"; --1
        elsif (number = 12) then
            num1 <= "0000"; --0
            num2 <= "0001"; --1
            num3 <= "0010"; --2
        elsif (number = 13) then
            num1 <= "0000"; --0
            num2 <= "0001"; --1
            num3 <= "0011"; --3
        elsif (number = 14) then
            num1 <= "0000"; --0
            num2 <= "0001"; --1
            num3 <= "0100"; --4
        elsif (number = 15) then
            num1 <= "0000"; --0
            num2 <= "0001"; --1
            num3 <= "0101"; --5
        elsif (number = 16) then
            num1 <= "0000"; --0
            num2 <= "0001"; --1
            num3 <= "0110"; --6
        elsif (number = 17) then
            num1 <= "0000"; --0
            num2 <= "0001"; --1
            num3 <= "0111"; --7
        elsif (number = 18) then
            num1 <= "0000"; --0
            num2 <= "0001"; --1
            num3 <= "1000"; --8
        elsif (number = 19) then
            num1 <= "0000"; --0
            num2 <= "0001"; --1
            num3 <= "1001"; --9
        elsif (number = 20) then
            num1 <= "0000"; --0
            num2 <= "0010"; --2
            num3 <= "0000"; --0

        elsif (number = 21) then
            num1 <= "0000"; --0
            num2 <= "0010"; --2
            num3 <= "0001"; --1
        elsif (number = 22) then
            num1 <= "0000"; --0
            num2 <= "0010"; --2
            num3 <= "0010"; --2
        elsif (number = 23) then
            num1 <= "0000"; --0
            num2 <= "0010"; --2
            num3 <= "0011"; --3
        elsif (number = 24) then
            num1 <= "0000"; --0
            num2 <= "0010"; --2
            num3 <= "0100"; --4
        elsif (number = 25) then
            num1 <= "0000"; --0
            num2 <= "0010"; --2
            num3 <= "0101"; --5
        elsif (number = 26) then
            num1 <= "0000"; --0
            num2 <= "0010"; --2
            num3 <= "0110"; --6
        elsif (number = 27) then
            num1 <= "0000"; --0
            num2 <= "0010"; --2
            num3 <= "0111"; --7
        elsif (number = 28) then
            num1 <= "0000"; --0
            num2 <= "0010"; --2
            num3 <= "1000"; --8
        elsif (number = 29) then
            num1 <= "0000"; --0
            num2 <= "0010"; --2
            num3 <= "1001"; --9
        elsif (number = 30) then
            num1 <= "0000"; --0
            num2 <= "0011"; --3
            num3 <= "0000"; --0

        elsif (number = 31) then
            num1 <= "0000"; --0
            num2 <= "0011"; --3
            num3 <= "0001"; --1
        elsif (number = 32) then
            num1 <= "0000"; --0
            num2 <= "0011"; --3
            num3 <= "0010"; --2
        elsif (number = 33) then
            num1 <= "0000"; --0
            num2 <= "0011"; --3
            num3 <= "0011"; --3
        elsif (number = 34) then
            num1 <= "0000"; --0
            num2 <= "0011"; --3
            num3 <= "0100"; --4
        elsif (number = 35) then
            num1 <= "0000"; --0
            num2 <= "0011"; --3
            num3 <= "0101"; --5
        elsif (number = 36) then
            num1 <= "0000"; --0
            num2 <= "0011"; --3
            num3 <= "0110"; --6
        elsif (number = 37) then
            num1 <= "0000"; --0
            num2 <= "0011"; --3
            num3 <= "0111"; --7
        elsif (number = 38) then
            num1 <= "0000"; --0
            num2 <= "0011"; --3
            num3 <= "1000"; --8
        elsif (number = 39) then
            num1 <= "0000"; --0
            num2 <= "0011"; --3
            num3 <= "1001"; --9
        elsif (number = 40) then
            num1 <= "0000"; --0
            num2 <= "0100"; --4
            num3 <= "0000"; --0
        elsif (number = 41) then
            num1 <= "0000"; --0
            num2 <= "0100"; --4
            num3 <= "0001"; --1
        elsif (number = 42) then
            num1 <= "0000"; --0
            num2 <= "0100"; --4
            num3 <= "0010"; --2
        elsif (number = 43) then
            num1 <= "0000"; --0
            num2 <= "0100"; --4
            num3 <= "0011"; --3
        elsif (number = 44) then
            num1 <= "0000"; --0
            num2 <= "0100"; --4
            num3 <= "0100"; --4
        elsif (number = 45) then
            num1 <= "0000"; --0
            num2 <= "0100"; --4
            num3 <= "0101"; --5
        elsif (number = 46) then
            num1 <= "0000"; --0
            num2 <= "0100"; --4
            num3 <= "0110"; --6
        elsif (number = 47) then
            num1 <= "0000"; --0
            num2 <= "0100"; --4
            num3 <= "0111"; --7
        elsif (number = 48) then
            num1 <= "0000"; --0
            num2 <= "0100"; --4
            num3 <= "1000"; --8
        elsif (number = 49) then
            num1 <= "0000"; --0
            num2 <= "0100"; --4
            num3 <= "1001"; --9
        elsif (number = 50) then
            num1 <= "0000"; --0
            num2 <= "0101"; --5
            num3 <= "0000"; --0

        elsif (number = 51) then
            num1 <= "0000"; --0
            num2 <= "0101"; --5
            num3 <= "0001"; --1
        elsif (number = 52) then
            num1 <= "0000"; --0
            num2 <= "0101"; --5
            num3 <= "0010"; --2
        elsif (number = 53) then
            num1 <= "0000"; --0
            num2 <= "0101"; --5
            num3 <= "0011"; --3
        elsif (number = 54) then
            num1 <= "0000"; --0
            num2 <= "0101"; --5
            num3 <= "0100"; --4
        elsif (number = 55) then
            num1 <= "0000"; --0
            num2 <= "0101"; --5
            num3 <= "0101"; --5
        elsif (number = 56) then
            num1 <= "0000"; --0
            num2 <= "0101"; --5
            num3 <= "0110"; --6
        elsif (number = 57) then
            num1 <= "0000"; --0
            num2 <= "0101"; --5
            num3 <= "0111"; --7
        elsif (number = 58) then
            num1 <= "0000"; --0
            num2 <= "0101"; --5
            num3 <= "1000"; --8
        elsif (number = 59) then
            num1 <= "0000"; --0
            num2 <= "0101"; --5
            num3 <= "1001"; --9
        elsif (number = 60) then
            num1 <= "0000"; --0
            num2 <= "0110"; --6
            num3 <= "0000"; --0

        elsif (number = 61) then
            num1 <= "0000"; --0
            num2 <= "0110"; --6
            num3 <= "0001"; --1
        elsif (number = 62) then
            num1 <= "0000"; --0
            num2 <= "0110"; --6
            num3 <= "0010"; --2
        elsif (number = 63) then
            num1 <= "0000"; --0
            num2 <= "0110"; --6
            num3 <= "0011"; --3
        elsif (number = 64) then
            num1 <= "0000"; --0
            num2 <= "0110"; --6
            num3 <= "0100"; --4
        elsif (number = 65) then
            num1 <= "0000"; --0
            num2 <= "0110"; --6
            num3 <= "0101"; --5
        elsif (number = 66) then
            num1 <= "0000"; --0
            num2 <= "0110"; --6
            num3 <= "0110"; --6
        elsif (number = 67) then
            num1 <= "0000"; --0
            num2 <= "0110"; --6
            num3 <= "0111"; --7
        elsif (number = 68) then
            num1 <= "0000"; --0
            num2 <= "0110"; --6
            num3 <= "1000"; --8
        elsif (number = 69) then
            num1 <= "0000"; --0
            num2 <= "0110"; --6
            num3 <= "1001"; --9
        elsif (number = 70) then
            num1 <= "0000"; --0
            num2 <= "0111"; --7
            num3 <= "0000"; --0

        elsif (number = 71) then
            num1 <= "0000"; --0
            num2 <= "0111"; --7
            num3 <= "0001"; --1
        elsif (number = 72) then
            num1 <= "0000"; --0
            num2 <= "0111"; --7
            num3 <= "0010"; --2
        elsif (number = 73) then
            num1 <= "0000"; --0
            num2 <= "0111"; --7
            num3 <= "0011"; --3
        elsif (number = 74) then
            num1 <= "0000"; --0
            num2 <= "0111"; --7
            num3 <= "0100"; --4
        elsif (number = 75) then
            num1 <= "0000"; --0
            num2 <= "0111"; --7
            num3 <= "0101"; --5
        elsif (number = 76) then
            num1 <= "0000"; --0
            num2 <= "0111"; --7
            num3 <= "0110"; --6
        elsif (number = 77) then
            num1 <= "0000"; --0
            num2 <= "0111"; --7
            num3 <= "0111"; --7
        elsif (number = 78) then
            num1 <= "0000"; --0
            num2 <= "0111"; --7
            num3 <= "1000"; --8
        elsif (number = 79) then
            num1 <= "0000"; --0
            num2 <= "0111"; --7
            num3 <= "1001"; --9
        elsif (number = 80) then
            num1 <= "0000"; --0
            num2 <= "1000"; --8
            num3 <= "0000"; --0
        elsif (number = 81) then
            num1 <= "0000"; --0
            num2 <= "1000"; --8
            num3 <= "0001"; --1
        elsif (number = 82) then
            num1 <= "0000"; --0
            num2 <= "1000"; --8
            num3 <= "0010"; --2
        elsif (number = 83) then
            num1 <= "0000"; --0
            num2 <= "1000"; --8
            num3 <= "0011"; --3
        elsif (number = 84) then
            num1 <= "0000"; --0
            num2 <= "1000"; --8
            num3 <= "0100"; --4
        elsif (number = 85) then
            num1 <= "0000"; --0
            num2 <= "1000"; --8
            num3 <= "0101"; --5
        elsif (number = 86) then
            num1 <= "0000"; --0
            num2 <= "1000"; --8
            num3 <= "0110"; --6
        elsif (number = 87) then
            num1 <= "0000"; --0
            num2 <= "1000"; --8
            num3 <= "0111"; --7
        elsif (number = 88) then
            num1 <= "0000"; --0
            num2 <= "1000"; --8
            num3 <= "1000"; --8
        elsif (number = 89) then
            num1 <= "0000"; --0
            num2 <= "1000"; --8
            num3 <= "1001"; --9
        elsif (number = 90) then
            num1 <= "0000"; --0
            num2 <= "1001"; --9
            num3 <= "0000"; --0

        elsif (number = 91) then
            num1 <= "0000"; --0
            num2 <= "1001"; --9
            num3 <= "0001"; --1
        elsif (number = 92) then
            num1 <= "0000"; --0
            num2 <= "1001"; --9
            num3 <= "0010"; --2
        elsif (number = 93) then
            num1 <= "0000"; --0
            num2 <= "1001"; --9
            num3 <= "0011"; --3
        elsif (number = 94) then
            num1 <= "0000"; --0
            num2 <= "1001"; --9
            num3 <= "0100"; --4
        elsif (number = 95) then
            num1 <= "0000"; --0
            num2 <= "1001"; --9
            num3 <= "0101"; --5
        elsif (number = 96) then
            num1 <= "0000"; --0
            num2 <= "1001"; --9
            num3 <= "0110"; --6
        elsif (number = 97) then
            num1 <= "0000"; --0
            num2 <= "1001"; --9
            num3 <= "0111"; --7
        elsif (number = 98) then
            num1 <= "0000"; --0
            num2 <= "1001"; --9
            num3 <= "1000"; --8
        elsif (number = 99) then
            num1 <= "0000"; --0
            num2 <= "1001"; --9
            num3 <= "1001"; --9
        elsif (number = 100) then
            num1 <= "0001";
            num2 <= "0000";
            num3 <= "0000";

        elsif (number = 101) then
            num1 <= "0001";
            num2 <= "0000";
            num3 <= "0001";
        elsif (number = 102) then
            num1 <= "0001";
            num2 <= "0000";
            num3 <= "0010";
        elsif (number = 103) then
            num1 <= "0001";
            num2 <= "0000";
            num3 <= "0011";
        elsif (number = 104) then
            num1 <= "0001";
            num2 <= "0001";
            num3 <= "0100";
        elsif (number = 105) then
            num1 <= "0001";
            num2 <= "0000";
            num3 <= "0101";
        elsif (number = 106) then
            num1 <= "0001";
            num2 <= "0000";
            num3 <= "0110";
        elsif (number = 107) then
            num1 <= "0001";
            num2 <= "0000";
            num3 <= "0111";
        elsif (number = 108) then
            num1 <= "0001";
            num2 <= "0000";
            num3 <= "1000";

        elsif (number = 109) then
            num1 <= "0001";
            num2 <= "0000";
            num3 <= "1001";

        elsif (number = 110) then
            num1 <= "0001";
            num2 <= "0001";
            num3 <= "0000";

        elsif (number = 111) then
            num1 <= "0001";
            num2 <= "0001";
            num3 <= "0001";

        elsif (number = 112) then
            num1 <= "0001";
            num2 <= "0001";
            num3 <= "0010";
        elsif (number = 113) then
            num1 <= "0001";
            num2 <= "0001";
            num3 <= "0011";
        elsif (number = 114) then
            num1 <= "0001";
            num2 <= "0001";
            num3 <= "0100";
        elsif (number = 115) then
            num1 <= "0001";
            num2 <= "0001";
            num3 <= "0101";
        elsif (number = 116) then
            num1 <= "0001";
            num2 <= "0001";
            num3 <= "0110";
        elsif (number = 117) then
            num1 <= "0001";
            num2 <= "0001";
            num3 <= "0111";
        elsif (number = 118) then
            num1 <= "0001";
            num2 <= "0001";
            num3 <= "1000";
        elsif (number = 119) then
            num1 <= "0001";
            num2 <= "0001";
            num3 <= "1001";

        elsif (number = 120) then
            num1 <= "0001";
            num2 <= "0010";
            num3 <= "0000";

        elsif (number = 121) then
            num1 <= "0001";
            num2 <= "0010";
            num3 <= "0001";

        elsif (number = 122) then
            num1 <= "0001";
            num2 <= "0010";
            num3 <= "0010";
        elsif (number = 123) then
            num1 <= "0001";
            num2 <= "0010";
            num3 <= "0011";
        elsif (number = 124) then
            num1 <= "0001";
            num2 <= "0010";
            num3 <= "0100";
        elsif (number = 125) then
            num1 <= "0001";
            num2 <= "0010";
            num3 <= "0101";
        elsif (number = 126) then
            num1 <= "0001";
            num2 <= "0010";
            num3 <= "0110";
        elsif (number = 127) then
            num1 <= "0001";
            num2 <= "0010";
            num3 <= "0111";
        elsif (number = 128) then
            num1 <= "0001";
            num2 <= "0010";
            num3 <= "1000";

        elsif (number = 129) then
            num1 <= "0001";
            num2 <= "0010";
            num3 <= "1001";

        elsif (number = 130) then
            num1 <= "0001";
            num2 <= "0011";
            num3 <= "0000";

        elsif (number = 131) then
            num1 <= "0001";
            num2 <= "0011";
            num3 <= "0001";

        elsif (number = 132) then
            num1 <= "0001";
            num2 <= "0011";
            num3 <= "0010";
        elsif (number = 133) then
            num1 <= "0001";
            num2 <= "0011";
            num3 <= "0011";
        elsif (number = 134) then
            num1 <= "0001";
            num2 <= "0011";
            num3 <= "0100";
        elsif (number = 135) then
            num1 <= "0001";
            num2 <= "0011";
            num3 <= "0101";
        elsif (number = 136) then
            num1 <= "0001";
            num2 <= "0011";
            num3 <= "0110";
        elsif (number = 137) then
            num1 <= "0001";
            num2 <= "0011";
            num3 <= "0111";
        elsif (number = 138) then
            num1 <= "0001";
            num2 <= "0011";
            num3 <= "1000";
        elsif (number = 139) then
            num1 <= "0001";
            num2 <= "0011";
            num3 <= "1001";

        elsif (number = 140) then
            num1 <= "0001";
            num2 <= "0100";
            num3 <= "0000";

        elsif (number = 141) then
            num1 <= "0001";
            num2 <= "0100";
            num3 <= "0001";
        elsif (number = 142) then
            num1 <= "0001";
            num2 <= "0100";
            num3 <= "0010";
        elsif (number = 143) then
            num1 <= "0001";
            num2 <= "0100";
            num3 <= "0011";
        elsif (number = 144) then
            num1 <= "0001";
            num2 <= "0100";
            num3 <= "0100";
        elsif (number = 145) then
            num1 <= "0001";
            num2 <= "0100";
            num3 <= "0101";
        elsif (number = 146) then
            num1 <= "0001";
            num2 <= "0100";
            num3 <= "0110";
        elsif (number = 147) then
            num1 <= "0001";
            num2 <= "0100";
            num3 <= "0111";
        elsif (number = 148) then
            num1 <= "0001";
            num2 <= "0100";
            num3 <= "1000";

        elsif (number = 149) then
            num1 <= "0001";
            num2 <= "0100";
            num3 <= "1001";

        elsif (number = 150) then
            num1 <= "0001";
            num2 <= "0101";
            num3 <= "0000";

        elsif (number = 151) then
            num1 <= "0001";
            num2 <= "0101";
            num3 <= "0001";

        elsif (number = 152) then
            num1 <= "0001";
            num2 <= "0101";
            num3 <= "0010";
        elsif (number = 153) then
            num1 <= "0001";
            num2 <= "0101";
            num3 <= "0011";
        elsif (number = 154) then
            num1 <= "0001";
            num2 <= "0101";
            num3 <= "0100";
        elsif (number = 155) then
            num1 <= "0001";
            num2 <= "0101";
            num3 <= "0101";
        elsif (number = 156) then
            num1 <= "0001";
            num2 <= "0101";
            num3 <= "0110";
        elsif (number = 157) then
            num1 <= "0001";
            num2 <= "0101";
            num3 <= "0111";
        elsif (number = 158) then
            num1 <= "0001";
            num2 <= "0101";
            num3 <= "1000";
        elsif (number = 159) then
            num1 <= "0001";
            num2 <= "0101";
            num3 <= "1001";

        elsif (number = 160) then
            num1 <= "0001";
            num2 <= "0110";
            num3 <= "0000";

        elsif (number = 161) then
            num1 <= "0001";
            num2 <= "0110";
            num3 <= "0001";

        elsif (number = 162) then
            num1 <= "0001";
            num2 <= "0110";
            num3 <= "0010";
        elsif (number = 163) then
            num1 <= "0001";
            num2 <= "0110";
            num3 <= "0011";
        elsif (number = 164) then
            num1 <= "0000";
            num2 <= "0110";
            num3 <= "0100";
        elsif (number = 165) then
            num1 <= "0001";
            num2 <= "0110";
            num3 <= "0101";
        elsif (number = 166) then
            num1 <= "0001";
            num2 <= "0110";
            num3 <= "0110";
        elsif (number = 167) then
            num1 <= "0001";
            num2 <= "0110";
            num3 <= "0111";
        elsif (number = 168) then
            num1 <= "0001";
            num2 <= "0110";
            num3 <= "1000";

        elsif (number = 169) then
            num1 <= "0001";
            num2 <= "0110";
            num3 <= "1001";

        elsif (number = 170) then
            num1 <= "0001";
            num2 <= "0111";
            num3 <= "0000";

        elsif (number = 171) then
            num1 <= "0001";
            num2 <= "0111";
            num3 <= "0001";

        elsif (number = 172) then
            num1 <= "0001";
            num2 <= "0111";
            num3 <= "0010";
        elsif (number = 173) then
            num1 <= "0001";
            num2 <= "0111";
            num3 <= "0011";
        elsif (number = 174) then
            num1 <= "0001";
            num2 <= "0111";
            num3 <= "0100";
        elsif (number = 175) then
            num1 <= "0001";
            num2 <= "0111";
            num3 <= "0101";
        elsif (number = 176) then
            num1 <= "0001";
            num2 <= "0111";
            num3 <= "0110";
        elsif (number = 177) then
            num1 <= "0001";
            num2 <= "0111";
            num3 <= "0111";
        elsif (number = 178) then
            num1 <= "0001";
            num2 <= "0111";
            num3 <= "1000";
        elsif (number = 179) then
            num1 <= "0001";
            num2 <= "0111";
            num3 <= "1001";

        elsif (number = 180) then
            num1 <= "0001";
            num2 <= "1000";
            num3 <= "0000";

        elsif (number = 181) then
            num1 <= "0001";
            num2 <= "1000";
            num3 <= "0001";
        elsif (number = 182) then
            num1 <= "0001";
            num2 <= "1000";
            num3 <= "0010";
        elsif (number = 183) then
            num1 <= "0001";
            num2 <= "1000";
            num3 <= "0011";
        elsif (number = 184) then
            num1 <= "0001";
            num2 <= "1000";
            num3 <= "0100";
        elsif (number = 185) then
            num1 <= "0001";
            num2 <= "1000";
            num3 <= "0101";
        elsif (number = 186) then
            num1 <= "0001";
            num2 <= "1000";
            num3 <= "0110";
        elsif (number = 187) then
            num1 <= "0001";
            num2 <= "1000";
            num3 <= "0111";
        elsif (number = 188) then
            num1 <= "0001";
            num2 <= "1000";
            num3 <= "1000";

        elsif (number = 189) then
            num1 <= "0001";
            num2 <= "1000";
            num3 <= "1001";

        elsif (number = 190) then
            num1 <= "0001";
            num2 <= "1001";
            num3 <= "0000";

        elsif (number = 191) then
            num1 <= "0001";
            num2 <= "1001";
            num3 <= "0001";

        elsif (number = 192) then
            num1 <= "0001";
            num2 <= "1001";
            num3 <= "0010";
        elsif (number = 193) then
            num1 <= "0001";
            num2 <= "1001";
            num3 <= "0011";
        elsif (number = 194) then
            num1 <= "0001";
            num2 <= "1001";
            num3 <= "0100";
        elsif (number = 195) then
            num1 <= "0001";
            num2 <= "1001";
            num3 <= "0101";
        elsif (number = 196) then
            num1 <= "0001";
            num2 <= "1001";
            num3 <= "0110";
        elsif (number = 197) then
            num1 <= "0001";
            num2 <= "1001";
            num3 <= "0111";
        elsif (number = 198) then
            num1 <= "0001";
            num2 <= "1001";
            num3 <= "1000";
        elsif (number = 199) then
            num1 <= "0001";
            num2 <= "1001";
            num3 <= "1001";

        elsif (number = 200) then
            num1 <= "0010";
            num2 <= "0000";
            num3 <= "0000";

        elsif (number = 201) then
            num1 <= "0010";
            num2 <= "0000";
            num3 <= "0001";

        elsif (number = 202) then
            num1 <= "0010";
            num2 <= "0000";
            num3 <= "0010";
        elsif (number = 203) then
            num1 <= "0010";
            num2 <= "0000";
            num3 <= "0011";
        elsif (number = 204) then
            num1 <= "0010";
            num2 <= "0000";
            num3 <= "0100";
        elsif (number = 205) then
            num1 <= "0010";
            num2 <= "0000";
            num3 <= "0101";
        elsif (number = 206) then
            num1 <= "0010";
            num2 <= "0000";
            num3 <= "0110";
        elsif (number = 207) then
            num1 <= "0010";
            num2 <= "0000";
            num3 <= "0111";
        elsif (number = 208) then
            num1 <= "0010";
            num2 <= "0000";
            num3 <= "1000";

        elsif (number = 209) then
            num1 <= "0010";
            num2 <= "0000";
            num3 <= "1001";

        elsif (number = 210) then
            num1 <= "0010";
            num2 <= "0001";
            num3 <= "0000";

        elsif (number = 211) then
            num1 <= "0010";
            num2 <= "0001";
            num3 <= "0001";

        elsif (number = 212) then
            num1 <= "0010";
            num2 <= "0001";
            num3 <= "0010";
        elsif (number = 213) then
            num1 <= "0010";
            num2 <= "0001";
            num3 <= "0011";
        elsif (number = 214) then
            num1 <= "0010";
            num2 <= "0001";
            num3 <= "0100";
        elsif (number = 215) then
            num1 <= "0010";
            num2 <= "0001";
            num3 <= "0101";
        elsif (number = 216) then
            num1 <= "0010";
            num2 <= "0001";
            num3 <= "0110";
        elsif (number = 217) then
            num1 <= "0010";
            num2 <= "0001";
            num3 <= "0111";
        elsif (number = 218) then
            num1 <= "0010";
            num2 <= "0001";
            num3 <= "1000";
        elsif (number = 219) then
            num1 <= "0010";
            num2 <= "0001";
            num3 <= "1001";

        elsif (number = 220) then
            num1 <= "0010";
            num2 <= "0010";
            num3 <= "0000";

        elsif (number = 221) then
            num1 <= "0010";
            num2 <= "0010";
            num3 <= "0001";
        elsif (number = 222) then
            num1 <= "0010";
            num2 <= "0010";
            num3 <= "0010";
        elsif (number = 223) then
            num1 <= "0010";
            num2 <= "0010";
            num3 <= "0011";
        elsif (number = 224) then
            num1 <= "0010";
            num2 <= "0010";
            num3 <= "0100";
        elsif (number = 225) then
            num1 <= "0010";
            num2 <= "0010";
            num3 <= "0101";
        elsif (number = 226) then
            num1 <= "0010";
            num2 <= "0010";
            num3 <= "0110";
        elsif (number = 227) then
            num1 <= "0010";
            num2 <= "0010";
            num3 <= "0111";
        elsif (number = 228) then
            num1 <= "0010";
            num2 <= "0010";
            num3 <= "1000";

        elsif (number = 229) then
            num1 <= "0010";
            num2 <= "0010";
            num3 <= "1001";

        elsif (number = 230) then
            num1 <= "0010";
            num2 <= "0011";
            num3 <= "0000";

        elsif (number = 231) then
            num1 <= "0010";
            num2 <= "0011";
            num3 <= "0001";

        elsif (number = 232) then
            num1 <= "0010";
            num2 <= "0011";
            num3 <= "0010";
        elsif (number = 233) then
            num1 <= "0010";
            num2 <= "0011";
            num3 <= "0011";
        elsif (number = 234) then
            num1 <= "0010";
            num2 <= "0011";
            num3 <= "0100";
        elsif (number = 235) then
            num1 <= "0010";
            num2 <= "0011";
            num3 <= "0101";
        elsif (number = 236) then
            num1 <= "0010";
            num2 <= "0011";
            num3 <= "0110";
        elsif (number = 237) then
            num1 <= "0010";
            num2 <= "0011";
            num3 <= "0111";
        elsif (number = 238) then
            num1 <= "0010";
            num2 <= "0011";
            num3 <= "1000";
        elsif (number = 239) then
            num1 <= "0010";
            num2 <= "0011";
            num3 <= "1001";

        elsif (number = 240) then
            num1 <= "0010";
            num2 <= "0100";
            num3 <= "0000";

        elsif (number = 241) then
            num1 <= "0010";
            num2 <= "0100";
            num3 <= "0001";

        elsif (number = 242) then
            num1 <= "0010";
            num2 <= "0100";
            num3 <= "0010";
        elsif (number = 243) then
            num1 <= "0010";
            num2 <= "0100";
            num3 <= "0011";
        elsif (number = 244) then
            num1 <= "0010";
            num2 <= "0100";
            num3 <= "0100";
        elsif (number = 245) then
            num1 <= "0010";
            num2 <= "0100";
            num3 <= "0101";
        elsif (number = 246) then
            num1 <= "0010";
            num2 <= "0100";
            num3 <= "0110";
        elsif (number = 247) then
            num1 <= "0010";
            num2 <= "0100";
            num3 <= "0111";
        elsif (number = 248) then
            num1 <= "0010";
            num2 <= "0100";
            num3 <= "1000";

        elsif (number = 249) then
            num1 <= "0010";
            num2 <= "0100";
            num3 <= "1001";

        elsif (number = 250) then
            num1 <= "0010";
            num2 <= "0101";
            num3 <= "0000";

        elsif (number = 251) then
            num1 <= "0010";
            num2 <= "0101";
            num3 <= "0001";

        elsif (number = 252) then
            num1 <= "0010";
            num2 <= "0101";
            num3 <= "0010";
        elsif (number = 253) then
            num1 <= "0010";
            num2 <= "0101";
            num3 <= "0011";
        elsif (number = 254) then
            num1 <= "0010";
            num2 <= "0101";
            num3 <= "0100";
        elsif (number = 255) then
            num1 <= "0010";
            num2 <= "0101";
            num3 <= "0101";
        else
            num1 <= "0010";
            num2 <= "0101";
            num3 <= "0110";

        end if;
    end process;
end architecture;
