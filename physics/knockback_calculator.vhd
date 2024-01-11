library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity p_knockback_calculator is
   port(vin_x  : in  std_logic_vector(9 downto 0);
        vin_y  : in  std_logic_vector(9 downto 0);
	knockback_percentage : in std_logic_vector(7 downto 0);
	knockback_x : in std_logic_vector(7 downto 0);
	knockback_y : in std_logic_vector(7 downto 0);
        vout_x : out std_logic_vector(9 downto 0);
        vout_y : out std_logic_vector(9 downto 0));
end p_knockback_calculator;

architecture behaviour of p_knockback_calculator is
   constant balance_factor_x : std_logic_vector(4 downto 0) := "00100"; -- Signed
   constant balance_factor_y : std_logic_vector(4 downto 0) := "00100"; -- Signed
   constant knockback_y_addition_const : std_logic_vector(7 downto 0) := "01000000"; -- Same format as knockback_y
   -- sorry :(
   signal shifted_percentage_x : std_logic_vector(14 downto 0) := (others => '0');
   signal shifted_percentage_y : std_logic_vector(14 downto 0) := (others => '0');
   signal multiplied_vector_x : std_logic_vector(22 downto 0) := (others => '0');
   signal multiplied_vector_y : std_logic_vector(22 downto 0) := (others => '0');
   signal bitshifted_vector_x : std_logic_vector(13 downto 0) := (others => '0');
   signal bitshifted_vector_y : std_logic_vector(13 downto 0) := (others => '0');
   signal multiplied_bitshifted_vector_x : std_logic_vector(18 downto 0) := (others => '0');
   signal multiplied_bitshifted_vector_y : std_logic_vector(18 downto 0) := (others => '0');
   signal bitshifted_multiplied_bitshifted_vector_x : std_logic_vector(12 downto 0) := (others => '0');
   signal bitshifted_multiplied_bitshifted_vector_y : std_logic_vector(12 downto 0) := (others => '0');
   signal knockback_y_addition : std_logic_vector(7 downto 0) := (others => '0');
begin
   knockback_y_addition <= (others => '0') when knockback_y = "00000000" else knockback_y_addition_const;
   shifted_percentage_x <= '0' & knockback_percentage & "000000";
   shifted_percentage_y <= '0' & knockback_percentage & "000000";
   multiplied_vector_x <= std_logic_vector(signed(knockback_x) * signed(shifted_percentage_x));
   multiplied_vector_y <= std_logic_vector((signed(knockback_y) + signed(knockback_y_addition)) * signed(shifted_percentage_y)) when knockback_y(7 downto 7) = "0" else std_logic_vector((signed(knockback_y) - signed(knockback_y_addition)) * signed(shifted_percentage_y));
   bitshifted_vector_x <= multiplied_vector_x(22 downto 9);
   bitshifted_vector_y <= multiplied_vector_y(22 downto 9);
   multiplied_bitshifted_vector_x <= std_logic_vector(signed(bitshifted_vector_x) * signed(balance_factor_x));
   multiplied_bitshifted_vector_y <= std_logic_vector(signed(bitshifted_vector_y) * signed(balance_factor_y));
   bitshifted_multiplied_bitshifted_vector_x <= multiplied_bitshifted_vector_x(18 downto 6);
   bitshifted_multiplied_bitshifted_vector_y <= multiplied_bitshifted_vector_y(18 downto 6);
   vout_x <= std_logic_vector(signed(vin_x) + signed(bitshifted_multiplied_bitshifted_vector_x(9 downto 0)));
   vout_y <= std_logic_vector(signed(vin_y) + signed(bitshifted_multiplied_bitshifted_vector_y(9 downto 0)));
end behaviour;
