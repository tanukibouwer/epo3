-- 2 player version
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is 
port(
		clk		: in std_logic;
		reset		: in std_logic;
		resetp1		: in std_logic;
		resetp2		: in std_logic;
		vsync	 	: in std_logic;
		data_in4b1	: in std_logic_vector(3 downto 0);
		data_in4b2	: in std_logic_vector(3 downto 0);
		data_out4b1	: out std_logic_vector(3 downto 0);
		data_out4b2	: out std_logic_vector(3 downto 0);
		data_inhp1	: in std_logic_vector(7 downto 0); 
		data_inhp2	: in std_logic_vector(7 downto 0); 
		data_outhp1	: out std_logic_vector(7 downto 0); 
		data_outhp2	: out std_logic_vector(7 downto 0); 
		data_in8b1 		: in std_logic_vector(8 downto 0);
		data_in8b2		: in std_logic_vector(8 downto 0);
		data_in8b3		: in std_logic_vector(8 downto 0);
		data_in8b4		: in std_logic_vector(8 downto 0);
		data_out8b1		: out std_logic_vector(8 downto 0);
		data_out8b2		: out std_logic_vector(8 downto 0);
		data_out8b3		: out std_logic_vector(8 downto 0);
		data_out8b4		: out std_logic_vector(8 downto 0);
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

	component m_resethandler is
   	port(
		reset      : in  std_logic;
        		resetp1    : in  std_logic;
        		resetp2    : in  std_logic;
        		resetp1out : out std_logic;
        		resetp2out : out std_logic);
	end component m_resethandler;

	signal resetp1int : std_logic;
	signal resetp2int : std_logic;

	component writelogic is 
	port(
		clk			: in std_logic;
		reset		: in std_logic;
		vsync		: in std_logic;
		write 		: out std_logic);
	end component writelogic;
	
	signal writeint : std_logic;
	
	component ram_4b is
	port(
		clk			: in std_logic;
		reset		: in std_logic;
		data_in 	: in std_logic_vector(3 downto 0);
		data_out 	: out std_logic_vector(3 downto 0);
		write 		: in std_logic);
	end component ram_4b;
	
	component ram_8b is
	port(
		clk			: in std_logic;
		reset		: in std_logic;
		initial		: in std_logic_vector(7 downto 0);
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
	
		
begin

	RH00 : m_resethandler port map ( 	reset					=> reset,
					resetp1		=> resetp1,
					resetp2		=> resetp2,
					resetp1out		=> resetp1int,
					resetp2out		=> resetp2int);
	
	WL00 : writelogic port map (	clk			=> clk,
								reset		=> reset,
								vsync		=> vsync,
								write		=> writeint);
	
								
	DM00 : ram_4b port map (	clk			=> clk,
								reset		=> reset,
								data_in 	=> data_in4b1,
								data_out 	=> data_out4b1,
								write 		=> writeint);
								
	DM01 : ram_4b port map (	clk			=> clk,
								reset		=> reset,								
								data_in 	=> data_in4b2,
								data_out 	=> data_out4b2,
								write 		=> writeint);
								
	DM10 : ram_8b port map (	clk			=> clk,
								reset		=> resetp1int,
								initial		=> "00000000",
								data_in 	=> data_inhp1,
								data_out 	=> data_outhp1,
								write 		=> writeint);
								
	DM11 : ram_8b port map (	clk			=> clk,
								reset		=> resetp2int,
								initial		=> "00000000",
								data_in 	=> data_inhp2,
								data_out 	=> data_outhp2,
								write 		=> writeint);

								
	DM20 : ram_8b port map (	clk			=> clk,
								reset		=> resetp1int,
								initial		=> "00100011",
								data_in 	=> data_in8b1,
								data_out 	=> data_out8b1,
								write 		=> writeint);
								
	DM21 : ram_8b port map (	clk			=> clk,
								reset		=> resetp1int,
								initial		=> "00110010",
								data_in 	=> data_in8b2,
								data_out 	=> data_out8b2,
								write 		=> writeint);
								
	DM22 : ram_8b port map (	clk			=> clk,
								reset		=> resetp2int,
								initial		=> "01111101",
								data_in 	=> data_in8b3,
								data_out 	=> data_out8b3,
								write 		=> writeint);
								
	DM23 : ram_8b port map (	clk			=> clk,
								reset		=> resetp2int,
								initial		=> "00110010",
								data_in 	=> data_in8b4,
								data_out 	=> data_out8b4,
								write 		=> writeint);
	
	DM30 : ram_9b port map (	clk			=> clk,
								reset		=> resetp1int,
								data_in 	=> data_in9b1,
								data_out 	=> data_out9b1,
								write 		=> writeint);
								
	DM31 : ram_9b port map (	clk			=> clk,
								reset		=> resetp1int,
								data_in 	=> data_in9b2,
								data_out 	=> data_out9b2,
								write 		=> writeint);
								
	DM32 : ram_9b port map (	clk			=> clk,
								reset		=> resetp2int,
								data_in 	=> data_in9b3,
								data_out 	=> data_out9b3,
								write 		=> writeint);
								
	DM33 : ram_9b port map (	clk			=> clk,
								reset		=> resetp2int,
								data_in 	=> data_in9b4,
								data_out 	=> data_out9b4,
								write 		=> writeint);						
								
end architecture structural;