library IEEE;
use IEEE.std_logic_1164.ALL;

entity p_knockback_calculator_tb is
end p_knockback_calculator_tb;

architecture structural of p_knockback_calculator_tb is
   component p_knockback_calculator
      port(vin_x  : in  std_logic_vector(8 downto 0);
           vin_y  : in  std_logic_vector(8 downto 0);
   	     knockback_percentage : in std_logic_vector(7 downto 0);
   	     knockback_x : in std_logic_vector(4 downto 0);
   	     knockback_y : in std_logic_vector(4 downto 0);
           vout_x : out std_logic_vector(8 downto 0);
           vout_y : out std_logic_vector(8 downto 0));
   end component;
   
   signal vin_x : std_logic_vector(8 downto 0);
   signal vin_y : std_logic_vector(8 downto 0);
   signal knockback_percentage : std_logic_vector(7 downto 0);
   signal knockback_x : std_logic_vector(4 downto 0);
   signal knockback_y : std_logic_vector(4 downto 0);
   signal vout_x : std_logic_vector(8 downto 0);
   signal vout_y : std_logic_vector(8 downto 0);
begin
   calculator: p_knockback_calculator port map (vin_x, vin_y, knockback_percentage, knockback_x, knockback_y, vout_x, vout_y);
   
   vin_x <= "000000000" after 0 ns,
        "000000000" after 10 ns,
        "000000001" after 20 ns,
        "000000100" after 30 ns,
        "000100100" after 40 ns,
        "100011000" after 50 ns,
        "001000111" after 60 ns,
        "111111111" after 70 ns,
        "111111110" after 80 ns;
   vin_y <= "000000000" after 0 ns;
   knockback_x <= "00000" after 0 ns,
                  "01000" after 15 ns,
                  "11000" after 25 ns,
                  "00110" after 35 ns,
                  "11010" after 45 ns,
                  "11000" after 70 ns,
                  "11010" after 75 ns,
                  "11000" after 85 ns;
   knockback_y <= "00000" after 0 ns;
   knockback_percentage <= "00000001" after 0 ns,
                           "00000011" after 50 ns,
                           "01101101" after 55 ns,
                           "00000001" after 72 ns;
   
end structural;

configuration p_knockback_calculator_tb_structural_cfg of p_knockback_calculator_tb is
   for structural
      for all: p_knockback_calculator use configuration work.p_knockback_calculator_cfg;
      end for;
   end for;
end p_knockback_calculator_tb_structural_cfg;
