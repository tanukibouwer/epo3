library IEEE;
use IEEE.std_logic_1164.ALL;

entity h_player_movement_tb is
end h_player_movement_tb;

architecture structural of h_player_movement_tb is
   component h_player_movement is
      port(left_right_pressed : in std_logic_vector(1 downto 0); -- left_pressed & right_pressed
           out_h_target : out std_logic_vector(5 downto 0));
   end component;
   signal left_right_pressed : std_logic_Vector(1 downto 0);
   signal out_h_target : std_logic_vector(5 downto 0);
begin
   calculator : h_player_movement port map (left_right_pressed, out_h_target);
   left_right_pressed <= "00" after 0 ns,
                         "01" after 10 ns,
                         "10" after 20 ns,
                         "11" after 30 ns;
end structural;
