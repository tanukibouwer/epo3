library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity p_knockback_calculator is
   port(vin_x  : in  std_logic_vector(8 downto 0);
        vin_y  : in  std_logic_vector(8 downto 0);
	knockback_percentage : in std_logic_vector(7 downto 0);
	knockback_x : in std_logic_vector(7 downto 0);
	knockback_y : in std_logic_vector(7 downto 0);
        vout_x : out std_logic_vector(8 downto 0);
        vout_y : out std_logic_vector(8 downto 0));
end p_knockback_calculator;

architecture behaviour of p_knockback_calculator is
   constant balance_factor : std_logic_vector(4 downto 0) := "00100"; -- Signed
   -- sorry :(
   signal shifted_percentage : std_logic_vector(14 downto 0) := (others => '0');
   signal multiplied_vector_x : std_logic_vector(22 downto 0) := (others => '0');
   signal multiplied_vector_y : std_logic_vector(22 downto 0) := (others => '0');
   signal bitshifted_vector_x : std_logic_vector(13 downto 0) := (others => '0');
   signal bitshifted_vector_y : std_logic_vector(13 downto 0) := (others => '0');
   signal multiplied_bitshifted_vector_x : std_logic_vector(18 downto 0) := (others => '0');
   signal multiplied_bitshifted_vector_y : std_logic_vector(18 downto 0) := (others => '0');
   signal bitshifted_multiplied_bitshifted_vector_x : std_logic_vector(12 downto 0) := (others => '0');
   signal bitshifted_multiplied_bitshifted_vector_y : std_logic_vector(12 downto 0) := (others => '0');

begin
   shifted_percentage <= '0' & knockback_percentage & "000000";
   multiplied_vector_x <= std_logic_vector(signed(knockback_x) * signed(shifted_percentage));
   multiplied_vector_y <= std_logic_vector(signed(knockback_y) * signed(shifted_percentage));
   bitshifted_vector_x <= multiplied_vector_x(22 downto 9);
   bitshifted_vector_y <= multiplied_vector_y(22 downto 9);
   multiplied_bitshifted_vector_x <= std_logic_vector(signed(bitshifted_vector_x) * signed(balance_factor));
   multiplied_bitshifted_vector_y <= std_logic_vector(signed(bitshifted_vector_y) * signed(balance_factor));
   bitshifted_multiplied_bitshifted_vector_x <= multiplied_bitshifted_vector_x(18 downto 6);
   bitshifted_multiplied_bitshifted_vector_y <= multiplied_bitshifted_vector_y(18 downto 6);
   vout_x <= std_logic_vector(signed(vin_x) + signed(bitshifted_multiplied_bitshifted_vector_x(8 downto 0)));
   vout_y <= std_logic_vector(signed(vin_y) + signed(bitshifted_multiplied_bitshifted_vector_y(8 downto 0)));
end behaviour;
