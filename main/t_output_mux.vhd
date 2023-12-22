-----------------------------------------------------------------------------
-- Multiplexor for the outputs so that the internal signals on the chip can
-- be tested.
--
-- Without any selection input the output pins will entail the VGA outputs,
-- with a selection input any different signal can be selected.
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity output_mux is
    port(
    -- selection signals to choose which operation mode/which signals to output
    sel : in std_logic_vector(4 downto 0);
    -- VGA inputs from the VGA module
    R_data : in std_logic_vector(3 downto 0);
    G_data : in std_logic_vector(3 downto 0);
    B_data : in std_logic_vector(3 downto 0);
    Vsync : in std_logic;
    Hsync : in std_logic;

    -- Other inputs from internal components

    -- output pins
    pin_1 : out std_logic;
    pin_2 : out std_logic;
    pin_3 : out std_logic;
    pin_4 : out std_logic;
    pin_5 : out std_logic;
    pin_6 : out std_logic;
    pin_7 : out std_logic;
    pin_8 : out std_logic;
    pin_9 : out std_logic;
    pin_10 : out std_logic;
    pin_11 : out std_logic;
    pin_12 : out std_logic;
    pin_13 : out std_logic;
    pin_14 : out std_logic


        );

end entity output_mux;

architecture behavioural of output_mux is
	

begin

	process(sel)
	begin
		case sel is
			when "00000" => -- standard operation, thus display is active
				pin1 <= R_data(0),
				pin2 <= R_data(0),
				pin3 <= R_data(0),
				pin4 <= R_data(0),
				pin5 <= G_data(0),
				pin6 <= G_data(0),
				pin7 <= G_data(0),
				pin8 <= G_data(0),
				pin9 <= B_data(0),
				pin10 <= B_data(0),
				pin11 <= B_data(0),
				pin12 <= B_data(0),
				pin13 <= Vsync,
				pin14 <= Hsync);
			when "00001" => -- first set of test signals
				pin1 <= 
				pin2 <= 
				pin3 <= 
				pin4 <=
				pin5 <=
				pin6 <=
				pin7 <=
				pin8 <= 
				pin9 <= 
				pin10 <=
				pin11 <=
				pin12 <=
				pin13 <=
				pin14 <=
				when "00010" =>
				when "00011" =>
				when "00100" =>
				when "00101" =>
				when "00110" =>
				when "00111" =>
				when "01000" =>
				when "01001" =>
				when "01010" =>
				when "01011" =>
				when "01100" =>
				when "01101" =>
				when "01110" =>
				when "01111" =>
				when "10000" =>
				when "10001" =>
				when "10010" =>
				when "10011" =>
				when "10100" =>
				when "10101" =>
				when "10110" =>
				when "10111" =>
				when "11000" =>
				when "11001" =>
				when "11010" =>
				when "11011" =>
				when "11100" =>
				when "11101" =>
				when "11110" =>
				when "11111" =>
		end case;
	end process;
end architecture behavioural;


