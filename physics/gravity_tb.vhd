library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity gravity_tb is
end gravity_tb;

architecture structural of gravity_tb is

	component gravity is
		port(	velocity_in		: in std_logic_vector (9 downto 0);
			velocity_out		: out std_logic_vector (9 downto 0));
	end component gravity;

	signal velocity_in, velocity_out : std_logic_vector (9 downto 0);

begin


	grav: gravity port map (velocity_in, velocity_out);

	velocity_in <=	"0000100000" after 0 ns;

end architecture structural;


