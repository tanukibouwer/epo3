library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity gravity is
	port(	velocity_in 	: in std_logic_vector (8 downto 0);
			velocity_out	: out std_logic_vector (8 downto 0));
end gravity;

architecture behaviour of gravity is

	constant gravity_constant : std_logic_vector (8 downto 0)	:= "000000001";

begin

	velocity_out <= std_logic_vector(signed(velocity_in) + signed(gravity_constant));

end architecture behaviour;

configuration gravity_behaviour_cfg of gravity is
	for behaviour
	end for;
end gravity_behaviour_cfg;

