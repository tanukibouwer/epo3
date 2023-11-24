library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity percentage_sprite_fsm is
port(
	percentage			: in std_logic;
	reset		: in std_logic;
	address 	: in std_logic_vector(1 downto 0);
	data_in 	: in std_logic_vector(7 downto 0);
	data_out 	: out std_logic_vector(7 downto 0);
	write 		: in std_logic);
end percentage_sprite_fsm;

architecture behaviour of percentage_sprite_fsm is

begin

end behaviour;

