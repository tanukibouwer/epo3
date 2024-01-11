library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity physics_top is
port (		clk					 : in std_logic;
			reset				 : in std_logic;
			vcount 				 : in std_logic_vector(9 downto 0);
			hcount 				 : in std_logic_vector(9 downto 0);
            vin_x                : in std_logic_vector(9 downto 0);
            vin_y                : in std_logic_vector(9 downto 0);
            pin_x                : in std_logic_vector(8 downto 0);
            pin_y                : in std_logic_vector(8 downto 0);
            player_input         : in std_logic_vector(7 downto 0);
            knockback_percentage : in std_logic_vector(7 downto 0);
            knockback_x          : in std_logic_vector(7 downto 0);
            knockback_y          : in std_logic_vector(7 downto 0);
            vout_x               : out std_logic_vector(9 downto 0);
            vout_y               : out std_logic_vector(9 downto 0);
            pout_x               : out std_logic_vector(8 downto 0);
            pout_y               : out std_logic_vector(8 downto 0);
			vin_x2               : in std_logic_vector(9 downto 0);
            vin_y2               : in std_logic_vector(9 downto 0);
            pin_x2                : in std_logic_vector(8 downto 0);
            pin_y2                : in std_logic_vector(8 downto 0);
            player2_input         : in std_logic_vector(7 downto 0);
            knockback_percentage2 : in std_logic_vector(7 downto 0);
            knockback_x2          : in std_logic_vector(7 downto 0);
            knockback_y2          : in std_logic_vector(7 downto 0);
            vout_x2               : out std_logic_vector(9 downto 0);
            vout_y2               : out std_logic_vector(9 downto 0);
            pout_x2               : out std_logic_vector(8 downto 0);
            pout_y2               : out std_logic_vector(8 downto 0));
end entity physics_top;

architecture structural of physics_top is
	signal ipx	: std_logic_vector(8 downto 0);
	signal ipy	: std_logic_vector(8 downto 0);
	signal ivx	: std_logic_vector(9 downto 0);
	signal ivy	: std_logic_vector(9 downto 0);
	signal opx	: std_logic_vector(8 downto 0);
	signal opy	: std_logic_vector(8 downto 0);
	signal ovx	: std_logic_vector(9 downto 0);
	signal ovy	: std_logic_vector(9 downto 0);
	signal pl_in : std_logic_vector(7 downto 0);
	signal kb_pc : std_logic_vector(7 downto 0);
    signal kb_x : std_logic_vector(8 downto 0);
    signal kb_y : std_logic_vector(8 downto 0);

	component p_mux is
    port(
	clk		: in std_logic;
	reset	: in std_logic;
	
	-- vcount goes to 524, half of that is 262
	
	vcount : in std_logic_vector(9 downto 0);
	hcount : in std_logic_vector(9 downto 0);
	
	-- inputs from input module
	
	inputsp1 : in std_logic_vector(7 downto 0);
	inputsp2 : in std_logic_vector(7 downto 0);
	
    -- inputs from the attack module
	
	directionx1out       : in std_logic_vector(7 downto 0);
    directiony1out       : in std_logic_vector(7 downto 0);
	char1perctemp 		: in std_logic_vector(7 downto 0);
	
    directionx2out       : in std_logic_vector(7 downto 0);
    directiony2out       : in std_logic_vector(7 downto 0);
	char2perctemp 		: in std_logic_vector(7 downto 0);
	
	-- inputs and outputs from the memory module
	
	data_in8b1  : out std_logic_vector(8 downto 0);
    data_in8b2  : out std_logic_vector(8 downto 0);
    data_in8b3  : out std_logic_vector(8 downto 0);
    data_in8b4  : out std_logic_vector(8 downto 0);
	
    data_out8b1 : in std_logic_vector(8 downto 0);
    data_out8b2 : in std_logic_vector(8 downto 0);
    data_out8b3 : in std_logic_vector(8 downto 0);
    data_out8b4 : in std_logic_vector(8 downto 0);
	
    data_in9b1  : out std_logic_vector(9 downto 0);
    data_in9b2  : out std_logic_vector(9 downto 0);
    data_in9b3  : out std_logic_vector(9 downto 0);
    data_in9b4  : out std_logic_vector(9 downto 0);
	
    data_out9b1 : in std_logic_vector(9 downto 0);
    data_out9b2 : in std_logic_vector(9 downto 0);
    data_out9b3 : in std_logic_vector(9 downto 0);
    data_out9b4 : in std_logic_vector(9 downto 0);
	
	-- inputs and outputs from the physics module
	
	vin_x                : out std_logic_vector(9 downto 0);
    vin_y                : out std_logic_vector(9 downto 0);
    pin_x                : out std_logic_vector(8 downto 0);
    pin_y                : out std_logic_vector(8 downto 0);
    player_input         : out std_logic_vector(7 downto 0);
	knockback_percentage : out std_logic_vector(7 downto 0);
    knockback_x          : out std_logic_vector(8 downto 0);
    knockback_y          : out std_logic_vector(8 downto 0);
    vout_x               : in std_logic_vector(9 downto 0);
    vout_y               : in std_logic_vector(9 downto 0);
    pout_x               : in std_logic_vector(8 downto 0);
    pout_y               : in std_logic_vector(8 downto 0));

	end component p_mux;
	
	component physics_system is
	port(vin_x : in std_logic_vector(9 downto 0);
        vin_y : in std_logic_vector(9 downto 0);
        pin_x : in std_logic_vector(8 downto 0);
        pin_y : in std_logic_vector(8 downto 0);
        player_input : in std_logic_Vector(7 downto 0);
        knockback_percentage : in std_logic_vector(7 downto 0);
        knockback_x : in std_logic_vector(7 downto 0);
        knockback_y : in std_logic_vector(7 downto 0);
        vout_x : out std_logic_vector(9 downto 0);
        vout_y : out std_logic_vector(9 downto 0);
        pout_x : out std_logic_vector(8 downto 0);
        pout_y : out std_logic_vector(8 downto 0));
	end component physics_system;
	
