library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity collision_resolver_tb is
end collision_resolver_tb;

architecture behaviour of collision_resolver_tb is
   component collision_resolver
      port(vin_y   : in  std_logic_vector(8 downto 0);
        pin_x      : in  std_logic_vector(7 downto 0);
        pin_y      : in  std_logic_vector(7 downto 0);
        input_down : in  std_logic;
        vout_y     : out std_logic_vector(8 downto 0);
        pout_y     : out std_logic_vector(7 downto 0);
        on_floor   : out std_logic);
   end component;
   signal vin_y      : std_logic_vector(8 downto 0);
   signal pin_x      : std_logic_vector(7 downto 0);
   signal pin_y      : std_logic_vector(7 downto 0);
   signal input_down : std_logic;
   signal vout_y     : std_logic_vector(8 downto 0);
   signal pout_y     : std_logic_vector(7 downto 0);
   signal on_floor   : std_logic;
begin
   test: collision_resolver port map (vin_y, pin_x, pin_y, input_down, vout_y, pout_y, on_floor);
   vin_y <= "000000000" after 0 ns,
            "111111011" after 10 ns,
            "000000101" after 80 ns;
   pin_x <= "00000000" after 0 ns,
            "00011110" after 6 ns,
            "00000000" after 15 ns,
            "00011110" after 18 ns,
            "00000000" after 80 ns,
            "00011110" after 86 ns,
            "00000000" after 95 ns,
            "00011110" after 98 ns;
   pin_y <= "00000000" after 0 ns,
            "00100100" after 5 ns,
            "00101101" after 15 ns,
            "01010000" after 25 ns,
            "01101110" after 50 ns,
            "01100111" after 60 ns,
            "00000000" after 80 ns,
            "00100100" after 85 ns,
            "00101101" after 95 ns,
            "01010000" after 105 ns,
            "01101110" after 130 ns,
            "01100111" after 140 ns;
   input_down <= '0' after 0 ns,
                 '1' after 5 ns,
                 '0' after 7 ns,
                 '1' after 15 ns,
                 '0' after 17 ns,
                 '1' after 50 ns,
                 '0' after 55 ns,
                 '0' after 80 ns,
                 '1' after 85 ns,
                 '0' after 87 ns,
                 '1' after 95 ns,
                 '0' after 97 ns,
                 '1' after 130 ns,
                 '0' after 135 ns;
end behaviour;

configuration collision_resolver_tb_behaviour_cfg of collision_resolver_tb is
   for behaviour
      for all: collision_resolver use configuration work.collision_resolver_behaviour_cfg;
      end for;
   end for;
end collision_resolver_tb_behaviour_cfg;
