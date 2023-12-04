library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity h_player_movement is
   port(left_right_pressed : in std_logic_vector(1 downto 0); -- left_pressed & right_pressed
        out_h_target : out std_logic_vector(5 downto 0));
end h_player_movement;

architecture behaviour of h_player_movement is
   constant max_left_speed : std_logic_vector(5 downto 0) := "111011";
   constant max_right_speed : std_logic_vector(5 downto 0) := "000101";
   component physics_9bit_adder
      port(a      : in  std_logic_vector(8 downto 0);
           b      : in  std_logic_vector(8 downto 0);
           result : out std_logic_vector(8 downto 0));
   end component;
begin
   with left_right_pressed select
      out_h_target <= max_left_speed when "01", max_right_speed when "10", (others => '0') when others;   
end behaviour;

configuration h_player_movement_cfg of h_player_movement is
   for behaviour
   end for;
end h_player_movement_cfg;
