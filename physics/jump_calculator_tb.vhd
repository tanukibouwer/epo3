library IEEE;
use IEEE.std_logic_1164.ALL;

entity jump_calculator_tb is
end jump_calculator_tb;

architecture structural of jump_calculator_tb is
   component jump_calculator
   	port(	collision_in	: in std_logic;
   			c_input			: in std_logic;
   			vin_y	         : in std_logic_vector (8 downto 0);
   			vout_y	   	: out std_logic_vector (8 downto 0));
   end component;
   signal collision_in	: std_logic;
   signal c_input			: std_logic;
   signal vin_y	      : std_logic_vector (8 downto 0);
   signal vout_y		   : std_logic_vector (8 downto 0);
begin
   test: jump_calculator port map (collision_in, c_input, vin_y, vout_y);
   collision_in <= 			'0' after 0 ns,
			'1' after 50 ns;	
   c_input <= 		'0' after 0 ns,
		'1' after 30 ns,
		'0' after 70 ns;
   vin_y <= "000000000" after 0 ns;
end structural;

configuration jump_calculator_tb_structural_cfg of jump_calculator_tb is
   for structural
      for all: jump_calculator use configuration work.jump_calculator_behaviour_cfg;
      end for;
   end for;
end jump_calculator_tb_structural_cfg;
