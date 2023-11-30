library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity chip_toplevel is
    port (
        -- general inputs
        clk   : in std_logic;
        reset : in std_logic;
        -- input inputs
        p1_controller : in std_logic_vector(7 downto 0);
		p2_controller : in std_logic_vector(7 downto 0);
        -- graphics outputs
        Vsync  : out std_logic; --! sync signals -> active low
        Hsync  : out std_logic; --! sync signals -> active low
        R_data : out std_logic; --! RGB data to screen
        G_data : out std_logic; --! RGB data to screen
        B_data : out std_logic --! RGB data to screen
    );
end chip_toplevel;

architecture structural of chip_toplevel is

    -- signals for communication between memory and graphics+physics
    signal char1posx : std_logic_vector(7 downto 0); -- output from memory, into graphics and physics
    signal char1posy : std_logic_vector(7 downto 0); -- output from memory, into graphics and physics
    signal char2posx : std_logic_vector(7 downto 0); -- output from memory, into graphics and physics
    signal char2posy : std_logic_vector(7 downto 0); -- output from memory, into graphics and physics

    -- between memory and graphics
    signal vsyncintern : std_logic; -- input into memory, out from graphics

    -- between memory and physics 
    signal char1posxin : std_logic_vector(7 downto 0); -- inputs into memory, out from physics
    signal char1posyin : std_logic_vector(7 downto 0); -- inputs into memory, out from physics
    signal char2posxin : std_logic_vector(7 downto 0); -- inputs into memory, out from physics
    signal char2posyin : std_logic_vector(7 downto 0); -- inputs into memory, out from physics
    signal char1velx   : std_logic_vector(8 downto 0); -- output from memory, into physics
    signal char1vely   : std_logic_vector(8 downto 0); -- output from memory, into physics
    signal char2velx   : std_logic_vector(8 downto 0); -- output from memory, into physics
    signal char2vely   : std_logic_vector(8 downto 0); -- output from memory, into physics
    signal char1velxin : std_logic_vector(8 downto 0); -- inputs into memory, out from physics
    signal char1velyin : std_logic_vector(8 downto 0); -- inputs into memory, out from physics
    signal char2velxin : std_logic_vector(8 downto 0); -- inputs into memory, out from physics
    signal char2velyin : std_logic_vector(8 downto 0); -- inputs into memory, out from physics

    -- between input and physics
    signal inputsp1 : std_logic_vector(7 downto 0); -- inputs from input, into physics
	signal inputsp2 : std_logic_vector(7 downto 0); -- inputs from input, into physics
	
	-- dummy signal that should be linked to the counter through an fsm or something like that
	signal readyphysicsin 	: std_logic;
	signal readyphysicsout 	: std_logic;
	
	component physics_fsm is
		port(
			clk : in std_logic;
			reset : in std_logic;
			ready_in : in std_logic;
			vin_x : in std_logic_vector(8 downto 0);
			vin_y : in std_logic_vector(8 downto 0);
			pin_x : in std_logic_vector(7 downto 0);
			pin_y : in std_logic_vector(7 downto 0);
			player_input : in std_logic_Vector(7 downto 0);
			vout_x : out std_logic_vector(8 downto 0);
			vout_y : out std_logic_vector(8 downto 0);
			pout_x : out std_logic_vector(7 downto 0);
			pout_y : out std_logic_vector(7 downto 0);
			ready_out : out std_logic);
	end component physics_fsm;

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
        port (
            --charhp  : out std_logic_vector(9 downto 0); -- initial knockback percentage so NOT character health!
            --chardc  : out std_logic_vector(7 downto 0); -- initial character death count, may not be necessary
            char1sx : out std_logic_vector(7 downto 0); -- char(acter)1 starting position x
            char1sy : out std_logic_vector(7 downto 0); -- char1 starting position y
			--char2sx : out std_logic_vector(7 downto 0); -- char2 starting position x
            --char2sy : out std_logic_vector(7 downto 0); -- char2 starting position y
            char1vx : out std_logic_vector(8 downto 0); -- char1 starting velocity x
            char1vy : out std_logic_vector(8 downto 0); -- char1 starting velocity y
            --char2vx : out std_logic_vector(8 downto 0); -- char2 starting velocity x
            --char2vy : out std_logic_vector(8 downto 0); -- char2 starting velocity y
            chardx  : out std_logic_vector(3 downto 0); -- char size x (from center to edge)
            chardy  : out std_logic_vector(3 downto 0); -- char size y (from center to edge)
            att1dx  : out std_logic_vector(3 downto 0); -- attack1 size x (from center to edge)
            att1dy  : out std_logic_vector(3 downto 0); -- attack1 size y (from center to edge)
            att2dx  : out std_logic_vector(3 downto 0); -- attack2 size x (from center to edge)
            att2dy  : out std_logic_vector(3 downto 0); -- attack2 size y (from center to edge)
            att1dm  : out std_logic_vector(3 downto 0); -- attack1 damage
            att2dm  : out std_logic_vector(3 downto 0); -- attack2 damage
            -- att1kb		: out std_logic_vector(5 downto 0); -- attack1 knockback, currently unused
            -- att2kb		: out std_logic_vector(5 downto 0); -- attack2 knockback, currently unused
            plat1x  : out std_logic_vector(7 downto 0); -- plat(form)1 x position 
            plat1y  : out std_logic_vector(7 downto 0); -- plat1 y position
            plat2x  : out std_logic_vector(7 downto 0); -- plat2 x position
            plat2y  : out std_logic_vector(7 downto 0); -- plat2 y position
            plat3x  : out std_logic_vector(7 downto 0); -- plat3 x position
            plat3y  : out std_logic_vector(7 downto 0); -- plat3 y position
            plat4x  : out std_logic_vector(7 downto 0); -- plat4 x position
            plat4y  : out std_logic_vector(7 downto 0); -- plat4 y position
            plat1dx : out std_logic_vector(7 downto 0); -- plat1 x size (center to edge)
            plat1dy : out std_logic_vector(7 downto 0); -- plat1 y size (center to edge)
            plat2dx : out std_logic_vector(7 downto 0); -- plat2 x size (center to edge)
            plat2dy : out std_logic_vector(7 downto 0); -- plat2 y size (center to edge)
            plat3dx : out std_logic_vector(7 downto 0); -- plat3 x size (center to edge)
            plat3dy : out std_logic_vector(7 downto 0); -- plat3 y size (center to edge)
            plat4dx : out std_logic_vector(7 downto 0); -- plat4 x size (center to edge)
            plat4dy : out std_logic_vector(7 downto 0); -- plat4 y size (center to edge)
            kilznx1 : out std_logic_vector(7 downto 0); -- killzone location (left side)
            kilznx2 : out std_logic_vector(7 downto 0); -- killzone location (right side)
            kilzny1 : out std_logic_vector(7 downto 0); -- killzone location (top side)
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
            clk          : in std_logic;
            reset        : in std_logic;
            vsync        : in std_logic;
            --data_in4b1   : in std_logic_vector(3 downto 0); -- death count p1
            --data_in4b2   : in std_logic_vector(3 downto 0); -- death count p2
            --data_out4b1  : out std_logic_vector(3 downto 0); -- death count p1
            --data_out4b2  : out std_logic_vector(3 downto 0); -- death count p2
            --data_in10b1  : in std_logic_vector(9 downto 0); --knockback percentage p1
            --data_in10b2  : in std_logic_vector(9 downto 0); --knockback percentage p2
            --data_out10b1 : out std_logic_vector(9 downto 0); --knockback percentage p1
            --data_out10b2 : out std_logic_vector(9 downto 0); --knockback percentage p2
            data_in8b1   : in std_logic_vector(7 downto 0); -- x pos p1
            data_in8b2   : in std_logic_vector(7 downto 0); -- y pos p1
            data_in8b3   : in std_logic_vector(7 downto 0); -- x pos p2
            data_in8b4   : in std_logic_vector(7 downto 0); -- y pos p2
            -- data_in8b5		: in std_logic_vector(7 downto 0); -- x pos attack p1
            -- data_in8b6		: in std_logic_vector(7 downto 0); -- y pos attack p1
            -- data_in8b7		: in std_logic_vector(7 downto 0); -- x pos attack p2
            -- data_in8b8		: in std_logic_vector(7 downto 0); -- y pos attack p2
            data_out8b1 : out std_logic_vector(7 downto 0); -- x pos p1
            data_out8b2 : out std_logic_vector(7 downto 0); -- y pos p1
            data_out8b3 : out std_logic_vector(7 downto 0); -- x pos p2
            data_out8b4 : out std_logic_vector(7 downto 0); -- y pos p2
            -- data_out8b5		: out std_logic_vector(7 downto 0); -- x pos attack p1
            -- data_out8b6		: out std_logic_vector(7 downto 0); -- y pos attack p1
            -- data_out8b7		: out std_logic_vector(7 downto 0); -- x pos attack p2
            -- data_out8b8		: out std_logic_vector(7 downto 0); -- y pos attack p2
            data_in9b1  : in std_logic_vector(8 downto 0); -- x vel p1
            data_in9b2  : in std_logic_vector(8 downto 0); -- y vel p1
            data_in9b3  : in std_logic_vector(8 downto 0); -- x vel p2
            data_in9b4  : in std_logic_vector(8 downto 0); -- y vel p2
            data_out9b1 : out std_logic_vector(8 downto 0); -- x vel p1
            data_out9b2 : out std_logic_vector(8 downto 0); -- y vel p1
            data_out9b3 : out std_logic_vector(8 downto 0); -- x vel p2
            data_out9b4 : out std_logic_vector(8 downto 0)); -- y vel p2
    end component memory;
