library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity gravity is
	port(	velocity_in 	: in std_logic_vector (9 downto 0);
			velocity_out	: out std_logic_vector (9 downto 0));
end gravity;

architecture behaviour of gravity is

	constant gravity_constant : std_logic_vector (9 downto 0)	:= "0000000001";

begin

	velocity_out <= std_logic_vector(signed(velocity_in) + signed(gravity_constant));

end architecture behaviour;

