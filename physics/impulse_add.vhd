library IEEE;
use IEEE.std_logic_1164.ALL;

entity p_impulse_add is
   port(vin_x     : in  std_logic_vector(8 downto 0);
        vin_y     : in  std_logic_vector(8 downto 0);
        impulse_x : in  std_logic_vector(8 downto 0);
        impulse_y : in  std_logic_vector(8 downto 0);
        vout_x    : out std_logic_vector(8 downto 0);
        vout_y    : out std_logic_vector(8 downto 0));
end p_impulse_add;

architecture behaviour of p_impulse_add is
   component physics_9bit_adder
      port(a      : in  std_logic_vector(8 downto 0);
           b      : in  std_logic_vector(8 downto 0);
           result : out std_logic_vector(8 downto 0));
   end component;
begin
   x_adder : physics_9bit_adder port map (vin_x, impulse_x, vout_x);
   y_adder : physics_9bit_adder port map (vin_y, impulse_y, vout_y);
end behaviour;

configuration p_impulse_add_behaviour_cfg of p_impulse_add is
   for behaviour
      for all: physics_9bit_adder use configuration work.physics_9bit_adder_behaviour_cfg;
      end for;
   end for;
end p_impulse_add_behaviour_cfg;
