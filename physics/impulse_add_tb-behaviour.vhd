library IEEE;
use IEEE.std_logic_1164.ALL;

architecture behaviour of p_impulse_add_tb is
   component p_impulse_add
      port(vin_x     : in  std_logic_vector(9 downto 0);
           vin_y     : in  std_logic_vector(9 downto 0);
           impulse_x : in  std_logic_vector(9 downto 0);
           impulse_y : in  std_logic_vector(9 downto 0);
           vout_x    : out std_logic_vector(9 downto 0);
           vout_y    : out std_logic_vector(9 downto 0));
   end component;
   signal vin_x     : std_logic_vector(9 downto 0);
   signal vin_y     : std_logic_vector(9 downto 0);
   signal impulse_x : std_logic_vector(9 downto 0);
   signal impulse_y : std_logic_vector(9 downto 0);
   signal vout_x    : std_logic_vector(9 downto 0);
   signal vout_y    : std_logic_vector(9 downto 0);
begin
   test: p_impulse_add port map (vin_x, vin_y, impulse_x, impulse_y, vout_x, vout_y);
   vin_x <= "0000000000" after 0 ns,
        "0000000000" after 10 ns,
        "0000000001" after 20 ns,
        "0000000100" after 30 ns,
        "0000100100" after 40 ns,
        "0100000000" after 50 ns,
        "0001000000" after 60 ns;
   vin_y <= "0000000000" after 0 ns,
        "0000000000" after 10 ns,
        "0000000001" after 20 ns,
        "0000000100" after 30 ns,
        "0000100100" after 40 ns,
        "0100000000" after 50 ns,
        "0001000000" after 60 ns;
   impulse_x <= "0000000000" after 0 ns,
        "0000000000" after 15 ns,
        "0000000001" after 25 ns,
        "0000000100" after 35 ns,
        "0000100100" after 45 ns,
        "0100000000" after 55 ns,
        "0001000000" after 65 ns;
   impulse_y <= "0000000000" after 0 ns,
        "0000000000" after 15 ns,
        "0000000001" after 25 ns,
        "0000000100" after 35 ns,
        "0000100100" after 45 ns,
        "0100000000" after 55 ns,
        "0001000000" after 65 ns;
end behaviour;

