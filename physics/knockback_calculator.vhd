library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity p_knockback_calculator is
   port(vin_x  : in  std_logic_vector(8 downto 0);
        vin_y  : in  std_logic_vector(8 downto 0);
	knockback_percentage : in std_logic_vector(7 downto 0);
	knockback_x : in std_logic_vector(4 downto 0);
	knockback_y : in std_logic_vector(4 downto 0);
        vout_x : out std_logic_vector(8 downto 0);
        vout_y : out std_logic_vector(8 downto 0));
end p_knockback_calculator;

architecture behaviour of p_knockback_calculator is
   constant balance_factor : std_logic_vector(4 downto 0) := "01000"; -- Signed
   component physics_9bit_adder
      port(a      : in  std_logic_vector(8 downto 0);
           b      : in  std_logic_vector(8 downto 0);
           result : out std_logic_vector(8 downto 0));
   end component;
   -- sorry :(
   signal shifted_percentage : std_logic_vector(11 downto 0) := (others => '0');
   signal multiplied_vector_x : std_logic_vector(16 downto 0) := (others => '0');
   signal multiplied_vector_y : std_logic_vector(16 downto 0) := (others => '0');
   signal bitshifted_vector_x : std_logic_vector(13 downto 0) := (others => '0');
   signal bitshifted_vector_y : std_logic_vector(13 downto 0) := (others => '0');
   signal multiplied_bitshifted_vector_x : std_logic_vector(18 downto 0) := (others => '0');
   signal multiplied_bitshifted_vector_y : std_logic_vector(18 downto 0) := (others => '0');
   signal bitshifted_multiplied_bitshifted_vector_x : std_logic_vector(12 downto 0) := (others => '0');
   signal bitshifted_multiplied_bitshifted_vector_y : std_logic_vector(12 downto 0) := (others => '0');

begin
   shifted_percentage <= '0' & knockback_percentage & "000";
   multiplied_vector_x <= std_logic_vector(signed(knockback_x) * signed(shifted_percentage));
   bitshifted_vector_x <= multiplied_vector_x(16 downto 3);
   multiplied_bitshifted_vector_x <= std_logic_vector(signed(bitshifted_vector_x) * signed(balance_factor));
   bitshifted_multiplied_bitshifted_vector_x <= multiplied_bitshifted_vector_x(18 downto 6);
   x_adder : physics_9bit_adder port map (vin_x, bitshifted_multiplied_bitshifted_vector_x(8 downto 0), vout_x);
   y_adder : physics_9bit_adder port map (vin_y, bitshifted_multiplied_bitshifted_vector_y(8 downto 0), vout_y);
end behaviour;

configuration p_knockback_calculator_cfg of p_knockback_calculator is
   for behaviour
      for all: physics_9bit_adder use configuration work.physics_9bit_adder_behaviour_cfg;
      end for;
   end for;
end p_knockback_calculator_cfg;

