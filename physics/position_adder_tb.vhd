library IEEE;
use IEEE.std_logic_1164.ALL;

entity position_adder_tb is
end position_adder_tb;

architecture behaviour of position_adder_tb is
   component position_adder
      port(vin_x  : in  std_logic_vector(9 downto 0);
           vin_y  : in  std_logic_vector(9 downto 0);
           pin_x  : in  std_logic_vector(8 downto 0);
           pin_y  : in  std_logic_vector(8 downto 0);
           pout_x : out std_logic_vector(8 downto 0);
           pout_y : out std_logic_vector(8 downto 0));
   end component;
   signal vin_x  : std_logic_vector(9 downto 0);
   signal vin_y  : std_logic_vector(9 downto 0);
   signal pin_x  : std_logic_vector(8 downto 0);
   signal pin_y  : std_logic_vector(8 downto 0);
   signal pout_x : std_logic_vector(8 downto 0);
   signal pout_y : std_logic_vector(8 downto 0);
begin
   test: position_adder port map (vin_x, vin_y, pin_x, pin_y, pout_x, pout_y);
   vin_x <= "0000000000" after 0 ns,
            "0001001010" after 20 ns,
            "1111010101" after 40 ns,
            "0010101101" after 60 ns,
            "0000000001" after 90 ns,
            "1111111111" after 120 ns;
   vin_y <= "0000000000" after 0 ns,
            "0001001010" after 20 ns,
            "1111010101" after 40 ns,
            "0010101101" after 60 ns,
            "0000000001" after 90 ns,
            "1111111111" after 120 ns;
   pin_x <= "000000000" after 0 ns,
            "000000001" after 10 ns,
            "111111111" after 30 ns,
            "000110010" after 50 ns,
            "110111011" after 80 ns,
            "110010101" after 100 ns,
            "000100010" after 120 ns;
   pin_y <= "000000000" after 0 ns,
            "000000001" after 10 ns,
            "111111111" after 30 ns,
            "000110010" after 50 ns,
            "110111011" after 80 ns,
            "110010101" after 100 ns,
            "000100010" after 120 ns;
            
end behaviour;
