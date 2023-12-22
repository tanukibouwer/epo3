library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

architecture behaviour of coldet is

signal x1_in,x2_in,y1_in,y2_in : integer;
signal x_verschil, y_verschil : integer;
signal direction_y, direction_x: std_logic_vector(7 downto 0);

begin
x1_in <= to_integer(unsigned(x1));
x2_in <= to_integer(unsigned(x2));
y1_in <= to_integer(unsigned(y1));
y2_in <= to_integer(unsigned(y2));

x_verschil <= x2_in - x1_in;
y_verschil <= y2_in - y1_in;

lbl0: process(x_verschil, y_verschil, a1, a2, b1, b2, o1, o2)
	begin

		if ((a1='1' or a2='1' or b1='1' or b2='1') and (-13 <= y_verschil and y_verschil <= 13)) then

            if ((o1='1' and (a1='1' or b1='1')) or (o2='0' and (a2='1' or b2='1'))) then
				
				if (-4 <= x_verschil and x_verschil <= 10) then
						
					if (-4 <= x_verschil and x_verschil < -2) then
						if (-13 <= y_verschil and y_verschil < -12) then
							direction_y <= "11000010";						 
							direction_x <= "11110010";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction_y <= "11000010";						 
							direction_x <= "11101111";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction_y <= "11000011";						 
							direction_x <= "11101100";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction_y <= "11000101";						 
							direction_x <= "11100111";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction_y <= "11001001";						 
							direction_x <= "11011111";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction_y <= "11010011";							 
							direction_x <= "11010011";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction_y <= "11101100";						 
							direction_x <= "11000011";

						elsif (y_verschil = 0) then						 
							direction_y <= "00000000";						 
							direction_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction_y <= "00010100";						 
							direction_x <= "11000011";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction_y <= "00101101";						 
							direction_x <= "11010011";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction_y <= "00110111";						 
							direction_x <= "11011111";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction_y <= "00111011";						 
							direction_x <= "11100111";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction_y <= "00111101";						 
							direction_x <= "11101100";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction_y <= "00111110";						 
							direction_x <= "11101111";

						elsif (12 <= y_verschil and y_verschil <= 13) then						 
							direction_y <= "00111110";						 
							direction_x <= "11110010";
						end if;
				


					elsif (-2 <= x_verschil and x_verschil < 0) then
						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction_y <= "11000000";						 
							direction_x <= "11111011";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction_y <= "11000000";						 
							direction_x <= "11111010";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction_y <= "11000000";						 
							direction_x <= "11111001";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction_y <= "11000001";						 
							direction_x <= "11110111";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction_y <= "11000001";						 
							direction_x <= "11110011";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction_y <= "11000011";						 
							direction_x <= "11101100";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction_y <= "11010011";						 
							direction_x <= "11010011";

						elsif (y_verschil = 0) then						 
							direction_y <= "00000000";						 
							direction_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction_y <= "00101101";						 
							direction_x <= "11010011";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction_y <= "00111101";						 
							direction_x <= "11101100";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction_y <= "00111111";						 
							direction_x <= "11110011";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction_y <= "00111111";						 
							direction_x <= "11110111";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction_y <= "01000000";						 
							direction_x <= "11111001";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction_y <= "01000000";						 
							direction_x <= "11111010";

						elsif (12 <= y_verschil and y_verschil <= 13) then						 
							direction_y <= "01000000";						 
							direction_x <= "11111011";						
						end if;


					elsif (x_verschil = 0) then
							direction_y <= "00000000";
                   			direction_x <= "01000000";


					elsif (0 < x_verschil and x_verschil < 2) then
						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction_y <= "11000000";						 
							direction_x <= "00000101";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction_y <= "11000000";						 
							direction_x <= "00000110";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction_y <= "11000000";						 
							direction_x <= "00000111";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction_y <= "11000001";						 
							direction_x <= "00001001";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction_y <= "11000001";						 
							direction_x <= "00001101";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction_y <= "11000011";						 
							direction_x <= "00010100";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction_y <= "11000011";						 
							direction_x <= "00101101";

						elsif (y_verschil = 0) then						 
							direction_y <= "00000000";						 
							direction_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction_y <= "00101101";						 
							direction_x <= "00101101";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction_y <= "00111101";						 
							direction_x <= "00010100";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction_y <= "00111111";						 
							direction_x <= "00001101";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction_y <= "00111111";						 
							direction_x <= "00001001";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction_y <= "01000000";						 
							direction_x <= "00000111";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction_y <= "01000000";						 
							direction_x <= "00000110";

						elsif (12 <= y_verschil and y_verschil <= 13) then						 
							direction_y <= "01000000";						 
							direction_x <= "00000101";						
						end if;
					

				
					elsif (2 <= x_verschil and x_verschil <= 4) then
						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction_y <= "11000010";						 
							direction_x <= "00001110";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction_y <= "11000010";						 
							direction_x <= "00010001";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction_y <= "11000011";						 
							direction_x <= "00010100";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction_y <= "11000101";						 
							direction_x <= "00011001";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction_y <= "11001001";						 
							direction_x <= "00100001";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction_y <= "11010011";						 
							direction_x <= "00101101";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction_y <= "11101100";						 
							direction_x <= "00111101";

						elsif (y_verschil = 0) then						 
							direction_y <= "00000000";						 
							direction_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction_y <= "00010100";						 
							direction_x <= "00111101";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction_y <= "00101101";						 
							direction_x <= "00101101";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction_y <= "00110111";						 
							direction_x <= "00100001";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction_y <= "00111011";						 
							direction_x <= "00011001";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction_y <= "00111101";						 
							direction_x <= "00010100";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction_y <= "00111110";								 
							direction_x <= "00010001";

						elsif (12 <= y_verschil and y_verschil <= 13) then						 
							direction_y <= "00111110";						 
							direction_x <= "00001110";
						end if;
					



					elsif (4 < x_verschil and x_verschil <= 6) then
						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction_y <= "11000100";						 
							direction_x <= "00010111";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction_y <= "11000110";						 
							direction_x <= "00011010";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction_y <= "11001000";						 
							direction_x <= "00011111";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction_y <= "11001100";						 
							direction_x <= "00100101";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction_y <= "11010011";						 
							direction_x <= "00101101";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction_y <= "11011111";						 
							direction_x <= "00110111";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction_y <= "11110011";						 
							direction_x <= "00111111";

						elsif (y_verschil = 0) then						 
							direction_y <= "00000000";						 
							direction_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction_y <= "00001101";					 
							direction_x <= "00111111";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction_y <= "00100001";						 
							direction_x <= "00110111";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction_y <= "00101101";						 
							direction_x <= "00101101";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction_y <= "00110100";						 
							direction_x <= "00100101";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction_y <= "00111000";						 
							direction_x <= "00011111";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction_y <= "00111010";						 
							direction_x <= "00011010";

						elsif (12 <= y_verschil and y_verschil <= 13) then						 
							direction_y <= "00111100";						 
							direction_x <= "00010111";						
						end if;


					elsif (6 < x_verschil and x_verschil <= 8) then
						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction_y <= "11001000";						 
							direction_x <= "00011110";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction_y <= "11001010";						 
							direction_x <= "00100010";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction_y <= "11001101";						 
							direction_x <= "00100111";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction_y <= "11010011";						 
							direction_x <= "00101101";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction_y <= "11011011";						 
							direction_x <= "00110100";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction_y <= "11100111";						 
							direction_x <= "00111011";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction_y <= "11110111";						 
							direction_x <= "00111111";

						elsif (y_verschil = 0) then						 
							direction_y <= "00000000";												 
							direction_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction_y <= "00001001";						 
							direction_x <= "00111111";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction_y <= "00011001";						 
							direction_x <= "00111011";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction_y <= "00100101";						 
							direction_x <= "00110100";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction_y <= "00101101";						 
							direction_x <= "00101101";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction_y <= "00110011";						 
							direction_x <= "00100111";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction_y <= "00110110";						 
							direction_x <= "00100010";

						elsif (12 <= y_verschil and y_verschil <= 13) then						 
							direction_y <= "00111000";						 
							direction_x <= "00011110";						
						end if;
					

                	elsif (8 < x_verschil and x_verschil <= 10) then
						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction_y <= "11001011";						 
							direction_x <= "00100100";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction_y <= "11001110";						 
							direction_x <= "00101001";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction_y <= "11010011";						 
							direction_x <= "00101101";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction_y <= "11011001";																
							direction_x <= "00110011";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction_y <= "11100001";						 
							direction_x <= "00111000";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction_y <= "11101100";						 
							direction_x <= "00111101";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction_y <= "11111001";						 
							direction_x <= "01000000";

						elsif (y_verschil = 0) then						 
							direction_y <= "00000000";						 
							direction_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction_y <= "00000111";						 
							direction_x <= "01000000";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction_y <= "00010100";						 
							direction_x <= "00111101";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction_y <= "00011111";						 
							direction_x <= "00111000";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction_y <= "00100111";						 
							direction_x <= "00110011";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction_y <= "00101101";						 
							direction_x <= "00101101";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction_y <= "00110010";						 
							direction_x <= "00101001";

						elsif (12 <= y_verschil and y_verschil <= 13) then						 
							direction_y <= "00110101";						 
							direction_x <= "00100100";
						end if;
					end if;
						

					if ((o1='1' and a1='1') and (o2='0' and a2='1')) then 
						direction_x2 <= direction_x;						 
						direction_y2 <= direction_y;
						collision1a2 <= '1';
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_y))+ 1, direction_y1'length));
						collision2a1 <= '1';
						collision1b2 <= '0';
						collision2b1 <= '0';

					elsif ((o1='1' and b1='1') and (o2='0' and b2='1')) then 
						direction_x2 <= direction_x;						 
						direction_y2 <= direction_y;
						collision1b2 <= '1';
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_y))+ 1, direction_y1'length));
						collision2b1 <= '1';
						collision1a2 <= '0';
						collision2a1 <= '0';
						
					elsif ((o1='1' and a1='1') and (o2='0' and b2='1')) then 
						direction_x2 <= direction_x;						 
						direction_y2 <= direction_y;
						collision1a2 <= '1';
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_y))+ 1, direction_y1'length));
						collision2b1 <= '1';
						collision1b2 <= '0';
						collision2a1 <= '0';

					elsif ((o1='1' and b1='1') and (o2='0' and a2='1')) then 
						direction_x2 <= direction_x;						 
						direction_y2 <= direction_y;
						collision1b2 <= '1';
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_y))+ 1, direction_y1'length));
						collision2a1 <= '1';
						collision1a2 <= '0';
						collision2b1 <= '0';

					elsif(o1='1' and a1='1') then
						direction_x2 <= direction_x;						 
						direction_y2 <= direction_y;
						collision1a2 <= '1';
						collision1b2 <= '0';
						direction_y1 <= "00000000";						 
						direction_x1 <= "00000000";
						collision2a1 <= '0';
						collision2b1 <= '0';

					elsif(o2='0' and a2='1')then
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_y))+ 1, direction_y1'length));
						collision2a1 <= '1';
						collision2b1 <= '0';
						direction_y2 <= "00000000";						 
						direction_x2 <= "00000000";
						collision1a2 <= '0';
						collision1b2 <= '0';

					elsif(o1='1' and b1='1')then
						direction_x2 <= direction_x;						 
						direction_y2 <= direction_y;
						collision1b2 <= '1';
						collision1a2 <= '0';
						direction_y1 <= "00000000";						 
						direction_x1 <= "00000000";
						collision2a1 <= '0';
						collision2b1 <= '0';

					elsif(o2='0' and b2='1')then
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_y))+ 1, direction_y1'length));
						collision2b1 <= '1';
						collision2a1 <= '0';
						direction_y2 <= "00000000";						 
						direction_x2 <= "00000000";
						collision1a2 <= '0';
						collision1b2 <= '0';

					end if;


                else
					collision1a2 <= '0';
					collision2a1 <= '0';
					collision1b2 <= '0';
					collision2b1 <= '0';
					direction_y1 <= "00000000";						 
					direction_x1 <= "00000000";
					direction_y2 <= "00000000";						 
					direction_x2 <= "00000000";
				end if;


			elsif ((o1='0' and (a1='1' or b1='1')) or (o2='1' and (a2='1' or b2='1'))) then	

				if (-10 <= x_verschil and x_verschil <= 4) then
						
					if (-10 <= x_verschil and x_verschil < -8) then
						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction_y <= "11001011";						 
							direction_x <= "11011100";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction_y <= "11001110";						 
							direction_x <= "11010111";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction_y <= "11010011";						 
							direction_x <= "11010011";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction_y <= "11011001";						 
							direction_x <= "11001101";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction_y <= "11100001";						 
							direction_x <= "11001000";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction_y <= "11101100";						 
							direction_x <= "11000011";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction_y <= "11111001";						 
							direction_x <= "11000000";

						elsif (y_verschil = 0) then						 
							direction_y <= "00000000";						 
							direction_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction_y <= "00000111";						 
							direction_x <= "11000000";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction_y <= "00010100";						 
							direction_x <= "11000011";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction_y <= "00011111";						 
							direction_x <= "11001000";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction_y <= "00100111";						 
							direction_x <= "11001101";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction_y <= "00101101";						 
							direction_x <= "11010011";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction_y <= "00110010";								 
							direction_x <= "11010111";

						elsif (12 <= y_verschil and y_verschil <= 13) then						 
							direction_y <= "00110101";						 
							direction_x <= "11011100";
						end if;


				    elsif (-8 <= x_verschil and x_verschil < -6) then
					    if (-13 <= y_verschil and y_verschil < -12) then						 
                            direction_y <= "11001000";						 
                           	direction_x <= "11100010";

                       	elsif (-12 <= y_verschil and y_verschil < -10) then						 
                           	direction_y <= "11001010";						 
                            direction_x <= "11011110";

                        elsif (-10 <= y_verschil and y_verschil < -8) then						 
                            direction_y <= "11001101";						 
                            direction_x <= "11011001";

                    	elsif (-8 <= y_verschil and y_verschil < -6) then						 
                            direction_y <= "11010011";						 
                            direction_x <= "11010011";

                        elsif (-6 <= y_verschil and y_verschil < -4) then						 
                            direction_y <= "11011011";						 
                            direction_x <= "11001100";

                        elsif (-4 <= y_verschil and y_verschil < -2) then						 
                            direction_y <= "11100111";						 
                            direction_x <= "11000101";

                        elsif (-2 <= y_verschil and y_verschil < 0) then						 
                            direction_y <= "11110111";						 
                            direction_x <= "11000001";

                        elsif (y_verschil = 0) then						 
                            direction_y <= "00000000";						 
                            direction_x <= "11000000";

                        elsif (0 < y_verschil and y_verschil < 2) then						 
                            direction_y <= "00001001";						 
                            direction_x <= "11000001";

                        elsif (2 <= y_verschil and y_verschil < 4) then						 
                            direction_y <= "00011001";						 
                            direction_x <= "11000101";

                        elsif (4 <= y_verschil and y_verschil < 6) then						 
                            direction_y <= "00100101";						 
                            direction_x <= "11001100";

                        elsif (6 <= y_verschil and y_verschil < 8) then						 
                            direction_y <= "00101101";						 
                            direction_x <= "11010011";

                        elsif (8 <= y_verschil and y_verschil < 10) then						 
                            direction_y <= "00110011";						 
                            direction_x <= "11011001";

                        elsif (10 <= y_verschil and y_verschil < 12) then						 
                            direction_y <= "00110110";								 
                            direction_x <= "11011110";

                        elsif (12 <= y_verschil and y_verschil <= 13) then						 
                            direction_y <= "00111000";						 
                            direction_x <= "11100010";
                        end if;					 
                        

				    elsif (-6 <= x_verschil and x_verschil < -4) then
						if (-13 <= y_verschil and y_verschil < -12) then						 
                            direction_y <= "11000100";						 
                            direction_x <= "11101001";

                        elsif (-12 <= y_verschil and y_verschil < -10) then						 
                            direction_y <= "11000110";						 
                            direction_x <= "11100110";

                        elsif (-10 <= y_verschil and y_verschil < -8) then						 
                            direction_y <= "11001000";						 
                            direction_x <= "11100001";

                        elsif (-8 <= y_verschil and y_verschil < -6) then						 
                            direction_y <= "11001100";						 
                            direction_x <= "11011011";

                        elsif (-6 <= y_verschil and y_verschil < -4) then						 
                            direction_y <= "11010011";						 
                            direction_x <= "11010011";

                        elsif (-4 <= y_verschil and y_verschil < -2) then						 
                            direction_y <= "11011111";						 
                            direction_x <= "11001100";

                        elsif (-2 <= y_verschil and y_verschil < 0) then						 
                            direction_y <= "11110011";						 
                            direction_x <= "11000001";

                        elsif (y_verschil = 0) then						 
                            direction_y <= "00000000";						 
                            direction_x <= "11000000";

                        elsif (0 < y_verschil and y_verschil < 2) then						 
                            direction_y <= "00001101";						 
                            direction_x <= "11000001";

                        elsif (2 <= y_verschil and y_verschil < 4) then						 
                            direction_y <= "00100001";						 
                            direction_x <= "11001100";

                        elsif (4 <= y_verschil and y_verschil < 6) then						 
                            direction_y <= "00101101";						 
                            direction_x <= "11010011";

                        elsif (6 <= y_verschil and y_verschil < 8) then						 
                            direction_y <= "00110100";						 
                            direction_x <= "11011011";

                        elsif (8 <= y_verschil and y_verschil < 10) then						 
                            direction_y <= "00111000";						 
                            direction_x <= "11100001";

                        elsif (10 <= y_verschil and y_verschil < 12) then						 
                            direction_y <= "00111010";												 
                            direction_x <= "11100110";

                        elsif (12 <= y_verschil and y_verschil <= 13) then						 
                            direction_y <= "00111100";						 
                            direction_x <= "11101001";
                        end if;


					elsif (-4 <= x_verschil and x_verschil < -2) then
						if (-13 <= y_verschil and y_verschil < -12) then
							direction_y <= "11000010";						 
							direction_x <= "11110010";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction_y <= "11000010";						 
							direction_x <= "11101111";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction_y <= "11000011";						 
							direction_x <= "11101100";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction_y <= "11000101";						 
							direction_x <= "11100111";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction_y <= "11001001";						 
							direction_x <= "11011111";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction_y <= "11010011";							 
							direction_x <= "11010011";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction_y <= "11101100";						 
							direction_x <= "11000011";

						elsif (y_verschil = 0) then						 
							direction_y <= "00000000";						 
							direction_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction_y <= "00010100";						 
							direction_x <= "11000011";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction_y <= "00101101";						 
							direction_x <= "11010011";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction_y <= "00110111";						 
							direction_x <= "11011111";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction_y <= "00111011";						 
							direction_x <= "11100111";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction_y <= "00111101";						 
							direction_x <= "11101100";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction_y <= "00111110";						 
							direction_x <= "11101111";

						elsif (12 <= y_verschil and y_verschil <= 13) then						 
							direction_y <= "00111110";						 
							direction_x <= "11110010";
						end if;
						

					elsif (-2 <= x_verschil and x_verschil < 0) then
						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction_y <= "11000000";						 
							direction_x <= "11111011";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction_y <= "11000000";						 
							direction_x <= "11111010";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction_y <= "11000000";						 
							direction_x <= "11111001";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction_y <= "11000001";						 
							direction_x <= "11110111";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction_y <= "11000001";						 
							direction_x <= "11110011";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction_y <= "11000011";						 
							direction_x <= "11101100";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction_y <= "11010011";						 
							direction_x <= "11010011";

						elsif (y_verschil = 0) then						 
							direction_y <= "00000000";						 
							direction_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction_y <= "00101101";						 
							direction_x <= "11010011";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction_y <= "00111101";						 
							direction_x <= "11101100";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction_y <= "00111111";						 
							direction_x <= "11110011";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction_y <= "00111111";						 
							direction_x <= "11110111";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction_y <= "01000000";						 
							direction_x <= "11111001";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction_y <= "01000000";						 
							direction_x <= "11111010";

						elsif (12 <= y_verschil and y_verschil <= 13) then						 
							direction_y <= "01000000";						 
							direction_x <= "11111011";						
						end if;
					


					elsif (x_verschil = 0) then
							direction_y <= "00000000";
                   			direction_x <= "01000000";


					elsif (0 < x_verschil and x_verschil < 2) then
						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction_y <= "11000000";						 
							direction_x <= "00000101";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction_y <= "11000000";						 
							direction_x <= "00000110";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction_y <= "11000000";						 
							direction_x <= "00000111";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction_y <= "11000001";						 
							direction_x <= "00001001";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction_y <= "11000001";						 
							direction_x <= "00001101";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction_y <= "11000011";						 
							direction_x <= "00010100";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction_y <= "11000011";						 
							direction_x <= "00101101";

						elsif (y_verschil = 0) then						 
							direction_y <= "00000000";						 
							direction_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction_y <= "00101101";						 
							direction_x <= "00101101";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction_y <= "00111101";						 
							direction_x <= "00010100";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction_y <= "00111111";						 
							direction_x <= "00001101";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction_y <= "00111111";						 
							direction_x <= "00001001";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction_y <= "01000000";						 
							direction_x <= "00000111";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction_y <= "01000000";						 
							direction_x <= "00000110";

						elsif (12 <= y_verschil and y_verschil <= 13) then						 
							direction_y <= "01000000";						 
							direction_x <= "00000101";						
						end if;
					
				
					elsif (2 <= x_verschil and x_verschil <= 4) then
						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction_y <= "11000010";						 
							direction_x <= "00001110";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction_y <= "11000010";						 
							direction_x <= "00010001";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction_y <= "11000011";						 
							direction_x <= "00010100";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction_y <= "11000101";						 
							direction_x <= "00011001";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction_y <= "11001001";						 
							direction_x <= "00100001";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction_y <= "11010011";						 
							direction_x <= "00101101";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction_y <= "11101100";						 
							direction_x <= "00111101";

						elsif (y_verschil = 0) then						 
							direction_y <= "00000000";						 
							direction_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction_y <= "00010100";						 
							direction_x <= "00111101";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction_y <= "00101101";						 
							direction_x <= "00101101";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction_y <= "00110111";						 
							direction_x <= "00100001";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction_y <= "00111011";						 
							direction_x <= "00011001";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction_y <= "00111101";						 
							direction_x <= "00010100";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction_y <= "00111110";								 
							direction_x <= "00010001";

						elsif (12 <= y_verschil and y_verschil <= 13) then						 
							direction_y <= "00111110";						 
							direction_x <= "00001110";
						end if;
					end if;


					
					if ((o1='0' and a1='1') and (o2='1' and a2='1')) then 
						direction_x2 <= direction_x;						 
						direction_y2 <= direction_y;
						collision1a2 <= '1';
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_y))+ 1, direction_y1'length));
						collision2a1 <= '1';
						collision1b2 <= '0';
						collision2b1 <= '0';
					
					elsif ((o1='0' and b1='1') and (o2='1' and b2='1')) then 
						direction_x2 <= direction_x;						 
						direction_y2 <= direction_y;
						collision1b2 <= '1';
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_y))+ 1, direction_y1'length));
						collision2b1 <= '1';
						collision1a2 <= '0';
						collision2a1 <= '0';
						
					elsif ((o1='0' and a1='1') and (o2='1' and b2='1')) then 
						direction_x2 <= direction_x;						 
						direction_y2 <= direction_y;
						collision1a2 <= '1';
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_y))+ 1, direction_y1'length));
						collision2b1 <= '1';
						collision1b2 <= '0';
						collision2a1 <= '0';

					elsif ((o1='0' and b1='1') and (o2='1' and a2='1')) then 
						direction_x2 <= direction_x;						 
						direction_y2 <= direction_y;
						collision1b2 <= '1';
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_y))+ 1, direction_y1'length));
						collision2a1 <= '1';
						collision1a2 <= '0';
						collision2b1 <= '0';

					elsif(o1='0' and a1='1')then
						direction_x2 <= direction_x;						 
						direction_y2 <= direction_y;
						collision1a2 <= '1';
						collision1b2 <= '0';
						direction_y1 <= "00000000";						 
						direction_x1 <= "00000000";
						collision2a1 <= '0';
						collision2b1 <= '0';

					elsif(o2='1' and a2='1')then
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_y))+ 1, direction_y1'length));
						collision2a1 <= '1';
						collision2b1 <= '0';
						direction_y2 <= "00000000";						 
						direction_x2 <= "00000000";
						collision1a2 <= '0';
						collision1b2 <= '0';
					
					elsif(o1='0' and b1='1') then
						direction_x2 <= direction_x;						 
						direction_y2 <= direction_y;
						collision1b2 <= '1';
						collision1a2 <= '0';
						direction_y1 <= "00000000";						 
						direction_x1 <= "00000000";
						collision2a1 <= '0';
						collision2b1 <= '0';

					elsif(o2='1' and b2='1')then
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction_y))+ 1, direction_y1'length));
						collision2b1 <= '1';
						collision2a1 <= '0';
						direction_y2 <= "00000000";						 
						direction_x2 <= "00000000";
						collision1a2 <= '0';
						collision1b2 <= '0';
					end if;
				
				
				
				else
					collision1a2 <= '0';
					collision2a1 <= '0';
					collision1b2 <= '0';
					collision2b1 <= '0';
					direction_y1 <= "00000000";						 
					direction_x1 <= "00000000";
					direction_y2 <= "00000000";						 
					direction_x2 <= "00000000";
				
				end if;


			else
				collision1a2 <= '0';
				collision2a1 <= '0';
				collision1b2 <= '0';
				collision2b1 <= '0';
				direction_y1 <= "00000000";						 
				direction_x1 <= "00000000";
				direction_y2 <= "00000000";						 
				direction_x2 <= "00000000";
            end if;
		
		else 
		collision1a2 <= '0';
		collision2a1 <= '0';
		collision1b2 <= '0';
		collision2b1 <= '0';
		direction_y1 <= "00000000";						 
		direction_x1 <= "00000000";
		direction_y2 <= "00000000";						 
		direction_x2 <= "00000000";
		end if;

	end process;
	

end behaviour;
