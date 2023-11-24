library IEEE;
use IEEE.std_logic_1164.ALL;

entity p_dampener_tb is
end p_dampener_tb;

architecture behaviour of p_dampener_tb is
   component p_dampener
      generic(dampening : std_logic_vector(8 downto 0) := "111111011");
      port(vin_x  : in  std_logic_vector(8 downto 0);
           vin_y  : in  std_logic_vector(8 downto 0);
           vout_x : out std_logic_vector(8 downto 0);
           vout_y : out std_logic_vector(8 downto 0));
   end component;
   signal vin_x  : std_logic_vector(8 downto 0);
   signal vin_y  : std_logic_vector(8 downto 0);
   signal vout_x : std_logic_vector(8 downto 0);
   signal vout_y : std_logic_vector(8 downto 0);
begin
   test: p_dampener port map (vin_x, vin_y, vout_x, vout_y);
   vin_x <= "100000000" after 0 ns,
            "010000000" after 10 ns,
            "001000000" after 20 ns;
   vin_y <= "101000000" after 0 ns,
            "010010000" after 10 ns,
            "001001000" after 20 ns;
end behaviour;

configuration p_dampener_tb_behaviour_cfg of p_dampener_tb is
   for behaviour
      for all: p_dampener use configuration work.p_dampener_behaviour_cfg;
      end for;
   end for;
end p_dampener_tb_behaviour_cfg;
