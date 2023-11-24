library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity staticmem is
port(	charhp		: out std_logic_vector(9 downto 0);
		chardc		: out std_logic_vector(7 downto 0);
		char1sx		: out std_logic_vector(7 downto 0);
		char1sy		: out std_logic_vector(7 downto 0);
		char2sx		: out std_logic_vector(7 downto 0);
		char2sy		: out std_logic_vector(7 downto 0);
		char1vx		: out std_logic_vector(8 downto 0);
		char1vy		: out std_logic_vector(8 downto 0);
		char2vx		: out std_logic_vector(8 downto 0);
		char2vy		: out std_logic_vector(8 downto 0);
		chardx		: out std_logic_vector(3 downto 0);
		chardy		: out std_logic_vector(3 downto 0);
		att1dx		: out std_logic_vector(3 downto 0);
		att1dy		: out std_logic_vector(3 downto 0);
		att2dx		: out std_logic_vector(3 downto 0);
		att2dy		: out std_logic_vector(3 downto 0);
		att1dm		: out std_logic_vector(3 downto 0);
		att2dm		: out std_logic_vector(3 downto 0);
		att1kb		: out std_logic_vector(5 downto 0);
		att2kb		: out std_logic_vector(5 downto 0);
		plat1x		: out std_logic_vector(7 downto 0);
		plat1y		: out std_logic_vector(7 downto 0);
		plat2x		: out std_logic_vector(7 downto 0);
		plat2y		: out std_logic_vector(7 downto 0);
		plat3x		: out std_logic_vector(7 downto 0);
		plat3y		: out std_logic_vector(7 downto 0);
		plat4x		: out std_logic_vector(7 downto 0);
		plat4y		: out std_logic_vector(7 downto 0);
		plat1dx		: out std_logic_vector(7 downto 0);
		plat1dy		: out std_logic_vector(7 downto 0);
		plat2dx		: out std_logic_vector(7 downto 0);
		plat2dy		: out std_logic_vector(7 downto 0);
		plat3dx		: out std_logic_vector(7 downto 0);
		plat3dy		: out std_logic_vector(7 downto 0);
		plat4dx		: out std_logic_vector(7 downto 0);
		plat4dy		: out std_logic_vector(7 downto 0);
		kilznx1		: out std_logic_vector(7 downto 0);
		kilznx2		: out std_logic_vector(7 downto 0);
		kilzny1		: out std_logic_vector(7 downto 0);
		num01		: out std_logic_vector(4 downto 0);
		num02		: out std_logic_vector(4 downto 0);
		num03		: out std_logic_vector(4 downto 0);
		num04		: out std_logic_vector(4 downto 0);
		num05		: out std_logic_vector(4 downto 0);
		num11		: out std_logic_vector(4 downto 0);
		num12		: out std_logic_vector(4 downto 0);
		num23		: out std_logic_vector(4 downto 0);
		num24		: out std_logic_vector(4 downto 0);
		num25		: out std_logic_vector(4 downto 0);
		num26		: out std_logic_vector(4 downto 0);
		num27		: out std_logic_vector(4 downto 0);
		num41		: out std_logic_vector(4 downto 0);
		num42		: out std_logic_vector(4 downto 0);
		num43		: out std_logic_vector(4 downto 0);
		num53		: out std_logic_vector(4 downto 0);
		num74		: out std_logic_vector(4 downto 0);
		num94		: out std_logic_vector(4 downto 0);
		num97		: out std_logic_vector(4 downto 0));
end staticmem;

architecture structural of staticmem is
begin
		charhp		<= "0000000000";
		chardc		<= "00000000";
		char1sx		<= "00000000";
		char1sy		<= "00000000";
		char2sx		<= "00000000";
		char2sy		<= "00000000";
		char1vx		<= "000000000";
		char1vy		<= "000000000";
		char2vx		<= "000000000";
		char2vy		<= "000000000";
		chardx		<= "0100";
		chardy		<= "0100";
		att1dx		<= "0000";
		att1dy		<= "0000";
		att2dx		<= "0000";
		att2dy		<= "0000";
		att1dm		<= "0000";
		att2dm		<= "0000";
		att1kb		<= "000000";
		att2kb		<= "000000";
		plat1x		<= "01011000";
		plat1y		<= "01101011";
		plat2x		<= "00000000";
		plat2y		<= "00000000";
		plat3x		<= "00000000";
		plat3y		<= "00000000";
		plat4x		<= "00000000";
		plat4y		<= "00000000";
		plat1dx		<= "10100000";
		plat1dy		<= "00000001";
		plat2dx		<= "00000000";
		plat2dy		<= "00000000";
		plat3dx		<= "00000000";
		plat3dy		<= "00000000";
		plat4dx		<= "00000000";
		plat4dy		<= "00000000";
		kilznx1		<= "00000000";
		kilznx2		<= "10110000";
		kilzny1		<= "00000000";
		num01		<= "01110";
		num02		<= "10001";
		num03		<= "10011";
		num04		<= "10101";
		num05		<= "11001";
		-- 06 same as 02
		-- 07 same as 01
		num11		<= "00100";
		num12		<= "01100";
		-- 13 same as 11
		-- 14 same as 11
		-- 15 same as 11
		-- 16 same as 11
		-- 17 same as 01
		-- 21 same as 01
		-- 22 same as 02
		num23		<= "00001";
		num24		<= "00110";
		num25		<= "01000";
		num26		<= "10000";
		num27		<= "11111";
		-- 31 same as 01
		-- 32 same as 02
		-- 33 same as 23 
		-- 34 same as 24
		-- 35 same as 23
		-- 36 same as 02
		-- 37 same as 01
		num41		<= "00011";
		num42		<= "00101";
		num43		<= "01001";
		-- 44 same as 02
		-- 45 same as 27
		-- 46 same as 23
		-- 47 same as 23
		-- 48 same as 27
		-- 52 same as 26
		num53		<= "11110";
		-- 54 same as 23
		-- 55 same as 23
		-- 56 same as 02
		-- 57 same as 01
		-- 61 same as 24
		-- 62 same as 25
		-- 63 same as 52
		-- 64 same as 53
		-- 65 same as 02
		-- 66 same as 02
		-- 67 same as 01
		-- 71 same as 27
		-- 72 same as 02
		-- 73 same as 23
		num74		<= "00010"; 
		-- 75 same as 11
		-- 76 same as 11
		-- 77 same as 11
		-- 81 same as 01
		-- 82 same as 02
		-- 83 same as 02
		-- 84 same as 01
		-- 85 same as 02
		-- 86 same as 02
		-- 87 same as 01
		-- 91 same as 01
		-- 92 same as 02
		-- 93 same as 02
		num94		<= "01111"; 
		-- 95 same as 23
		-- 96 same as 74
		num97		<= "11100";
end architecture structural;

configuration staticmem_structural_cfg of staticmem is
   for structural
   end for;
end staticmem_structural_cfg;