begin

    TL00 : memory port map(
        clk         => clk,
        reset       => reset,
        vsync       => vsyncintern,
		
		--location
		data_in8b1	=> char1posxin,
		data_in8b2	=> char1posyin,
		data_in8b3	=> char2posxin,
		data_in8b4	=> char2posyin,
        data_out8b1 => char1posx,
        data_out8b2 => char1posy,
        data_out8b3 => char2posx,
        data_out8b4 => char2posy,
		
		--velocity
		data_in9b1	=> char1velxin,
		data_in9b2	=> char1velyin,
		data_in9b3	=> char2velxin,
		data_in9b4	=> char2velyin,
		data_out9b1	=> char1velx,
		data_out9b2	=> char1vely,
		data_out9b3	=> char2velx,
		data_out9b4	=> char2vely,
		
    );

    TL01 : graphics_card port map(
        clk   => clk,
        reset => reset,

        char1_x => char1posx,
        char1_y => char1posy,
        char2_x => char2posx,
        char2_y => char2posy,

        Vsync  => vsyncintern,
        Hsync  => Hsync,
        R_data => R_data,
        G_data => G_data,
        B_data => B_data);

	TL02 : physics_fsm port map (
		clk         => clk,
        reset       => reset,
		
		ready_in	=> readyphysicsin, --idk how these work exactly
		ready_out	=> readyphysicsout,
		
		vin_x		=> char1velx,
		vin_y		=> char1vely,
		pin_x		=> char1posx,
		pin_y		=> char1posy,
		
		player_input => inputsp1,
		
		vout_x		=> char1velxin,
		vout_y		=> char1velyin,
		pout_x		=> char1posxin,
		pout_y		=> char1posyin);
		
	TL03 : physics_fsm port map (
		clk         => clk,
        reset       => reset,
		
		ready_in	=> readyphysicsin, --idk how these work exactly
		ready_out	=> readyphysicsout,
		
		vin_x		=> char2velx,
		vin_y		=> char2vely,
		pin_x		=> char2posx,
		pin_y		=> char2posy,
		
		player_input => inputsp2,
		
		vout_x		=> char2velxin,
		vout_y		=> char2velyin,
		pout_x		=> char2posxin,
		pout_y		=> char2posyin);
		
    Vsync <= vsyncintern; -- this is the only way I know to have an output signal also work as an internal one

end architecture structural;