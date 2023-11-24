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
		write	 	: in std_logic;
		data_in4b1	: in std_logic_vector(3 downto 0);
		data_in4b2	: in std_logic_vector(3 downto 0);
		data_out4b1	: out std_logic_vector(3 downto 0);
		data_out4b2	: out std_logic_vector(3 downto 0);
		data_in10b1	: in std_logic_vector(9 downto 0);
		data_in10b2	: in std_logic_vector(9 downto 0);
		data_out10b1	: out std_logic_vector(9 downto 0);
		data_out10b2	: out std_logic_vector(9 downto 0);
		data_in8b1 		: in std_logic_vector(7 downto 0);--attack x char1
		data_in8b2		: in std_logic_vector(7 downto 0);--attack y char1
		data_in8b3		: in std_logic_vector(7 downto 0);--attack x char2
		data_in8b4		: in std_logic_vector(7 downto 0);--attack y char2
		data_in8b5		: in std_logic_vector(7 downto 0);
		data_in8b6		: in std_logic_vector(7 downto 0);
		data_in8b7		: in std_logic_vector(7 downto 0);
		data_in8b8		: in std_logic_vector(7 downto 0);
		data_out8b1		: out std_logic_vector(7 downto 0);--attack x char1
		data_out8b2		: out std_logic_vector(7 downto 0);--attack y char1
		data_out8b3		: out std_logic_vector(7 downto 0);--attack x char2
		data_out8b4		: out std_logic_vector(7 downto 0);--attack y char2
		data_out8b5		: out std_logic_vector(7 downto 0);
		data_out8b6		: out std_logic_vector(7 downto 0);
		data_out8b7		: out std_logic_vector(7 downto 0);
		data_out8b8		: out std_logic_vector(7 downto 0);
		data_in9b1		: in std_logic_vector(8 downto 0);
		data_in9b2		: in std_logic_vector(8 downto 0);
		data_in9b3		: in std_logic_vector(8 downto 0);
		data_in9b4		: in std_logic_vector(8 downto 0);
		data_out9b1		: out std_logic_vector(8 downto 0);
		data_out9b2		: out std_logic_vector(8 downto 0);
		data_out9b3		: out std_logic_vector(8 downto 0);
		data_out9b4		: out std_logic_vector(8 downto 0));
end memory;

architecture structural of memory is

	component ram_4b is
	port(
		clk			: in std_logic;
		reset		: in std_logic;
		data_in 	: in std_logic_vector(3 downto 0);
		data_out 	: out std_logic_vector(3 downto 0);
		write 		: in std_logic);
	end component ram_4b;
	
	component ram_10b is
	port(
		clk			: in std_logic;
		reset		: in std_logic;
		data_in 	: in std_logic_vector(9 downto 0);
		data_out 	: out std_logic_vector(9 downto 0);
		write 		: in std_logic);
	end component ram_10b;
	
	component ram_8b is
	port(
		clk			: in std_logic;
		reset		: in std_logic;
		data_in 	: in std_logic_vector(7 downto 0);
		data_out 	: out std_logic_vector(7 downto 0);
		write 		: in std_logic);
	end component ram_8b;
	
	component ram_9b is
	port(
		clk			: in std_logic;
		reset		: in std_logic;
		data_in 	: in std_logic_vector(8 downto 0);
		data_out 	: out std_logic_vector(8 downto 0);
		write 		: in std_logic);
	end component ram_9b;
	
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
								data_in 	=> data_in4b1,
								data_out 	=> data_out4b1,
								write 		=> write);
								
	DM01 : ram_4b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in4b2,
								data_out 	=> data_out4b2,
								write 		=> write);
								
	DM10 : ram_10b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in10b1,
								data_out 	=> data_out10b1,
								write 		=> write);
								
	DM11 : ram_10b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in10b2,
								data_out 	=> data_out10b2,
								write 		=> write);
								
	DM20 : ram_8b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in8b1,
								data_out 	=> data_out8b1,
								write 		=> write);
								
	DM21 : ram_8b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in8b2,
								data_out 	=> data_out8b2,
								write 		=> write);
								
	DM22 : ram_8b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in8b3,
								data_out 	=> data_out8b3,
								write 		=> write);
								
	DM23 : ram_8b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in8b4,
								data_out 	=> data_out8b4,
								write 		=> write);
								
	DM24 : ram_8b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in8b5,
								data_out 	=> data_out8b5,
								write 		=> write);
								
	DM25 : ram_8b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in8b6,
								data_out 	=> data_out8b6,
								write 		=> write);
								
	DM26 : ram_8b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in8b7,
								data_out 	=> data_out8b7,
								write 		=> write);
								
	DM27 : ram_8b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in8b8,
								data_out 	=> data_out8b8,
								write 		=> write);
	
	DM30 : ram_9b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in9b1,
								data_out 	=> data_out9b1,
								write 		=> write);
								
	DM31 : ram_9b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in9b2,
								data_out 	=> data_out9b2,
								write 		=> write);
								
	DM32 : ram_9b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in9b3,
								data_out 	=> data_out9b3,
								write 		=> write);
								
	DM33 : ram_9b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in9b4,
								data_out 	=> data_out9b4,
								write 		=> write);
								
								
end architecture structural;

configuration memory_structural_cfg of memory is
	for structural
		for all: ram_4b use configuration work.ram_4b_behaviour_cfg;
		end for;
		for all: ram_10b use configuration work.ram_10b_behaviour_cfg;
		end for;
		for all: ram_8b use configuration work.ram_8b_behaviour_cfg;
		end for;
		for all: ram_9b use configuration work.ram_9b_behaviour_cfg;
		end for;
		for all: staticmem use configuration work.staticmem_structural_cfg;
		end for;
	end for;
end memory_structural_cfg;