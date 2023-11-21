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
		num01		: out std_logic_vector(4 downto 0);
		num02		: out std_logic_vector(4 downto 0);
		num03		: out std_logic_vector(4 downto 0);
		num04		: out std_logic_vector(4 downto 0);
		num05		: out std_logic_vector(4 downto 0);
		num11		: out std_logic_vector(4 downto 0);
		num12		: out std_logic_vector(4 downto 0);
		num13		: out std_logic_vector(4 downto 0);
		num14		: out std_logic_vector(4 downto 0);
		num15		: out std_logic_vector(4 downto 0);
		num21		: out std_logic_vector(4 downto 0);
		num22		: out std_logic_vector(4 downto 0);
		num23		: out std_logic_vector(4 downto 0);
		num24		: out std_logic_vector(4 downto 0);
		num25		: out std_logic_vector(4 downto 0);
		num31		: out std_logic_vector(4 downto 0);
		num32		: out std_logic_vector(4 downto 0);
		num33		: out std_logic_vector(4 downto 0);
		num34		: out std_logic_vector(4 downto 0);
		num35		: out std_logic_vector(4 downto 0);
		num41		: out std_logic_vector(4 downto 0);
		num42		: out std_logic_vector(4 downto 0);
		num43		: out std_logic_vector(4 downto 0);
		num44		: out std_logic_vector(4 downto 0);
		num45		: out std_logic_vector(4 downto 0);
		num51		: out std_logic_vector(4 downto 0);
		num52		: out std_logic_vector(4 downto 0);
		num53		: out std_logic_vector(4 downto 0);
		num54		: out std_logic_vector(4 downto 0);
		num55		: out std_logic_vector(4 downto 0);
		num61		: out std_logic_vector(4 downto 0);
		num62		: out std_logic_vector(4 downto 0);
		num63		: out std_logic_vector(4 downto 0);
		num64		: out std_logic_vector(4 downto 0);
		num65		: out std_logic_vector(4 downto 0);
		num71		: out std_logic_vector(4 downto 0);
		num72		: out std_logic_vector(4 downto 0);
		num73		: out std_logic_vector(4 downto 0);
		num74		: out std_logic_vector(4 downto 0);
		num75		: out std_logic_vector(4 downto 0);
		num81		: out std_logic_vector(4 downto 0);
		num82		: out std_logic_vector(4 downto 0);
		num83		: out std_logic_vector(4 downto 0);
		num84		: out std_logic_vector(4 downto 0);
		num85		: out std_logic_vector(4 downto 0);
		num91		: out std_logic_vector(4 downto 0);
		num92		: out std_logic_vector(4 downto 0);
		num93		: out std_logic_vector(4 downto 0);
		num94		: out std_logic_vector(4 downto 0);
		num95		: out std_logic_vector(4 downto 0));
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
		plat1x		<= "00000000";
		plat1y		<= "00000000";
		plat2x		<= "00000000";
		plat2y		<= "00000000";
		plat3x		<= "00000000";
		plat3y		<= "00000000";
		plat4x		<= "00000000";
		plat4y		<= "00000000";
		plat1dx		<= "00000000";
		plat1dy		<= "00000000";
		plat2dx		<= "00000000";
		plat2dy		<= "00000000";
		plat3dx		<= "00000000";
		plat3dy		<= "00000000";
		plat4dx		<= "00000000";
		plat4dy		<= "00000000";
		num01		<= "00000";
		num02		<= "00000";
		num03		<= "00000";
		num04		<= "00000";
		num05		<= "00000";
		num11		<= "00000";
		num12		<= "00000";
		num13		<= "00000";
		num14		<= "00000";
		num15		<= "00000";
		num21		<= "00000";
		num22		<= "00000";
		num23		<= "00000";
		num24		<= "00000";
		num25		<= "00000";
		num31		<= "00000";
		num32		<= "00000";
		num33		<= "00000";
		num34		<= "00000";
		num35		<= "00000";
		num41		<= "00000";
		num42		<= "00000";
		num43		<= "00000";
		num44		<= "00000";
		num45		<= "00000";
		num51		<= "00000";
		num52		<= "00000";
		num53		<= "00000";
		num54		<= "00000";
		num55		<= "00000";
		num61		<= "00000";
		num62		<= "00000";
		num63		<= "00000";
		num64		<= "00000";
		num65		<= "00000";
		num71		<= "00000";
		num72		<= "00000";
		num73		<= "00000";
		num74		<= "00000";
		num75		<= "00000";
		num81		<= "00000";
		num82		<= "00000";
		num83		<= "00000";
		num84		<= "00000";
		num85		<= "00000";
		num91		<= "00000";
		num92		<= "00000";
		num93		<= "00000";
		num94		<= "00000";
		num95		<= "00000");
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
		num01		: out std_logic_vector(4 downto 0);
		num02		: out std_logic_vector(4 downto 0);
		num03		: out std_logic_vector(4 downto 0);
		num04		: out std_logic_vector(4 downto 0);
		num05		: out std_logic_vector(4 downto 0);
		num11		: out std_logic_vector(4 downto 0);
		num12		: out std_logic_vector(4 downto 0);
		num13		: out std_logic_vector(4 downto 0);
		num14		: out std_logic_vector(4 downto 0);
		num15		: out std_logic_vector(4 downto 0);
		num21		: out std_logic_vector(4 downto 0);
		num22		: out std_logic_vector(4 downto 0);
		num23		: out std_logic_vector(4 downto 0);
		num24		: out std_logic_vector(4 downto 0);
		num25		: out std_logic_vector(4 downto 0);
		num31		: out std_logic_vector(4 downto 0);
		num32		: out std_logic_vector(4 downto 0);
		num33		: out std_logic_vector(4 downto 0);
		num34		: out std_logic_vector(4 downto 0);
		num35		: out std_logic_vector(4 downto 0);
		num41		: out std_logic_vector(4 downto 0);
		num42		: out std_logic_vector(4 downto 0);
		num43		: out std_logic_vector(4 downto 0);
		num44		: out std_logic_vector(4 downto 0);
		num45		: out std_logic_vector(4 downto 0);
		num51		: out std_logic_vector(4 downto 0);
		num52		: out std_logic_vector(4 downto 0);
		num53		: out std_logic_vector(4 downto 0);
		num54		: out std_logic_vector(4 downto 0);
		num55		: out std_logic_vector(4 downto 0);
		num61		: out std_logic_vector(4 downto 0);
		num62		: out std_logic_vector(4 downto 0);
		num63		: out std_logic_vector(4 downto 0);
		num64		: out std_logic_vector(4 downto 0);
		num65		: out std_logic_vector(4 downto 0);
		num71		: out std_logic_vector(4 downto 0);
		num72		: out std_logic_vector(4 downto 0);
		num73		: out std_logic_vector(4 downto 0);
		num74		: out std_logic_vector(4 downto 0);
		num75		: out std_logic_vector(4 downto 0);
		num81		: out std_logic_vector(4 downto 0);
		num82		: out std_logic_vector(4 downto 0);
		num83		: out std_logic_vector(4 downto 0);
		num84		: out std_logic_vector(4 downto 0);
		num85		: out std_logic_vector(4 downto 0);
		num91		: out std_logic_vector(4 downto 0);
		num92		: out std_logic_vector(4 downto 0);
		num93		: out std_logic_vector(4 downto 0);
		num94		: out std_logic_vector(4 downto 0);
		num95		: out std_logic_vector(4 downto 0);
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
			num01		: out std_logic_vector(4 downto 0);
			num02		: out std_logic_vector(4 downto 0);
			num03		: out std_logic_vector(4 downto 0);
			num04		: out std_logic_vector(4 downto 0);
			num05		: out std_logic_vector(4 downto 0);
			num11		: out std_logic_vector(4 downto 0);
			num12		: out std_logic_vector(4 downto 0);
			num13		: out std_logic_vector(4 downto 0);
			num14		: out std_logic_vector(4 downto 0);
			num15		: out std_logic_vector(4 downto 0);
			num21		: out std_logic_vector(4 downto 0);
			num22		: out std_logic_vector(4 downto 0);
			num23		: out std_logic_vector(4 downto 0);
			num24		: out std_logic_vector(4 downto 0);
			num25		: out std_logic_vector(4 downto 0);
			num31		: out std_logic_vector(4 downto 0);
			num32		: out std_logic_vector(4 downto 0);
			num33		: out std_logic_vector(4 downto 0);
			num34		: out std_logic_vector(4 downto 0);
			num35		: out std_logic_vector(4 downto 0);
			num41		: out std_logic_vector(4 downto 0);
			num42		: out std_logic_vector(4 downto 0);
			num43		: out std_logic_vector(4 downto 0);
			num44		: out std_logic_vector(4 downto 0);
			num45		: out std_logic_vector(4 downto 0);
			num51		: out std_logic_vector(4 downto 0);
			num52		: out std_logic_vector(4 downto 0);
			num53		: out std_logic_vector(4 downto 0);
			num54		: out std_logic_vector(4 downto 0);
			num55		: out std_logic_vector(4 downto 0);
			num61		: out std_logic_vector(4 downto 0);
			num62		: out std_logic_vector(4 downto 0);
			num63		: out std_logic_vector(4 downto 0);
			num64		: out std_logic_vector(4 downto 0);
			num65		: out std_logic_vector(4 downto 0);
			num71		: out std_logic_vector(4 downto 0);
			num72		: out std_logic_vector(4 downto 0);
			num73		: out std_logic_vector(4 downto 0);
			num74		: out std_logic_vector(4 downto 0);
			num75		: out std_logic_vector(4 downto 0);
			num81		: out std_logic_vector(4 downto 0);
			num82		: out std_logic_vector(4 downto 0);
			num83		: out std_logic_vector(4 downto 0);
			num84		: out std_logic_vector(4 downto 0);
			num85		: out std_logic_vector(4 downto 0);
			num91		: out std_logic_vector(4 downto 0);
			num92		: out std_logic_vector(4 downto 0);
			num93		: out std_logic_vector(4 downto 0);
			num94		: out std_logic_vector(4 downto 0);
			num95		: out std_logic_vector(4 downto 0));
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
								num01		=> num01;
								num02		=> num02;
								num03		=> num03;
								num04		=> num04;
								num05		=> num05;
								num11		=> num11;
								num12		=> num12;
								num13		=> num13;
								num14		=> num14;
								num15		=> num15;
								num21		=> num21;
								num22		=> num22;
								num23		=> num23;
								num24		=> num24;
								num25		=> num25;
								num31		=> num31;
								num32		=> num32;
								num33		=> num33;
								num34		=> num34;
								num35		=> num35;
								num41		=> num41;
								num42		=> num42;
								num43		=> num43;
								num44		=> num44;
								num45		=> num45;
								num51		=> num51;
								num52		=> num52;
								num53		=> num53;
								num54		=> num54;
								num55		=> num55;
								num61		=> num61;
								num62		=> num62;
								num63		=> num63;
								num64		=> num64;
								num65		=> num65;
								num71		=> num71;
								num72		=> num72;
								num73		=> num73;
								num74		=> num74;
								num75		=> num75;
								num81		=> num81;
								num82		=> num82;
								num83		=> num83;
								num84		=> num84;
								num85		=> num85;
								num91		=> num91;
								num92		=> num92;
								num93		=> num93;
								num94		=> num94;
								num95		=> num95);
								
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








