library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity chip_toplevel is
port (	
	-- general inputs
	clk				: in std_logic;
	reset			: in std_logic;
	-- input inputs
	p1_controller	: in std_logic_vector(7 downto 0);
	-- graphics outputs
	Vsync  : out std_logic; --! sync signals -> active low
    Hsync  : out std_logic; --! sync signals -> active low
    R_data : out std_logic;	--! RGB data to screen
    G_data : out std_logic; --! RGB data to screen
    B_data : out std_logic);--! RGB data to screen
end chip_toplevel;

architecture structural of chip_toplevel is

	-- signals for communication between memory and graphics+physics
	signal char1posx : std_logic_vector(7 downto 0); 
	signal char1posy : std_logic_vector(7 downto 0);
	signal char2posx : std_logic_vector(7 downto 0);
	signal char2posy : std_logic_vector(7 downto 0);
	
	-- between memory and graphics
	signal vsyncintern : std_logic;
	
	-- between memory and physics
	signal char1posxin : std_logic_vector(7 downto 0); 
	signal char1posyin : std_logic_vector(7 downto 0);
	signal char2posxin : std_logic_vector(7 downto 0);
	signal char2posyin : std_logic_vector(7 downto 0);
	signal char1velx : std_logic_vector(8 downto 0); 
	signal char1vely : std_logic_vector(8 downto 0);
	signal char2velx : std_logic_vector(8 downto 0);
	signal char2vely : std_logic_vector(8 downto 0);
	signal char1velxin : std_logic_vector(8 downto 0); 
	signal char1velyin : std_logic_vector(8 downto 0);
	signal char2velxin : std_logic_vector(8 downto 0);
	signal char2velyin : std_logic_vector(8 downto 0);
	
	-- between input and physics
	signal inputs	: std_logic_vector(7 downto 0)
	
	component graphics_card is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        -- inputs from memory -> relevant data to be displayed on screen
        char1_x : in std_logic_vector(7 downto 0); --! character 1 x-location
        char1_y : in std_logic_vector(7 downto 0); --! character 1 y-location
        char2_x : in std_logic_vector(7 downto 0); --! character 2 x-location
        char2_y : in std_logic_vector(7 downto 0); --! character 2 y-location
        -- outputs to screen (and other components)
        -- vcount : out std_logic_vector(9 downto 0);
        Vsync  : out std_logic; --! sync signals -> active low
        Hsync  : out std_logic; --! sync signals -> active low
        R_data : out std_logic; --! RGB data to screen
        G_data : out std_logic; --! RGB data to screen
        B_data : out std_logic);--! RGB data to screen
	end component graphics_card;
	
	component memory is
	port(	
		charhp		: out std_logic_vector(9 downto 0); -- initial knockback percentage so NOT character health!
		chardc		: out std_logic_vector(7 downto 0); -- initial character death count, may not be necessary
		char1sx		: out std_logic_vector(7 downto 0); -- char(acter)1 starting position x
		char1sy		: out std_logic_vector(7 downto 0); -- char1 starting position y
		char2sx		: out std_logic_vector(7 downto 0); -- char2 starting position x
		char2sy		: out std_logic_vector(7 downto 0); -- char2 starting position y
		char1vx		: out std_logic_vector(8 downto 0); -- char1 starting velocity x
		char1vy		: out std_logic_vector(8 downto 0); -- char1 starting velocity y
		char2vx		: out std_logic_vector(8 downto 0); -- char2 starting velocity x
		char2vy		: out std_logic_vector(8 downto 0); -- char2 starting velocity y
		chardx		: out std_logic_vector(3 downto 0); -- char size x (from center to edge)
		chardy		: out std_logic_vector(3 downto 0); -- char size y (from center to edge)
		att1dx		: out std_logic_vector(3 downto 0); -- attack1 size x (from center to edge)
		att1dy		: out std_logic_vector(3 downto 0); -- attack1 size y (from center to edge)
		att2dx		: out std_logic_vector(3 downto 0); -- attack2 size x (from center to edge)
		att2dy		: out std_logic_vector(3 downto 0); -- attack2 size y (from center to edge)
		att1dm		: out std_logic_vector(3 downto 0); -- attack1 damage
		att2dm		: out std_logic_vector(3 downto 0); -- attack2 damage
		-- att1kb		: out std_logic_vector(5 downto 0); -- attack1 knockback, currently unused
		-- att2kb		: out std_logic_vector(5 downto 0); -- attack2 knockback, currently unused
		plat1x		: out std_logic_vector(7 downto 0); -- plat(form)1 x position 
		plat1y		: out std_logic_vector(7 downto 0); -- plat1 y position
		plat2x		: out std_logic_vector(7 downto 0); -- plat2 x position
		plat2y		: out std_logic_vector(7 downto 0); -- plat2 y position
		plat3x		: out std_logic_vector(7 downto 0); -- plat3 x position
		plat3y		: out std_logic_vector(7 downto 0); -- plat3 y position
		plat4x		: out std_logic_vector(7 downto 0); -- plat4 x position
		plat4y		: out std_logic_vector(7 downto 0); -- plat4 y position
		plat1dx		: out std_logic_vector(7 downto 0); -- plat1 x size (center to edge)
		plat1dy		: out std_logic_vector(7 downto 0); -- plat1 y size (center to edge)
		plat2dx		: out std_logic_vector(7 downto 0); -- plat2 x size (center to edge)
		plat2dy		: out std_logic_vector(7 downto 0); -- plat2 y size (center to edge)
		plat3dx		: out std_logic_vector(7 downto 0); -- plat3 x size (center to edge)
		plat3dy		: out std_logic_vector(7 downto 0); -- plat3 y size (center to edge)
		plat4dx		: out std_logic_vector(7 downto 0); -- plat4 x size (center to edge)
		plat4dy		: out std_logic_vector(7 downto 0); -- plat4 y size (center to edge)
		kilznx1		: out std_logic_vector(7 downto 0); -- killzone location (left side)
		kilznx2		: out std_logic_vector(7 downto 0); -- killzone location (right side)
		kilzny1		: out std_logic_vector(7 downto 0); -- killzone location (top side)
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
		data_in4b1	: in std_logic_vector(3 downto 0); -- death count p1
		data_in4b2	: in std_logic_vector(3 downto 0); -- death count p2
		data_out4b1	: out std_logic_vector(3 downto 0); -- death count p1
		data_out4b2	: out std_logic_vector(3 downto 0); -- death count p2
		data_in10b1	: in std_logic_vector(9 downto 0);  --knockback percentage p1
		data_in10b2	: in std_logic_vector(9 downto 0);  --knockback percentage p2
		data_out10b1	: out std_logic_vector(9 downto 0); --knockback percentage p1
		data_out10b2	: out std_logic_vector(9 downto 0); --knockback percentage p2
		data_in8b1 		: in std_logic_vector(7 downto 0); -- x pos p1
		data_in8b2		: in std_logic_vector(7 downto 0); -- y pos p1
		data_in8b3		: in std_logic_vector(7 downto 0); -- x pos p2
		data_in8b4		: in std_logic_vector(7 downto 0); -- y pos p2
		-- data_in8b5		: in std_logic_vector(7 downto 0); -- x pos attack p1
		-- data_in8b6		: in std_logic_vector(7 downto 0); -- y pos attack p1
		-- data_in8b7		: in std_logic_vector(7 downto 0); -- x pos attack p2
		-- data_in8b8		: in std_logic_vector(7 downto 0); -- y pos attack p2
		data_out8b1		: out std_logic_vector(7 downto 0); -- x pos p1
		data_out8b2		: out std_logic_vector(7 downto 0); -- y pos p1
		data_out8b3		: out std_logic_vector(7 downto 0); -- x pos p2
		data_out8b4		: out std_logic_vector(7 downto 0); -- y pos p2
		-- data_out8b5		: out std_logic_vector(7 downto 0); -- x pos attack p1
		-- data_out8b6		: out std_logic_vector(7 downto 0); -- y pos attack p1
		-- data_out8b7		: out std_logic_vector(7 downto 0); -- x pos attack p2
		-- data_out8b8		: out std_logic_vector(7 downto 0); -- y pos attack p2
		data_in9b1		: in std_logic_vector(8 downto 0); -- x vel p1
		data_in9b2		: in std_logic_vector(8 downto 0); -- y vel p1
		data_in9b3		: in std_logic_vector(8 downto 0); -- x vel p2
		data_in9b4		: in std_logic_vector(8 downto 0); -- y vel p2
		data_out9b1		: out std_logic_vector(8 downto 0); -- x vel p1
		data_out9b2		: out std_logic_vector(8 downto 0); -- y vel p1
		data_out9b3		: out std_logic_vector(8 downto 0); -- x vel p2
		data_out9b4		: out std_logic_vector(8 downto 0)); -- y vel p2
	end component memory;




begin

	TL00 : memory port map (	
								clk		=> clk,
								reset	=> reset,
								vsync	=> vsyncintern,
								
								
								data_out8b1 => char1posx,
								data_out8b2 => char1posy,
								data_out8b3 => char2posx,
								data_out8b4 => char2posy,
								
								
								);
								
	TL01 : graphics_card port map (
								clk		=> clk,
								reset	=> reset,

								char1_x => char1posx,
								char1_y => char1posy,
								char2_x => char2posx,
								char2_y => char2posy,
								
								Vsync	=> vsyncintern,
								Hsync	=> Hsync,
								R_data	=> R_data,
								G_data	=> G_data,
								B_data	=> B_data);
								
								
	
	
	
	Vsync	<= vsyncintern; -- this is the only way I know to have an output signal also work as an internal one
	
end architecture structural;


