library IEEE;
use IEEE.std_logic_1164.ALL;

entity physics_system_tb is
end physics_system_tb;


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

architecture behaviour of physics_system_tb is
   component physics_system
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
   end component;
   signal vin_x : std_logic_vector(9 downto 0);
   signal vin_y : std_logic_vector(9 downto 0);
   signal pin_x : std_logic_vector(8 downto 0);
   signal pin_y : std_logic_vector(8 downto 0);
   signal player_input : std_logic_Vector(7 downto 0);
   signal knockback_percentage : std_logic_vector(7 downto 0);
   signal knockback_x : std_logic_vector(7 downto 0);
   signal knockback_y : std_logic_vector(7 downto 0);
   signal vout_x : std_logic_vector(9 downto 0);
   signal vout_y : std_logic_vector(9 downto 0);
   signal pout_x : std_logic_vector(8 downto 0);
   signal pout_y : std_logic_vector(8 downto 0);
begin
   test: physics_system port map (vin_x, vin_y, pin_x, pin_y, player_input, knockback_percentage, knockback_x, knockback_y,
         vout_x, vout_y, pout_x, pout_y);
   player_input <= "00000000" after 0 ns,
                   "00000001" after 10 ns,
                   "00000010" after 20 ns,
                   "00000011" after 30 ns,
                   "00000100" after 40 ns,
                   "00001000" after 50 ns,
                   "00000000" after 60 ns,
                   "00000001" after 70 ns,
                   "00000010" after 80 ns,
                   "00000011" after 90 ns,
                   "00000100" after 100 ns,
                   "00001000" after 110 ns,
                   "00000000" after 120 ns,
                   "00000001" after 130 ns,
                   "00000010" after 140 ns,
                   "00000011" after 150 ns,
                   "00000100" after 160 ns,
                   "00001000" after 170 ns,
                   "00000000" after 180 ns,
                   "00000001" after 190 ns,
                   "00000010" after 200 ns,
                   "00000011" after 210 ns,
                   "00000100" after 220 ns,
                   "00001000" after 230 ns,
                   "00000000" after 240 ns,
                   "00000001" after 250 ns,
                   "00000010" after 260 ns,
                   "00000011" after 270 ns,
                   "00000100" after 280 ns,
                   "00001000" after 290 ns,
                   "00000000" after 300 ns,
                   "00000001" after 310 ns,
                   "00000010" after 320 ns,
                   "00000011" after 330 ns,
                   "00000100" after 340 ns,
                   "00001000" after 350 ns;
   vin_x <= "0000000000" after 0 ns,
            "1111111110" after 60 ns,
            "0000000010" after 120 ns,
            "0000000110" after 180 ns,
            "1111111111" after 300 ns;
   vin_y <= "0000000001" after 0 ns;
   pin_x <= std_logic_vector(to_unsigned(20, 9));
   pin_y <= std_logic_vector(to_unsigned(68, 9));
   knockback_percentage <= "00000001" after 0 ns,
                           "00000100" after 270 ns;
   knockback_x <= "00000000" after 0 ns,
                  "01000000" after 246 ns,
                  "00100000" after 252 ns,
                  "11000000" after 258 ns,
                  "00110000" after 264 ns,
                  "11010000" after 270 ns,
                  "11110000" after 276 ns,
                  "11000000" after 282 ns,
                  "11010000" after 288 ns,
                  "11000000" after 294 ns;
   knockback_y <= "00000000" after 0 ns,
                  "01000000" after 246 ns,
                  "00100000" after 252 ns,
                  "11000000" after 258 ns,
                  "00110000" after 264 ns,
                  "11010000" after 270 ns,
                  "11110000" after 276 ns,
                  "11000000" after 282 ns,
                  "11010000" after 288 ns,
                  "11000000" after 294 ns;
end behaviour;
