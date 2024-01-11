library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity jump_calculator is
	port(	collision_in	: in std_logic;
			c_input			: in std_logic;
			vin_y	         : in std_logic_vector (9 downto 0);
			vout_y	   	: out std_logic_vector (9 downto 0));
end jump_calculator;

architecture behaviour of jump_calculator is

constant	jump_velocity	: std_logic_vector := "1111110111"; -- -9

begin

vout_y <= std_logic_vector(signed(vin_y) + signed(jump_velocity)) when c_input = '1' and collision_in = '1' else vin_y;

end architecture behaviour;
