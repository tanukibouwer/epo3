library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity collision_resolver is
   port(vin_y      : in  std_logic_vector(8 downto 0);
        pin_x      : in  std_logic_vector(7 downto 0);
        pin_y      : in  std_logic_vector(7 downto 0);
        input_down : in  std_logic;
        vout_y     : out std_logic_vector(8 downto 0);
        pout_y     : out std_logic_vector(7 downto 0);
        on_floor   : out std_logic);
end collision_resolver;

architecture behaviour of collision_resolver is

constant player_half_size_x : unsigned(7 downto 0) := to_unsigned(4, 8);
constant player_half_size_y : unsigned(7 downto 0) := to_unsigned(6, 8);

constant platform1_left_x : unsigned(7 downto 0) := to_unsigned(9, 8); -- 10
constant platform1_right_x : unsigned(7 downto 0) := to_unsigned(60, 8); -- 59
constant platform1_up_y : unsigned(7 downto 0) := to_unsigned(73, 8); -- 74
constant platform1_placement_y : unsigned(7 downto 0) := to_unsigned(68, 8); -- -6;
constant platform1_down_y : unsigned(7 downto 0) := to_unsigned(86, 8); -- 85
constant platform2_left_x : unsigned(7 downto 0) := to_unsigned(99, 8); -- 100
constant platform2_right_x : unsigned(7 downto 0) := to_unsigned(150, 8); -- 149
constant platform2_up_y : unsigned(7 downto 0) := to_unsigned(73, 8); -- 74
constant platform2_placement_y : unsigned(7 downto 0) := to_unsigned(68, 8); -- -6;
constant platform2_down_y : unsigned(7 downto 0) := to_unsigned(86, 8); -- 85
constant platform3_left_x : unsigned(7 downto 0) := to_unsigned(54, 8); -- 55
constant platform3_right_x : unsigned(7 downto 0) := to_unsigned(105, 8); -- 104
constant platform3_up_y : unsigned(7 downto 0) := to_unsigned(42, 8); -- 43
constant platform3_placement_y : unsigned(7 downto 0) := to_unsigned(37, 8); -- -6;
constant platform3_down_y : unsigned(7 downto 0) := to_unsigned(55, 8); -- 54
constant floor_y : unsigned(7 downto 0) := to_unsigned(101, 8); -- 107 - player_half_size.

begin
resolver : process (vin_y, pin_x, pin_y, input_down) is
variable player_left_x : unsigned(7 downto 0) := to_unsigned(0, 8);
variable player_up_y : unsigned(7 downto 0) := to_unsigned(0, 8);
variable player_right_x : unsigned(7 downto 0) := to_unsigned(0, 8);
variable player_down_y : unsigned(7 downto 0) := to_unsigned(0, 8);
variable going_down : std_logic := '0';
begin

player_left_x := unsigned(pin_x) - player_half_size_x;
player_right_x := unsigned(pin_x) + player_half_size_x;
player_up_y := unsigned(pin_y) - player_half_size_y;
player_down_y := unsigned(pin_y) + player_half_size_y;

if signed(vin_y) > to_signed(0, 8) then
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
elsif unsigned(pin_y) > floor_y and unsigned(pin_y) > to_unsigned(3, 2) then -- Prevent integer underflow
   pout_y <= std_logic_vector(floor_y);
   vout_y <= (others => '0');
   on_floor <= '1';
else
   pout_y <= pin_y;
   vout_y <= vin_y;
   on_floor <= '0';
end if;
end process;
end behaviour;
