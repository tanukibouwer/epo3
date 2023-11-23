library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_16b is
port(
	clk			: in std_logic;
	reset		: in std_logic;
	address 	: in std_logic_vector(2 downto 0);
	data_in 	: in std_logic_vector(15 downto 0);
	data_out 	: out std_logic_vector(15 downto 0);
	write 		: in std_logic);
end ram_16b;

architecture behaviour of ram_16b is
	type mem_type is array(0 to (2**address'length)-1)
	of std_logic_vector(data_in'range);
	signal mem : mem_type;
begin
	ram_ff: process(clk) is
	begin
		if (rising_edge (clk)) and write = '1' then
			mem(to_integer(unsigned(address))) <= data_in;
		end if;
	end process;
	data_out <= mem(to_integer(unsigned(address)));
end behaviour;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_18b is
port(
	clk			: in std_logic;
	reset		: in std_logic;
	address 	: in std_logic_vector(1 downto 0);
	data_in 	: in std_logic_vector(17 downto 0);
	data_out 	: out std_logic_vector(17 downto 0);
	write 		: in std_logic);
end ram_18b;

architecture behaviour of ram_18b is
	type mem_type is array(0 to (2**address'length)-1)
	of std_logic_vector(data_in'range);
	signal mem : mem_type;
begin
	ram_ff: process(clk) is
	begin
		if (rising_edge (clk)) and write = '1' then
			mem(to_integer(unsigned(address))) <= data_in;
		end if;
	end process;
	data_out <= mem(to_integer(unsigned(address)));
end behaviour;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_10b is
port(
	clk			: in std_logic;
	reset		: in std_logic;
	address 	: in std_logic_vector(1 downto 0);
	data_in 	: in std_logic_vector(9 downto 0);
	data_out 	: out std_logic_vector(9 downto 0);
	write 		: in std_logic);
end ram_10b;

architecture behaviour of ram_10b is
	type mem_type is array(0 to (2**address'length)-1)
	of std_logic_vector(data_in'range);
	signal mem : mem_type;
begin
	ram_ff: process(clk) is
	begin
		if (rising_edge (clk)) and write = '1' then
			mem(to_integer(unsigned(address))) <= data_in;
		end if;
	end process;
	data_out <= mem(to_integer(unsigned(address)));
end behaviour;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_4b is
port(
	clk			: in std_logic;
	reset		: in std_logic;
	address 	: in std_logic_vector(0 downto 0);
	data_in 	: in std_logic_vector(4 downto 0);
	data_out 	: out std_logic_vector(4 downto 0);
	write 		: in std_logic);
end ram_4b;


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
		char1vx		<= "00000000";
		char1vy		<= "000000000";
		char2vx		<= "000000000";
		char2vy		<= "000000000";
		chardx		<= "0000";
		chardy		<= "0000";
		att1dx		<= "0000";
		att1dy		<= "0000";
		att2dx		<= "0000";
		att2dy		<= "0000";
		att1dm		<= "0000";
		att2dm		<= "0000";;
		att1kb		<= "000000";
		att2kb		<= "000000";
		plat1x		<= "01011000";
		plat1y		<= "00000000";
		plat2x		<= "00000000";
		plat2y		<= "00000000";
		plat3x		<= "00000000";
		plat3y		<= "00000000";
		plat4x		<= "00000000";
		plat4y		<= "00000000";
		plat1dx		<= "10100000";
		plat1dy		<= "00000000";
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
		num97		<= "11100");
end architecture structural;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
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
		num97		: out std_logic_vector(4 downto 0);
		clk			: in std_logic;
		reset		: in std_logic;
		write 		: in std_logic;
		address10b	: in std_logic_vector(1 downto 0);
		data_in10b	: in std_logic_vector(9 downto 0);
		data_out10b	: out std_logic_vector(9 downto 0);
		address16b 	: in std_logic_vector(2 downto 0);
		data_in16b 	: in std_logic_vector(15 downto 0);
		data_out16b	: out std_logic_vector(15 downto 0);
		address18b	: in std_logic_vector(1 downto 0);
		data_in18b	: in std_logic_vector(17 downto 0);
		data_out18b	: out std_logic_vector(17 downto 0));
end memory;

architecture structural of memory is

	component ram_4b is
	port(
		clk			: in std_logic;
		reset		: in std_logic;
		address 	: in std_logic_vector(0 downto 0);
		data_in 	: in std_logic_vector(4 downto 0);
		data_out 	: out std_logic_vector(4 downto 0);
		write 		: in std_logic);
	end component ram_4b;
	
	component ram_10b is
	port(
		clk			: in std_logic;
		reset		: in std_logic;
		address 	: in std_logic_vector(1 downto 0);
		data_in 	: in std_logic_vector(9 downto 0);
		data_out 	: out std_logic_vector(9 downto 0);
		write 		: in std_logic);
	end component ram_10b;
	
	component ram_16b is
	port(
		clk			: in std_logic;
		reset		: in std_logic;
		address 	: in std_logic_vector(2 downto 0);
		data_in 	: in std_logic_vector(15 downto 0);
		data_out 	: out std_logic_vector(15 downto 0);
		write 		: in std_logic);
	end component ram_16b;
	
	component ram_18b is
	port(
		clk			: in std_logic;
		reset		: in std_logic;
		address 	: in std_logic_vector(1 downto 0);
		data_in 	: in std_logic_vector(17 downto 0);
		data_out 	: out std_logic_vector(17 downto 0);
		write 		: in std_logic);
	end component ram_18b;
	
	component staticmem is
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
	end component staticmem;
		
begin
	
	SM01: staticmem port map (	charhp		=> charhp;
								chardc		=> chardc;
								char1sx		=> char1sx;
								char1sy		=> char1sy;
								char2sx		=> char2sx;
								char2sy		=> char2sy;
								char1vx		=> char1vx;
								char1vy		=> char1vy;
								char2vx		=> char2vx;
								char2vy		=> char2vy;
								chardx		=> chardx;
								chardy		=> chardy;
								att1dx		=> att1dx;
								att1dy		=> att1dy;
								att2dx		=> att2dx;
								att2dy		=> att2dy;
								att1dm		=> att1dm;
								att2dm		=> att2dm;
								att1kb		=> att1kb;
								att2kb		=> att2kb;
								plat1x		=> plat1x;
								plat1y		=> plat1y;
								plat2x		=> plat2x;
								plat2y		=> plat2y;
								plat3x		=> plat3x;
								plat3y		=> plat3y;
								plat4x		=> plat4x;
								plat4y		=> plat4y;
								plat1dx		=> plat1dx;
								plat1dy		=> plat1dy;
								plat2dx		=> plat2dx;
								plat2dy		=> plat2dy;
								plat3dx		=> plat3dx;
								plat3dy		=> plat3dy;
								plat4dx		=> plat4dx;
								plat4dy		=> plat4dy;
								kilznx1		=> kilznx1;
								kilznx2		=> kilznx2;
								kilzny1		=> kilzny1;
								num01		=> num01;
								num02		=> num02;
								num03		=> num03;
								num04		=> num04;
								num05		=> num05;
								num11		=> num11;
								num12		=> num12;
								num23		=> num23;
								num24		=> num24;
								num25		=> num25;
								num26		=> num26;
								num27		=> num27;
								num41		=> num41;
								num42		=> num42;
								num43		=> num43;
								num53		=> num53;
								num74		=> num74;
								num94		=> num94;
								num97		=> num97);
								
	DM01 : ram_10b port map (	clk			=> clk;
								reset		=> reset;
								address 	=> address10b;
								data_in 	=> data_in10b;
								data_out 	=> data_out10b; 
								write 		=> write);
								
	DM02 : ram_16b port map (	clk			=> clk;
								reset		=> reset;
								address 	=> address16b;
								data_in 	=> data_in16b;
								data_out 	=> data_out16b;
								write 		=> write);
	
	DM03 : ram_18b port map (	clk			=> clk;
								reset		=> reset;
								address 	=> address18b;
								data_in 	=> data_in18b;
								data_out 	=> data_out18b;
								write 		=> write);
								
end architecture structural;








