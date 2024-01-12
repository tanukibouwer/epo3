library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity collision_resolver is
   port(vin_y      : in  std_logic_vector(9 downto 0);
        pin_x      : in  std_logic_vector(8 downto 0);
        pin_y      : in  std_logic_vector(8 downto 0);
        input_down : in  std_logic;
        vout_y     : out std_logic_vector(9 downto 0);
        pout_y     : out std_logic_vector(8 downto 0);
        on_floor   : out std_logic);
end collision_resolver;

architecture behaviour of collision_resolver is

constant player_half_size_x : unsigned(8 downto 0) := to_unsigned(8, 9);
constant player_half_size_y : unsigned(8 downto 0) := to_unsigned(12, 9);

constant platform1_left_x : unsigned(8 downto 0) := to_unsigned(34, 9); -- 10
constant platform1_right_x : unsigned(8 downto 0) := to_unsigned(136, 9); -- 59
constant platform1_up_y : unsigned(8 downto 0) := to_unsigned(156, 9); -- 74
constant platform1_placement_y : unsigned(8 downto 0) := to_unsigned(144, 9); -- -6;
constant platform1_down_y : unsigned(8 downto 0) := to_unsigned(182, 9); -- 85
constant platform2_left_x : unsigned(8 downto 0) := to_unsigned(214, 9); -- 100
constant platform2_right_x : unsigned(8 downto 0) := to_unsigned(316, 9); -- 149
constant platform2_up_y : unsigned(8 downto 0) := to_unsigned(156, 9); -- 74
constant platform2_placement_y : unsigned(8 downto 0) := to_unsigned(144, 9); -- -6;
constant platform2_down_y : unsigned(8 downto 0) := to_unsigned(182, 9); -- 85
constant platform3_left_x : unsigned(8 downto 0) := to_unsigned(124, 9); -- 55
constant platform3_right_x : unsigned(8 downto 0) := to_unsigned(226, 9); -- 104
constant platform3_up_y : unsigned(8 downto 0) := to_unsigned(90, 9); -- 43
constant platform3_placement_y : unsigned(8 downto 0) := to_unsigned(78, 9); -- -6;
constant platform3_down_y : unsigned(8 downto 0) := to_unsigned(116, 9); -- 54
constant floor_y_up : unsigned(8 downto 0) := to_unsigned(202, 9); -- 214 - player_half_size.
constant floor_y_down : unsigned (8 downto 0) := to_unsigned(276, 9); -- 288 - player_half_size.

begin
resolver : process (vin_y, pin_x, pin_y, input_down) is
variable player_left_x : unsigned(8 downto 0) := to_unsigned(0, 9);
variable player_up_y : unsigned(8 downto 0) := to_unsigned(0, 9);
variable player_right_x : unsigned(8 downto 0) := to_unsigned(0, 9);
variable player_down_y : unsigned(8 downto 0) := to_unsigned(0, 9);
variable going_down : std_logic := '0';
begin

player_left_x := unsigned(pin_x) - player_half_size_x;
player_right_x := unsigned(pin_x) + player_half_size_x;
player_up_y := unsigned(pin_y) - player_half_size_y;
player_down_y := unsigned(pin_y) + player_half_size_y;

if signed(vin_y) > to_signed(0, 9) then
   going_down := '1';
else
   going_down := '0';
end if;

if (player_down_y > platform1_up_y and player_down_y < platform1_down_y) and 
   ((player_left_x > platform1_left_x and player_left_x < platform1_right_x) or
    (player_right_x > platform1_left_x and player_right_x < platform1_right_x)) and 
   going_down = '1' and
   input_down = '0' then
   pout_y <= std_logic_vector(platform1_placement_y);
   vout_y <= (others => '0');
   on_floor <= '1';
elsif (player_down_y > platform2_up_y and player_down_y < platform2_down_y) and 
   ((player_left_x > platform2_left_x and player_left_x < platform2_right_x) or
   (player_right_x > platform2_left_x and player_right_x < platform2_right_x)) and
   going_down = '1' and
   input_down = '0' then
   pout_y <= std_logic_vector(platform2_placement_y);
   vout_y <= (others => '0');
   on_floor <= '1';
elsif (player_down_y > platform3_up_y and player_down_y < platform3_down_y) and 
   ((player_left_x > platform3_left_x and player_left_x < platform3_right_x) or
   (player_right_x > platform3_left_x and player_right_x < platform3_right_x)) and
   going_down = '1' and
   input_down = '0' then
   pout_y <= std_logic_vector(platform3_placement_y);
   vout_y <= (others => '0');
   on_floor <= '1';
elsif unsigned(pin_y) > floor_y_up and unsigned(pin_y) < floor_y_down then -- Prevent integer underflow
   pout_y <= std_logic_vector(floor_y_up);
   vout_y <= (others => '0');
   on_floor <= '1';
else
   pout_y <= pin_y;
   vout_y <= vin_y;
   on_floor <= '0';
end if;
end process;
end behaviour;