begin

	PHS0 :	p_mux port map (
			clk					=> clk,
			reset				=> reset,
			vcount				=> vcount,
			hcount				=> hcount,
			
			inputsp1			=> player_input,
			directionx1out		=> knockback_x,
			directiony1out		=> knockback_y,
			char1perctemp		=> knockback_percentage,
			
			data_in8b1			=> pout_x,
			data_in8b2			=> pout_y,
			data_in9b1			=> vout_x,
			data_in9b2			=> vout_y,
			
			data_out8b1			=> pin_x,
			data_out8b2			=> pin_y,
			data_out9b1			=> vin_x,
			data_out9b2			=> vin_y,
			
			inputsp2			=> player2_input,
			directionx2out		=> knockback_x2,
			directiony2out		=> knockback_y2,
			char2perctemp		=> knockback_percentage2,
			
			data_in8b3			=> pout_x2,
			data_in8b4			=> pout_y2,
			data_in9b3			=> vout_x2,
			data_in9b4			=> vout_y2,
			
			data_out8b3			=> pin_x2,
			data_out8b4			=> pin_y2,
			data_out9b3			=> vin_x2,
			data_out9b4			=> vin_y2,
			
			vin_x           	=> ivx,
			vin_y            	=> ivy,
			pin_x             	=> ipx,
			pin_y            	=> ipy,
			player_input       	=> pl_in,
			knockback_percentage	=> kb_pc,
			knockback_x        	=> kb_x,
			knockback_y        	=> kb_y,
			vout_x           	=> ovx,
			vout_y         		=> ovy,
			pout_x            	=> opx,
			pout_y              => opy);
			
	PHS1 : physics_system port map (
			vin_x           	=> ivx,
			vin_y            	=> ivy,
			pin_x             	=> ipx,
			pin_y            	=> ipy,
			player_input       	=> pl_in,
			knockback_percentage	=> kb_pc,
			knockback_x        	=> kb_x,
			knockback_y        	=> kb_y,
			vout_x           	=> ovx,
			vout_y         		=> ovy,
			pout_x            	=> opx,
			pout_y              => opy);
			
end architecture structural;
			