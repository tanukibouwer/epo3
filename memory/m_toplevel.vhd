library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
port(	--charhp		: out std_logic_vector(9 downto 0); --initial knockback percentage so NOT character health!
		--chardc		: out std_logic_vector(7 downto 0);
		--char1sx		: out std_logic_vector(7 downto 0);
		--char1sy		: out std_logic_vector(7 downto 0);
		--char2sx		: out std_logic_vector(7 downto 0);
		--char2sy		: out std_logic_vector(7 downto 0);
		--char1vx		: out std_logic_vector(8 downto 0);
		--char1vy		: out std_logic_vector(8 downto 0);
		--char2vx		: out std_logic_vector(8 downto 0);
		--char2vy		: out std_logic_vector(8 downto 0);
		--chardx		: out std_logic_vector(3 downto 0);
		--chardy		: out std_logic_vector(3 downto 0);
		--att1dx		: out std_logic_vector(3 downto 0);
		--att1dy		: out std_logic_vector(3 downto 0);
		--att2dx		: out std_logic_vector(3 downto 0);
		--att2dy		: out std_logic_vector(3 downto 0);
		--att1dm		: out std_logic_vector(3 downto 0);
		--att2dm		: out std_logic_vector(3 downto 0);
		-- att1kb		: out std_logic_vector(5 downto 0);
		-- att2kb		: out std_logic_vector(5 downto 0);
		--plat1x		: out std_logic_vector(7 downto 0);
		--plat1y		: out std_logic_vector(7 downto 0);
		--plat2x		: out std_logic_vector(7 downto 0);
		--plat2y		: out std_logic_vector(7 downto 0);
		--plat3x		: out std_logic_vector(7 downto 0);
		--plat3y		: out std_logic_vector(7 downto 0);
		--plat4x		: out std_logic_vector(7 downto 0);
		--plat4y		: out std_logic_vector(7 downto 0);
		--plat1dx		: out std_logic_vector(7 downto 0);
		--plat1dy		: out std_logic_vector(7 downto 0);
		--plat2dx		: out std_logic_vector(7 downto 0);
		--plat2dy		: out std_logic_vector(7 downto 0);
		--plat3dx		: out std_logic_vector(7 downto 0);
		--plat3dy		: out std_logic_vector(7 downto 0);
		--plat4dx		: out std_logic_vector(7 downto 0);
		--plat4dy		: out std_logic_vector(7 downto 0);
		--kilznx1		: out std_logic_vector(7 downto 0);
		--kilznx2		: out std_logic_vector(7 downto 0);
		--kilzny1		: out std_logic_vector(7 downto 0);
		-- numbers commented out for now, will be linked to vga module eventually
		-- num01		: out std_logic_vector(4 downto 0);
		-- num02		: out std_logic_vector(4 downto 0);
		-- num03		: out std_logic_vector(4 downto 0);
		-- num04		: out std_logic_vector(4 downto 0);
		-- num05		: out std_logic_vector(4 downto 0);
		-- num11		: out std_logic_vector(4 downto 0);
		-- num12		: out std_logic_vector(4 downto 0);
		-- num23		: out std_logic_vector(4 downto 0);
		-- num24		: out std_logic_vector(4 downto 0);
		-- num25		: out std_logic_vector(4 downto 0);
		-- num26		: out std_logic_vector(4 downto 0);
		-- num27		: out std_logic_vector(4 downto 0);
		-- num41		: out std_logic_vector(4 downto 0);
		-- num42		: out std_logic_vector(4 downto 0);
		-- num43		: out std_logic_vector(4 downto 0);
		-- num53		: out std_logic_vector(4 downto 0);
		-- num74		: out std_logic_vector(4 downto 0);
		-- num94		: out std_logic_vector(4 downto 0);
		-- num97		: out std_logic_vector(4 downto 0);
		clk			: in std_logic;
		reset		: in std_logic;
		vsync	 	: in std_logic;
--		data_in4b1	: in std_logic_vector(3 downto 0);
--		data_in4b2	: in std_logic_vector(3 downto 0);
--		data_out4b1	: out std_logic_vector(3 downto 0);
--		data_out4b2	: out std_logic_vector(3 downto 0);
--		data_in10b1	: in std_logic_vector(9 downto 0);  --knockback percentage
--		data_in10b2	: in std_logic_vector(9 downto 0);  --knockback percentage
--		data_out10b1	: out std_logic_vector(9 downto 0); --knockback percentage
--		data_out10b2	: out std_logic_vector(9 downto 0); --knockback percentage
		data_in8b1 		: in std_logic_vector(7 downto 0);
		data_in8b2		: in std_logic_vector(7 downto 0);
		data_in8b3		: in std_logic_vector(7 downto 0);
		data_in8b4		: in std_logic_vector(7 downto 0);
		-- data_in8b5		: in std_logic_vector(7 downto 0);
		-- data_in8b6		: in std_logic_vector(7 downto 0);
		-- data_in8b7		: in std_logic_vector(7 downto 0);
		-- data_in8b8		: in std_logic_vector(7 downto 0);
		data_out8b1		: out std_logic_vector(7 downto 0);
		data_out8b2		: out std_logic_vector(7 downto 0);
		data_out8b3		: out std_logic_vector(7 downto 0);
		data_out8b4		: out std_logic_vector(7 downto 0);
		-- data_out8b5		: out std_logic_vector(7 downto 0);
		-- data_out8b6		: out std_logic_vector(7 downto 0);
		-- data_out8b7		: out std_logic_vector(7 downto 0);
		-- data_out8b8		: out std_logic_vector(7 downto 0);
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

	component writelogic is 
	port(
		clk			: in std_logic;
		vsync		: in std_logic;
		write 		: out std_logic);
	end component writelogic;
	
	signal writeint : std_logic;

----	component ram_4b is
----	port(
----		clk			: in std_logic;
----				data_in 	: in std_logic_vector(3 downto 0);
----		data_out 	: out std_logic_vector(3 downto 0);
----		write 		: in std_logic);
----	end component ram_4b;
----	
----	component ram_10b is
----	port(
----		clk			: in std_logic;
----				data_in 	: in std_logic_vector(9 downto 0);
----		data_out 	: out std_logic_vector(9 downto 0);
----		write 		: in std_logic);
----	end component ram_10b;
	
	component ram_8b is
	port(
		clk			: in std_logic;
				data_in 	: in std_logic_vector(7 downto 0);
		data_out 	: out std_logic_vector(7 downto 0);
		write 		: in std_logic);
	end component ram_8b;
	
	component ram_9b is
	port(
		clk			: in std_logic;
				data_in 	: in std_logic_vector(8 downto 0);
		data_out 	: out std_logic_vector(8 downto 0);
		write 		: in std_logic);
	end component ram_9b;
	
		
begin
	
	WL00: writelogic port map (	clk			=> clk,
								vsync		=> vsync,
								write		=> writeint);
	
								
--	DM00 : ram_4b port map (	clk			=> clk,
--																data_in 	=> data_in4b1,
--								data_out 	=> data_out4b1,
--								write 		=> writeint);
--								
--	DM01 : ram_4b port map (	clk			=> clk,
--																data_in 	=> data_in4b2,
--								data_out 	=> data_out4b2,
--								write 		=> writeint);
--								
--	DM10 : ram_10b port map (	clk			=> clk,
--																data_in 	=> data_in10b1,
--								data_out 	=> data_out10b1,
--								write 		=> writeint);
--								
--	DM11 : ram_10b port map (	clk			=> clk,
--																data_in 	=> data_in10b2,
--								data_out 	=> data_out10b2,
--								write 		=> writeint);
--								
	DM20 : ram_8b port map (	clk			=> clk,
																data_in 	=> data_in8b1,
								data_out 	=> data_out8b1,
								write 		=> writeint);
								
	DM21 : ram_8b port map (	clk			=> clk,
																data_in 	=> data_in8b2,
								data_out 	=> data_out8b2,
								write 		=> writeint);
								
	DM22 : ram_8b port map (	clk			=> clk,
																data_in 	=> data_in8b3,
								data_out 	=> data_out8b3,
								write 		=> writeint);
								
	DM23 : ram_8b port map (	clk			=> clk,
																data_in 	=> data_in8b4,
								data_out 	=> data_out8b4,
								write 		=> writeint);
								
--	DM24 : ram_8b port map (	clk			=> clk,
--																data_in 	=> data_in8b5,
--								data_out 	=> data_out8b5,
--								write 		=> writeint);
--								
--	DM25 : ram_8b port map (	clk			=> clk,
--																data_in 	=> data_in8b6,
--								data_out 	=> data_out8b6,
--								write 		=> writeint);
--								
--	DM26 : ram_8b port map (	clk			=> clk,
--																data_in 	=> data_in8b7,
--								data_out 	=> data_out8b7,
--								write 		=> writeint);
--								
--	DM27 : ram_8b port map (	clk			=> clk,
--																data_in 	=> data_in8b8,
--								data_out 	=> data_out8b8,
--								write 		=> writeint);
	
	DM30 : ram_9b port map (	clk			=> clk,
																data_in 	=> data_in9b1,
								data_out 	=> data_out9b1,
								write 		=> writeint);
								
	DM31 : ram_9b port map (	clk			=> clk,
																data_in 	=> data_in9b2,
								data_out 	=> data_out9b2,
								write 		=> writeint);
								
	DM32 : ram_9b port map (	clk			=> clk,
																data_in 	=> data_in9b3,
								data_out 	=> data_out9b3,
								write 		=> writeint);
								
	DM33 : ram_9b port map (	clk			=> clk,
																data_in 	=> data_in9b4,
								data_out 	=> data_out9b4,
								write 		=> writeint);
								
								
end architecture structural;

configuration memory_structural_cfg of memory is
	for structural
for all: writelogic use configuration work.writelogic_behaviour_cfg;
      end for;
		for all: ram_4b use configuration work.ram_4b_behaviour_cfg;
		end for;
		for all: ram_10b use configuration work.ram_10b_behaviour_cfg;
		end for;
		for all: ram_8b use configuration work.ram_8b_behaviour_cfg;
		end for;
		for all: ram_9b use configuration work.ram_9b_behaviour_cfg;
		end for;
			end for;
end memory_structural_cfg;

