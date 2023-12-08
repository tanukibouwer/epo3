library IEEE;
use IEEE.std_logic_1164.ALL;

entity physics_system is
   port(vin_x : in std_logic_vector(8 downto 0);
        vin_y : in std_logic_vector(8 downto 0);
        pin_x : in std_logic_vector(7 downto 0);
        pin_y : in std_logic_vector(7 downto 0);
        player_input : in std_logic_Vector(7 downto 0);
        knockback_percentage : in std_logic_vector(7 downto 0);
        knockback_x : in std_logic_vector(7 downto 0);
        knockback_y : in std_logic_vector(7 downto 0);
        vout_x : out std_logic_vector(8 downto 0);
        vout_y : out std_logic_vector(8 downto 0);
        pout_x : out std_logic_vector(7 downto 0);
        pout_y : out std_logic_vector(7 downto 0));
end physics_system;

architecture behaviour of physics_system is
   component gravity
   	port(	velocity_in 	: in std_logic_vector (8 downto 0);
   			velocity_out	: out std_logic_vector (8 downto 0));
   end component;

   component p_knockback_calculator
      port(vin_x  : in  std_logic_vector(8 downto 0);
           vin_y  : in  std_logic_vector(8 downto 0);
   	knockback_percentage : in std_logic_vector(7 downto 0);
   	knockback_x : in std_logic_vector(7 downto 0);
   	knockback_y : in std_logic_vector(7 downto 0);
           vout_x : out std_logic_vector(8 downto 0);
           vout_y : out std_logic_vector(8 downto 0));
   end component;

   component jump_calculator
   	port(	collision_in	: in std_logic;
   			c_input			: in std_logic;
   			vin_y       	: in std_logic_vector (8 downto 0);
   			vout_y    		: out std_logic_vector (8 downto 0));
   end component;

   component collision_resolver
      port(vin_y      : in  std_logic_vector(8 downto 0);
           pin_x      : in  std_logic_vector(7 downto 0);
           pin_y      : in  std_logic_vector(7 downto 0);
           input_down : in  std_logic;
           vout_y     : out std_logic_vector(8 downto 0);
           pout_y     : out std_logic_vector(7 downto 0);
           on_floor   : out std_logic);
   end component;

   component velocity_interpolator is
      port(vin_x : in std_logic_vector(8 downto 0);
           vout_x : out std_logic_vector(8 downto 0);
           movement_target : in std_logic_vector(5 downto 0));
   end component;
   
   component h_player_movement is
      port(left_right_pressed : in std_logic_vector(1 downto 0); -- left_pressed & right_pressed
           out_h_target : out std_logic_vector(5 downto 0));
   end component;
   
   component position_adder
      port(vin_x  : in  std_logic_vector(8 downto 0);
           vin_y  : in  std_logic_vector(8 downto 0);
           pin_x  : in  std_logic_vector(7 downto 0);
           pin_y  : in  std_logic_vector(7 downto 0);
           pout_x : out std_logic_vector(7 downto 0);
           pout_y : out std_logic_vector(7 downto 0));
   end component;

   signal knockback_vout_x : std_logic_vector(8 downto 0);
   signal knockback_vout_y : std_logic_vector(8 downto 0);
   signal collision_vout_y : std_logic_vector(8 downto 0);
   signal collision_on_floor : std_logic;
   signal interpolator_vout_x : std_logic_vector(8 downto 0);
   signal movement_target : std_logic_vector(5 downto 0);
   signal gravity_vout_y : std_logic_vector(8 downto 0);
   signal adder_pout_x : std_logic_vector(7 downto 0);
   signal adder_pout_y : std_logic_vector(7 downto 0);
   signal jump_input : std_logic;
   signal down_input : std_logic;

begin
   jump_input <= '1' when player_input(2 downto 2) = "1" else '0';
   down_input <= '1' when player_input(3 downto 3) = "1" else '0';
   knockback : p_knockback_calculator port map (vin_x, vin_y, knockback_percentage, knockback_x, knockback_y, vout_x => knockback_vout_x, vout_y => knockback_vout_y);
   h_movement_calculator : h_player_movement port map (left_right_pressed => player_input(1 downto 0), out_h_target => movement_target);
   interpolator : velocity_interpolator port map (vin_x => knockback_vout_x, vout_x => interpolator_vout_x, movement_target => movement_target);
   grav : gravity port map (velocity_in => knockback_vout_y, velocity_out => gravity_vout_y); 
   p_adder : position_adder port map (vin_x => interpolator_vout_x, vin_y => gravity_vout_y, pin_x => pin_x, pin_y => pin_y, pout_x => adder_pout_x, pout_y => adder_pout_y);
   resolver : collision_resolver port map (vin_y => gravity_vout_y, pin_x => adder_pout_x, pin_y => adder_pout_y, input_down => down_input, vout_y => collision_vout_y, pout_y => pout_y, on_floor => collision_on_floor);
   jump_calc : jump_calculator port map (collision_in => collision_on_floor, c_input => jump_input, vin_y => collision_vout_y, vout_y => vout_y);
   
   vout_x <= interpolator_vout_x;
   pout_x <= adder_pout_x;
end behaviour;
