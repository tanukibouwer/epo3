library IEEE;
use IEEE.std_logic_1164.ALL;

entity position_adder_tb is
end position_adder_tb;

architecture behaviour of position_adder_tb is
   component position_adder
      port(vin_x  : in  std_logic_vector(8 downto 0);
           vin_y  : in  std_logic_vector(8 downto 0);
           pin_x  : in  std_logic_vector(7 downto 0);
           pin_y  : in  std_logic_vector(7 downto 0);
           pout_x : out std_logic_vector(7 downto 0);
           pout_y : out std_logic_vector(7 downto 0));
   end component;
   signal vin_x  : std_logic_vector(8 downto 0);
   signal vin_y  : std_logic_vector(8 downto 0);
   signal pin_x  : std_logic_vector(7 downto 0);
   signal pin_y  : std_logic_vector(7 downto 0);
   signal pout_x : std_logic_vector(7 downto 0);
   signal pout_y : std_logic_vector(7 downto 0);
begin
   test: position_adder port map (vin_x, vin_y, pin_x, pin_y, pout_x, pout_y);
   vin_x <= "000000000" after 0 ns,
            "001001010" after 20 ns,
            "111010101" after 40 ns,
            "010101101" after 60 ns,
            "000000001" after 90 ns,
            "111111111" after 120 ns;
   vin_y <= "000000000" after 0 ns,
            "001001010" after 20 ns,
            "111010101" after 40 ns,
            "010101101" after 60 ns,
            "000000001" after 90 ns,
            "111111111" after 120 ns;
   pin_x <= "00000000" after 0 ns,
            "00000001" after 10 ns,
            "11111111" after 30 ns,
            "00110010" after 50 ns,
            "10111011" after 80 ns,
            "10010101" after 100 ns,
            "00100010" after 120 ns;
   pin_y <= "00000000" after 0 ns,
            "00000001" after 10 ns,
            "11111111" after 30 ns,
            "00110010" after 50 ns,
            "10111011" after 80 ns,
            "10010101" after 100 ns,
            "00100010" after 120 ns;
            
end behaviour;
