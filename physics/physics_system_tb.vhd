library IEEE;
use IEEE.std_logic_1164.ALL;

entity physics_system_tb is
end physics_system_tb;


library IEEE;
use IEEE.std_logic_1164.ALL;

architecture behaviour of physics_system_tb is
   component physics_system
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
   end component;
   signal vin_x : std_logic_vector(8 downto 0);
   signal vin_y : std_logic_vector(8 downto 0);
   signal pin_x : std_logic_vector(7 downto 0);
   signal pin_y : std_logic_vector(7 downto 0);
   signal player_input : std_logic_Vector(7 downto 0);
   signal knockback_percentage : std_logic_vector(7 downto 0);
   signal knockback_x : std_logic_vector(7 downto 0);
   signal knockback_y : std_logic_vector(7 downto 0);
   signal vout_x : std_logic_vector(8 downto 0);
   signal vout_y : std_logic_vector(8 downto 0);
   signal pout_x : std_logic_vector(7 downto 0);
   signal pout_y : std_logic_vector(7 downto 0);
begin
   test: physics_system port map (vin_x, vin_y, pin_x, pin_y, player_input, knockback_percentage, knockback_x, knockback_y,
         vout_x, vout_y, pout_x, pout_y);
   player_input <= "00000000" after 0 ns,
                   "10000000" after 180 ns,
                   "01000000" after 240 ns,
                   "11000000" after 300 ns;
   vin_x <= "000000000" after 0 ns,
            "010101011" after 180 ns,
            "111101110" after 240 ns,
            "000000001" after 300 ns,
            "111111111" after 360 ns;
   vin_y <= (others => '0');
   pin_x <= (others => '0');
   pin_y <= (others => '0');
   knockback_percentage <= (others => '0');
   knockback_x <= (others => '0');
   knockback_y <= (others => '0');
end behaviour;

configuration physics_system_tb_behaviour_cfg of physics_system_tb is
   for behaviour
      for all: physics_system use configuration work.physics_system_behaviour_cfg;
      end for;
   end for;
end physics_system_tb_behaviour_cfg;
