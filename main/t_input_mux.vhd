-----------------------------------------------------------------------------
-- Multiplexor for the inputs so that the internal signals on the chip can
-- be tested.
--
-- Without any selection input the output pins will entail the controller outputs,
-- with a selection input any different signal can be selected.
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity t_input_mux is
    port(
    -- selection signals to choose which operation mode/which signals to output
    sel : in std_logic_vector(2 downto 0);
    -- inputs from the controllers
    C1_data	: in std_logic;
    C2_data	: in std_logic;

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

end entity t_input_mux;

architecture behavioural of t_input_mux is

begin

	process(sel)
	begin
		case sel is
			when "000" => -- standard operation, controllers active
				pin1 <= C1_data,
				pin2 <= C2_data,
				pin3 <= '0',
				pin4 <= '0',
				pin5 <= '0',
				pin6 <= '0',
				pin7 <= '0',
				pin8 <= '0',
				pin9 <= '0',
				pin10 <= '0',
				pin11 <= '0',
				pin12 <= '0',
				pin13 <= '0',
				pin14 <= '0');
			when "001" => -- first set of test signals
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
			when "010" =>
			when "011" =>
			when "100" =>
			when "101" =>
			when "110" =>
			when "111" =>
		end case;
	end process;
end architecture behavioural;


