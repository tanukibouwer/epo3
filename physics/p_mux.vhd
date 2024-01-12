library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity p_mux is
    port(
	clk		: in std_logic;
	reset	: in std_logic;
	
	-- vcount goes to 524, half of that is 262
	
	vcount : in std_logic_vector(9 downto 0);
	hcount : in std_logic_vector(9 downto 0);
	
	-- inputs from input module
	
	inputsp1 : in std_logic_vector(7 downto 0);
	inputsp2 : in std_logic_vector(7 downto 0);
	
    -- inputs from the attack module
	
	directionx1out       : in std_logic_vector(7 downto 0);
    directiony1out       : in std_logic_vector(7 downto 0);
	char1perctemp 		: in std_logic_vector(7 downto 0);
	
    directionx2out       : in std_logic_vector(7 downto 0);
    directiony2out       : in std_logic_vector(7 downto 0);
	char2perctemp 		: in std_logic_vector(7 downto 0);
	
	-- inputs and outputs from the memory module
	
	data_in8b1  : out std_logic_vector(8 downto 0);
    data_in8b2  : out std_logic_vector(8 downto 0);
    data_in8b3  : out std_logic_vector(8 downto 0);
    data_in8b4  : out std_logic_vector(8 downto 0);
	
    data_out8b1 : in std_logic_vector(8 downto 0);
    data_out8b2 : in std_logic_vector(8 downto 0);
    data_out8b3 : in std_logic_vector(8 downto 0);
    data_out8b4 : in std_logic_vector(8 downto 0);
	
    data_in9b1  : out std_logic_vector(9 downto 0);
    data_in9b2  : out std_logic_vector(9 downto 0);
    data_in9b3  : out std_logic_vector(9 downto 0);
    data_in9b4  : out std_logic_vector(9 downto 0);
	
    data_out9b1 : in std_logic_vector(9 downto 0);
    data_out9b2 : in std_logic_vector(9 downto 0);
    data_out9b3 : in std_logic_vector(9 downto 0);
    data_out9b4 : in std_logic_vector(9 downto 0);
	
	-- inputs and outputs from the physics module
	
	vin_x                : out std_logic_vector(9 downto 0);
    vin_y                : out std_logic_vector(9 downto 0);
    pin_x                : out std_logic_vector(8 downto 0);
    pin_y                : out std_logic_vector(8 downto 0);
    player_input         : out std_logic_vector(7 downto 0);
	knockback_percentage : out std_logic_vector(7 downto 0);
    knockback_x          : out std_logic_vector(7 downto 0);
    knockback_y          : out std_logic_vector(7 downto 0);
    vout_x               : in std_logic_vector(9 downto 0);
    vout_y               : in std_logic_vector(9 downto 0);
    pout_x               : in std_logic_vector(8 downto 0);
    pout_y               : in std_logic_vector(8 downto 0));

end entity p_mux;

architecture behavioural of p_mux is
	signal vx1	: std_logic_vector(9 downto 0);
	signal vy1	: std_logic_vector(9 downto 0);
	signal px1	: std_logic_vector(8 downto 0);
	signal py1	: std_logic_vector(8 downto 0);
	signal vx1m	: std_logic_vector(9 downto 0);
	signal vy1m	: std_logic_vector(9 downto 0);
	signal px1m	: std_logic_vector(8 downto 0);
	signal py1m	: std_logic_vector(8 downto 0);
	signal sel, new_sel	: std_logic_vector(0 downto 0);
	
begin

	process(clk) is
	begin
		if (rising_edge (clk)) then
			if (reset = '1') then
				vx1m <= "0000000000";
				vy1m <= "0000000000";
				px1m <= "000000000";
				py1m <= "000000000";
				sel	 <= "0";
			else
				if (vcount = "0100000110") then 
					if (hcount <= "0000000001" ) then
					vx1m <= vx1;
					vy1m <= vy1;
					px1m <= px1;
					py1m <= py1;
					end if;
				end if;
				sel	 <= new_sel;
			end if;
		end if;
	end process;
	data_in9b1 <= vx1m;
	data_in9b2 <= vy1m;
	data_in8b1 <= px1m;
	data_in8b2 <= py1m;

	process(vcount, sel, data_out9b1, data_out9b2, data_out9b3, data_out9b4, data_out8b1, data_out8b2, data_out8b3, data_out8b4, inputsp1, inputsp2, char1perctemp, char2perctemp, directionx1out, directiony1out, directionx2out, directiony2out, vout_x, vout_y, pout_x, pout_y)
	begin
		case sel is
			when "0" =>
				vin_x					<= data_out9b1;
				vin_y               	<= data_out9b2;
				pin_x               	<= data_out8b1;
				pin_y                	<= data_out8b2;
				player_input         	<= inputsp1;
				knockback_percentage 	<= char1perctemp;
				knockback_x          	<= directionx1out;
				knockback_y          	<= directiony1out;
				vx1              	 	<= vout_x;
				vy1              	 	<= vout_y;
				px1              	 	<= pout_x;
				py1              	 	<= pout_y;	
				data_in9b3            	<= vout_x;
				data_in9b4            	<= vout_y;
				data_in8b3            	<= pout_x;
				data_in8b4            	<= pout_y;
				if (vcount <= "0100000110") then
					if (vcount <= "0000000010") then
						new_sel <= "1";
					else
						new_sel	<= "0";
					end if;
				else
					new_sel <= "1";
				end if;
			when "1" =>
				vin_x					<= data_out9b3;
				vin_y               	<= data_out9b4;
				pin_x               	<= data_out8b3;
				pin_y                	<= data_out8b4;
				player_input         	<= inputsp2;
				knockback_percentage 	<= char2perctemp;
				knockback_x          	<= directionx2out;
				knockback_y          	<= directiony2out;
				vx1              	 	<= vout_x;
				vy1              	 	<= vout_y;
				px1              	 	<= pout_x;
				py1              	 	<= pout_y;
				data_in9b3            	<= vout_x;
				data_in9b4            	<= vout_y;
				data_in8b3            	<= pout_x;
				data_in8b4            	<= pout_y;
				if (vcount <= "0100000110") then
					if (vcount <= "0000000010") then
						new_sel <= "1";
					else
						new_sel	<= "0";
					end if;
				else
					new_sel <= "1";
				end if;
			when OTHERS =>
				vin_x					<= data_out9b3;
				vin_y               	<= data_out9b4;
				pin_x               	<= data_out8b3;
				pin_y                	<= data_out8b4;
				player_input         	<= inputsp2;
				knockback_percentage 	<= char2perctemp;
				knockback_x          	<= directionx2out;
				knockback_y          	<= directiony2out;
				vx1              	 	<= vout_x;
				vy1              	 	<= vout_y;
				px1              	 	<= pout_x;
				py1              	 	<= pout_y;
				data_in9b3            	<= vout_x;
				data_in9b4            	<= vout_y;
				data_in8b3            	<= pout_x;
				data_in8b4            	<= pout_y;
				if (vcount <= "0100000110") then
					if (vcount <= "0000000010") then
						new_sel <= "1";
					else
						new_sel	<= "0";
					end if;
				else
					new_sel <= "1";
				end if;
		end case;
	end process;
end architecture behavioural;
