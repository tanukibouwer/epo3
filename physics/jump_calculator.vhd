library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity jump_calculator is
	port(	collision_in	: in std_logic;
			c_input			: in std_logic;
			vin_y	         : in std_logic_vector (8 downto 0);
			vout_y	   	: out std_logic_vector (8 downto 0));
end jump_calculator;

architecture behaviour of jump_calculator is

constant	jump_velocity	: std_logic_vector := "111111101";

begin

vout_y <= std_logic_vector(signed(vin_y) + signed(jump_velocity)) when c_input = '1' and collision_in = '1' else vin_y;

--adder: process(c_input, collision_in)
--begin
--	if (c_input = '1' and collision_in = '1') then
--			vout_y <= std_logic_vector(signed(vin_y) + signed(jump_velocity));
--		else
--			vout_y <= vin_y;
--	end if;
--end process;
end architecture behaviour;

configuration jump_calculator_behaviour_cfg of jump_calculator is
   for behaviour
   end for;
end jump_calculator_behaviour_cfg;

