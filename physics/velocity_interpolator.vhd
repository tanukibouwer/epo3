library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity velocity_interpolator is
   port(vin_x : in std_logic_vector(9 downto 0);
        vout_x : out std_logic_vector(9 downto 0);
        movement_target : in std_logic_vector(5 downto 0));
end velocity_interpolator;

architecture behaviour of velocity_interpolator is
constant accel : signed(3 downto 0) := "0001";
constant neg_accel : signed(3 downto 0) := "1110";
begin

calculate : process (vin_x, movement_target) is
   variable difference : signed(9 downto 0) := (others => '0');
   variable small_difference : std_logic;
begin
   difference := signed(vin_x) - signed(movement_target);
   
   if difference < 0 then
      if difference > neg_accel then
         small_difference := '1';
      else
         small_difference := '0';
      end if;
   else
      if difference < accel then
         small_difference := '1';
      else
         small_difference := '0';
      end if;
   end if;
   
   if small_difference = '1' then
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
