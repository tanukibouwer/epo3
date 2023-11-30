library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity position_adder is
   port(vin_x  : in  std_logic_vector(8 downto 0);
        vin_y  : in  std_logic_vector(8 downto 0);
        pin_x  : in  std_logic_vector(7 downto 0);
        pin_y  : in  std_logic_vector(7 downto 0);
        pout_x : out std_logic_vector(7 downto 0);
        pout_y : out std_logic_vector(7 downto 0));
end position_adder;

architecture behaviour of position_adder is
   signal addition_x : std_logic_vector(8 downto 0) := (others => '0');
   signal addition_y : std_logic_vector(8 downto 0) := (others => '0');
begin
   addition_x <= std_logic_vector(signed(vin_x) + signed('0' & pin_x));
   addition_y <= std_logic_vector(signed(vin_y) + signed('0' & pin_y));
   pout_x <= addition_x(7 downto 0);
   pout_y <= addition_y(7 downto 0);
end behaviour;

configuration position_adder_behaviour_cfg of position_adder is
   for behaviour
   end for;
end position_adder_behaviour_cfg;
