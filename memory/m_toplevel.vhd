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
		write4b 	: in std_logic;
		write10b 	: in std_logic;
		write16b 	: in std_logic;
		write18b 	: in std_logic;
		address4b	: in std_logic_vector(0 downto 0);
		data_in4b	: in std_logic_vector(4 downto 0);
		data_out4b	: out std_logic_vector(4 downto 0);
		address10b	: in std_logic_vector(1 downto 0);
		data_in10b	: in std_logic_vector(9 downto 0);
		data_out10b	: out std_logic_vector(9 downto 0);
		address16b 	: in std_logic_vector(2 downto 0);
		data_in16b1 	: in std_logic_vector(7 downto 0);
		data_in16b2		: in std_logic_vector(7 downto 0);
		data_out16b1	: out std_logic_vector(7 downto 0);
		data_out16b2	: out std_logic_vector(7 downto 0);
		address18b	: in std_logic_vector(1 downto 0);
		data_in18b1		: in std_logic_vector(8 downto 0);
		data_in18b2		: in std_logic_vector(8 downto 0);
		data_out18b1	: out std_logic_vector(8 downto 0);
		data_out18b2	: out std_logic_vector(8 downto 0));
end memory;

architecture structural of memory is

	signal	split18b :		std_logic_vector(17 downto 0);
	signal	merge18b :		std_logic_vector(17 downto 0);
	signal	split16b :		std_logic_vector(15 downto 0);
	signal	merge16b :		std_logic_vector(15 downto 0);

	component splitter_8b is
		port(in1  : in  std_logic_vector(15 downto 0);
			out1 : out std_logic_vector(7 downto 0);
			out2 : out std_logic_vector(7 downto 0));
	end component splitter_8b;
	
	component merger_8b is
		port(in1  : in  std_logic_vector(7 downto 0);
			in2  : in  std_logic_vector(7 downto 0);
			out1 : out std_logic_vector(15 downto 0));
	end component merger_8b;
	
	component splitter_9b is
		port(in1  : in  std_logic_vector(17 downto 0);
			out1 : out std_logic_vector(8 downto 0);
			out2 : out std_logic_vector(8 downto 0));
	end component splitter_9b;
	
	component merger_9b is
		port(in1  : in  std_logic_vector(8 downto 0);
			in2  : in  std_logic_vector(8 downto 0);
			out1 : out std_logic_vector(17 downto 0));
	end component merger_9b;


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
	
	SM00: staticmem port map (	charhp		=> charhp,
								chardc		=> chardc,
								char1sx		=> char1sx,
								char1sy		=> char1sy,
								char2sx		=> char2sx,
								char2sy		=> char2sy,
								char1vx		=> char1vx,
								char1vy		=> char1vy,
								char2vx		=> char2vx,
								char2vy		=> char2vy,
								chardx		=> chardx,
								chardy		=> chardy,
								att1dx		=> att1dx,
								att1dy		=> att1dy,
								att2dx		=> att2dx,
								att2dy		=> att2dy,
								att1dm		=> att1dm,
								att2dm		=> att2dm,
								att1kb		=> att1kb,
								att2kb		=> att2kb,
								plat1x		=> plat1x,
								plat1y		=> plat1y,
								plat2x		=> plat2x,
								plat2y		=> plat2y,
								plat3x		=> plat3x,
								plat3y		=> plat3y,
								plat4x		=> plat4x,
								plat4y		=> plat4y,
								plat1dx		=> plat1dx,
								plat1dy		=> plat1dy,
								plat2dx		=> plat2dx,
								plat2dy		=> plat2dy,
								plat3dx		=> plat3dx,
								plat3dy		=> plat3dy,
								plat4dx		=> plat4dx,
								plat4dy		=> plat4dy,
								kilznx1		=> kilznx1,
								kilznx2		=> kilznx2,
								kilzny1		=> kilzny1,
								num01		=> num01,
								num02		=> num02,
								num03		=> num03,
								num04		=> num04,
								num05		=> num05,
								num11		=> num11,
								num12		=> num12,
								num23		=> num23,
								num24		=> num24,
								num25		=> num25,
								num26		=> num26,
								num27		=> num27,
								num41		=> num41,
								num42		=> num42,
								num43		=> num43,
								num53		=> num53,
								num74		=> num74,
								num94		=> num94,
								num97		=> num97);
								
	DM00 : ram_4b port map (	clk			=> clk,
								reset		=> reset,
								address 	=> address4b,
								data_in 	=> data_in4b,
								data_out 	=> data_out4b,
								write 		=> write4b);
								
	DM01 : ram_10b port map (	clk			=> clk,
								reset		=> reset,
								address 	=> address10b,
								data_in 	=> data_in10b,
								data_out 	=> data_out10b,
								write 		=> write10b);
								
	DM02 : ram_16b port map (	clk			=> clk,
								reset		=> reset,
								address 	=> address16b,
								data_in 	=> merge16b,
								data_out 	=> split16b,
								write 		=> write16b);
	
	DM03 : ram_18b port map (	clk			=> clk,
								reset		=> reset,
								address 	=> address18b,
								data_in 	=> merge18b,
								data_out 	=> split18b,
								write 		=> write18b);
								
	MM00 : splitter_8b port map (	in1		=> split16b,
									out1	=> data_out16b1,
									out2	=> data_out16b2);
									
	MM01 : merger_8b port map (		in1		=> data_in16b1,
									in2		=> data_in16b2,
									out1	=> merge16b);
									
	MM10 : splitter_9b port map (	in1		=> split18b,
									out1	=> data_out18b1,
									out2	=> data_out18b2);
									
	MM11 : merger_9b port map (		in1		=> data_in18b1,
									in2		=> data_in18b2,
									out1	=> merge18b);
								
end architecture structural;