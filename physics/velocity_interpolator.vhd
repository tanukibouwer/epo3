library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity velocity_interpolator is
   port(vin_x : in std_logic_vector(8 downto 0);
        vout_x : out std_logic_vector(8 downto 0);
        movement_target : in std_logic_vector(5 downto 0));
end velocity_interpolator;

architecture behaviour of velocity_interpolator is
constant accel : signed(3 downto 0) := "0101";
begin

calculate : process (vin_x, movement_target) is
   variable difference : signed(8 downto 0) := (others => '0');
begin
   difference := signed(vin_x) - signed(movement_target);
   if abs(difference) < accel then
      vout_x <= std_logic_vector(resize(signed(movement_target), vout_x'length));
   elsif signed(vin_x) > signed(movement_target) then
      vout_x <= std_logic_vector(signed(vin_x) - accel);
   elsif signed(vin_x) < signed(movement_target) then
      vout_x <= std_logic_vector(signed(vin_x) + accel);
   else
      vout_x <= (others => '0');
   end if;
end process calculate;

end behaviour;

configuration velocity_interpolator_cfg of velocity_interpolator is
   for behaviour
   end for;
end velocity_interpolator_cfg;
