library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

architecture behaviour of coldet is

signal x1_in,x2_in,y1_in,y2_in : integer;
signal x_verschil, y_verschil : integer;
signal direction1_y, direction1_x, direction2_y, direction2_x: std_logic_vector(7 downto 0);

begin
x1_in <= to_integer(unsigned(x1));
x2_in <= to_integer(unsigned(x2));
y1_in <= to_integer(unsigned(y1));
y2_in <= to_integer(unsigned(y2));

x_verschil <= x2_in - x1_in;
y_verschil <= y2_in - y1_in;


	--process for collision detection player 1

lbl1: process(x_verschil, y_verschil, a1, b1, o1, direction1_x, direction1_y)
	begin

		if ((a1='1' or b1='1') and (-13 <= y_verschil and y_verschil <= 13)) then

            if ((o1='1' and (a1='1' or b1='1'))) then											--(a1='1' or b1='1') just to be sure
				
				if (-4 <= x_verschil and x_verschil <= 10) then
						
					if (-4 <= x_verschil and x_verschil < -2) then

						if (-13 <= y_verschil and y_verschil < -12) then
							direction1_y <= "11000010";						 
							direction1_x <= "11110010";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction1_y <= "11000010";						 
							direction1_x <= "11101111";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction1_y <= "11000011";						 
							direction1_x <= "11101100";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction1_y <= "11000101";						 
							direction1_x <= "11100111";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction1_y <= "11001001";						 
							direction1_x <= "11011111";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction1_y <= "11010011";							 
							direction1_x <= "11010011";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction1_y <= "11101100";						 
							direction1_x <= "11000011";

						elsif (y_verschil = 0) then						 
							direction1_y <= "00000000";						 
							direction1_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction1_y <= "00010100";						 
							direction1_x <= "11000011";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction1_y <= "00101101";						 
							direction1_x <= "11010011";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction1_y <= "00110111";						 
							direction1_x <= "11011111";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction1_y <= "00111011";						 
							direction1_x <= "11100111";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction1_y <= "00111101";						 
							direction1_x <= "11101100";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction1_y <= "00111110";						 
							direction1_x <= "11101111";

						else														-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction1_y <= "00111110";						 
							direction1_x <= "11110010";
						end if;
				

					elsif (-2 <= x_verschil and x_verschil < 0) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction1_y <= "11000000";						 
							direction1_x <= "11111011";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction1_y <= "11000000";						 
							direction1_x <= "11111010";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction1_y <= "11000000";						 
							direction1_x <= "11111001";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction1_y <= "11000001";						 
							direction1_x <= "11110111";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction1_y <= "11000001";						 
							direction1_x <= "11110011";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction1_y <= "11000011";						 
							direction1_x <= "11101100";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction1_y <= "11010011";						 
							direction1_x <= "11010011";

						elsif (y_verschil = 0) then						 
							direction1_y <= "00000000";						 
							direction1_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction1_y <= "00101101";						 
							direction1_x <= "11010011";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction1_y <= "00111101";						 
							direction1_x <= "11101100";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction1_y <= "00111111";						 
							direction1_x <= "11110011";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction1_y <= "00111111";						 
							direction1_x <= "11110111";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction1_y <= "01000000";						 
							direction1_x <= "11111001";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction1_y <= "01000000";						 
							direction1_x <= "11111010";

						else 														-- has to be between (12 <= y_verschil and y_verschil <= 13) 					 
							direction1_y <= "01000000";						 
							direction1_x <= "11111011";
						end if;


					elsif (x_verschil = 0) then
							direction1_y <= "00000000";
                   			direction1_x <= "01000000";


					elsif (0 < x_verschil and x_verschil < 2) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction1_y <= "11000000";						 
							direction1_x <= "00000101";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction1_y <= "11000000";						 
							direction1_x <= "00000110";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction1_y <= "11000000";						 
							direction1_x <= "00000111";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction1_y <= "11000001";						 
							direction1_x <= "00001001";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction1_y <= "11000001";						 
							direction1_x <= "00001101";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction1_y <= "11000011";						 
							direction1_x <= "00010100";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction1_y <= "11000011";						 
							direction1_x <= "00101101";

						elsif (y_verschil = 0) then						 
							direction1_y <= "00000000";						 
							direction1_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction1_y <= "00101101";						 
							direction1_x <= "00101101";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction1_y <= "00111101";						 
							direction1_x <= "00010100";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction1_y <= "00111111";						 
							direction1_x <= "00001101";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction1_y <= "00111111";						 
							direction1_x <= "00001001";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction1_y <= "01000000";						 
							direction1_x <= "00000111";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction1_y <= "01000000";						 
							direction1_x <= "00000110";

						else 														-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction1_y <= "01000000";						 
							direction1_x <= "00000101";
						end if;
					
				
					elsif (2 <= x_verschil and x_verschil <= 4) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction1_y <= "11000010";						 
							direction1_x <= "00001110";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction1_y <= "11000010";						 
							direction1_x <= "00010001";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction1_y <= "11000011";						 
							direction1_x <= "00010100";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction1_y <= "11000101";						 
							direction1_x <= "00011001";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction1_y <= "11001001";						 
							direction1_x <= "00100001";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction1_y <= "11010011";						 
							direction1_x <= "00101101";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction1_y <= "11101100";						 
							direction1_x <= "00111101";

						elsif (y_verschil = 0) then						 
							direction1_y <= "00000000";						 
							direction1_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction1_y <= "00010100";						 
							direction1_x <= "00111101";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction1_y <= "00101101";						 
							direction1_x <= "00101101";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction1_y <= "00110111";						 
							direction1_x <= "00100001";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction1_y <= "00111011";						 
							direction1_x <= "00011001";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction1_y <= "00111101";						 
							direction1_x <= "00010100";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction1_y <= "00111110";								 
							direction1_x <= "00010001";

						else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction1_y <= "00111110";						 
							direction1_x <= "00001110";
						end if;
									
					
					elsif (4 < x_verschil and x_verschil <= 6) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction1_y <= "11000100";						 
							direction1_x <= "00010111";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction1_y <= "11000110";						 
							direction1_x <= "00011010";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction1_y <= "11001000";						 
							direction1_x <= "00011111";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction1_y <= "11001100";						 
							direction1_x <= "00100101";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction1_y <= "11010011";						 
							direction1_x <= "00101101";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction1_y <= "11011111";						 
							direction1_x <= "00110111";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction1_y <= "11110011";						 
							direction1_x <= "00111111";

						elsif (y_verschil = 0) then						 
							direction1_y <= "00000000";						 
							direction1_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction1_y <= "00001101";					 
							direction1_x <= "00111111";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction1_y <= "00100001";						 
							direction1_x <= "00110111";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction1_y <= "00101101";						 
							direction1_x <= "00101101";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction1_y <= "00110100";						 
							direction1_x <= "00100101";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction1_y <= "00111000";						 
							direction1_x <= "00011111";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction1_y <= "00111010";						 
							direction1_x <= "00011010";

						else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction1_y <= "00111100";						 
							direction1_x <= "00010111";
						end if;


					elsif (6 < x_verschil and x_verschil <= 8) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction1_y <= "11001000";						 
							direction1_x <= "00011110";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction1_y <= "11001010";						 
							direction1_x <= "00100010";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction1_y <= "11001101";						 
							direction1_x <= "00100111";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction1_y <= "11010011";						 
							direction1_x <= "00101101";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction1_y <= "11011011";						 
							direction1_x <= "00110100";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction1_y <= "11100111";						 
							direction1_x <= "00111011";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction1_y <= "11110111";						 
							direction1_x <= "00111111";

						elsif (y_verschil = 0) then						 
							direction1_y <= "00000000";												 
							direction1_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction1_y <= "00001001";						 
							direction1_x <= "00111111";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction1_y <= "00011001";						 
							direction1_x <= "00111011";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction1_y <= "00100101";						 
							direction1_x <= "00110100";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction1_y <= "00101101";						 
							direction1_x <= "00101101";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction1_y <= "00110011";						 
							direction1_x <= "00100111";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction1_y <= "00110110";						 
							direction1_x <= "00100010";

						else 														-- has to be between (12 <= y_verschil and y_verschil <= 13) 					 
							direction1_y <= "00111000";						 
							direction1_x <= "00011110";											
						end if;
					

                	else 															-- has to be between (8 < x_verschil and x_verschil <= 10) 
						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction1_y <= "11001011";						 
							direction1_x <= "00100100";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction1_y <= "11001110";						 
							direction1_x <= "00101001";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction1_y <= "11010011";						 
							direction1_x <= "00101101";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction1_y <= "11011001";																
							direction1_x <= "00110011";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction1_y <= "11100001";						 
							direction1_x <= "00111000";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction1_y <= "11101100";						 
							direction1_x <= "00111101";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction1_y <= "11111001";						 
							direction1_x <= "01000000";

						elsif (y_verschil = 0) then						 
							direction1_y <= "00000000";						 
							direction1_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction1_y <= "00000111";						 
							direction1_x <= "01000000";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction1_y <= "00010100";						 
							direction1_x <= "00111101";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction1_y <= "00011111";						 
							direction1_x <= "00111000";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction1_y <= "00100111";						 
							direction1_x <= "00110011";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction1_y <= "00101101";						 
							direction1_x <= "00101101";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction1_y <= "00110010";						 
							direction1_x <= "00101001";

						else													-- has to be between (12 <= y_verschil and y_verschil <= 13)						 
							direction1_y <= "00110101";						 
							direction1_x <= "00100100";
						end if;

					end if;
						

					if(o1='1' and a1='1') then
						direction_x2 <= direction1_x;						 
						direction_y2 <= direction1_y;
						collision1a2 <= '1';
						collision1b2 <= '0';

					else														-- has to be be (o1='1' and b1='1')
						direction_x2 <= direction1_x;						 
						direction_y2 <= direction1_y;
						collision1a2 <= '0';
						collision1b2 <= '1';
					end if;


                else
					direction1_y <= "00000000";
					direction1_x <= "00000000";
					direction_y2 <= "00000000";
					direction_x2 <= "00000000";
					collision1a2 <= '0';
					collision1b2 <= '0';
				end if;


			elsif ((o1='0' and (a1='1' or b1='1'))) then						--(a1='1' or b1='1') just to be sure

				if (-10 <= x_verschil and x_verschil <= 4) then
						
					if (-10 <= x_verschil and x_verschil < -8) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction1_y <= "11001011";						 
							direction1_x <= "11011100";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction1_y <= "11001110";						 
							direction1_x <= "11010111";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction1_y <= "11010011";						 
							direction1_x <= "11010011";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction1_y <= "11011001";						 
							direction1_x <= "11001101";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction1_y <= "11100001";						 
							direction1_x <= "11001000";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction1_y <= "11101100";						 
							direction1_x <= "11000011";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction1_y <= "11111001";						 
							direction1_x <= "11000000";

						elsif (y_verschil = 0) then						 
							direction1_y <= "00000000";						 
							direction1_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction1_y <= "00000111";						 
							direction1_x <= "11000000";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction1_y <= "00010100";						 
							direction1_x <= "11000011";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction1_y <= "00011111";						 
							direction1_x <= "11001000";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction1_y <= "00100111";						 
							direction1_x <= "11001101";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction1_y <= "00101101";						 
							direction1_x <= "11010011";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction1_y <= "00110010";								 
							direction1_x <= "11010111";

						else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction1_y <= "00110101";				
							direction1_x <= "11011100";						
						end if;


				    elsif (-8 <= x_verschil and x_verschil < -6) then

					    if (-13 <= y_verschil and y_verschil < -12) then						 
                            direction1_y <= "11001000";						 
                           	direction1_x <= "11100010";

                       	elsif (-12 <= y_verschil and y_verschil < -10) then						 
                           	direction1_y <= "11001010";						 
                            direction1_x <= "11011110";

                        elsif (-10 <= y_verschil and y_verschil < -8) then						 
                            direction1_y <= "11001101";						 
                            direction1_x <= "11011001";

                    	elsif (-8 <= y_verschil and y_verschil < -6) then						 
                            direction1_y <= "11010011";						 
                            direction1_x <= "11010011";

                        elsif (-6 <= y_verschil and y_verschil < -4) then						 
                            direction1_y <= "11011011";						 
                            direction1_x <= "11001100";

                        elsif (-4 <= y_verschil and y_verschil < -2) then						 
                            direction1_y <= "11100111";						 
                            direction1_x <= "11000101";

                        elsif (-2 <= y_verschil and y_verschil < 0) then						 
                            direction1_y <= "11110111";						 
                            direction1_x <= "11000001";

                        elsif (y_verschil = 0) then						 
                            direction1_y <= "00000000";						 
                            direction1_x <= "11000000";

                        elsif (0 < y_verschil and y_verschil < 2) then						 
                            direction1_y <= "00001001";						 
                            direction1_x <= "11000001";

                        elsif (2 <= y_verschil and y_verschil < 4) then						 
                            direction1_y <= "00011001";						 
                            direction1_x <= "11000101";

                        elsif (4 <= y_verschil and y_verschil < 6) then						 
                            direction1_y <= "00100101";						 
                            direction1_x <= "11001100";

                        elsif (6 <= y_verschil and y_verschil < 8) then						 
                            direction1_y <= "00101101";						 
                            direction1_x <= "11010011";

                        elsif (8 <= y_verschil and y_verschil < 10) then						 
                            direction1_y <= "00110011";						 
                            direction1_x <= "11011001";

                        elsif (10 <= y_verschil and y_verschil < 12) then						 
                            direction1_y <= "00110110";								 
                            direction1_x <= "11011110";

                        else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
                            direction1_y <= "00111000";						 
                            direction1_x <= "11100010";						
                        end if;					 
                        

				    elsif (-6 <= x_verschil and x_verschil < -4) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
                            direction1_y <= "11000100";						 
                            direction1_x <= "11101001";

                        elsif (-12 <= y_verschil and y_verschil < -10) then						 
                            direction1_y <= "11000110";						 
                            direction1_x <= "11100110";

                        elsif (-10 <= y_verschil and y_verschil < -8) then						 
                            direction1_y <= "11001000";						 
                            direction1_x <= "11100001";

                        elsif (-8 <= y_verschil and y_verschil < -6) then						 
                            direction1_y <= "11001100";						 
                            direction1_x <= "11011011";

                        elsif (-6 <= y_verschil and y_verschil < -4) then						 
                            direction1_y <= "11010011";						 
                            direction1_x <= "11010011";

                        elsif (-4 <= y_verschil and y_verschil < -2) then						 
                            direction1_y <= "11011111";						 
                            direction1_x <= "11001100";

                        elsif (-2 <= y_verschil and y_verschil < 0) then						 
                            direction1_y <= "11110011";						 
                            direction1_x <= "11000001";

                        elsif (y_verschil = 0) then						 
                            direction1_y <= "00000000";						 
                            direction1_x <= "11000000";

                        elsif (0 < y_verschil and y_verschil < 2) then						 
                            direction1_y <= "00001101";						 
                            direction1_x <= "11000001";

                        elsif (2 <= y_verschil and y_verschil < 4) then						 
                            direction1_y <= "00100001";						 
                            direction1_x <= "11001100";

                        elsif (4 <= y_verschil and y_verschil < 6) then						 
                            direction1_y <= "00101101";						 
                            direction1_x <= "11010011";

                        elsif (6 <= y_verschil and y_verschil < 8) then						 
                            direction1_y <= "00110100";						 
                            direction1_x <= "11011011";

                        elsif (8 <= y_verschil and y_verschil < 10) then						 
                            direction1_y <= "00111000";						 
                            direction1_x <= "11100001";

                        elsif (10 <= y_verschil and y_verschil < 12) then						 
                            direction1_y <= "00111010";												 
                            direction1_x <= "11100110";

                        else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
                            direction1_y <= "00111100";						 
                            direction1_x <= "11101001";
                        end if;


					elsif (-4 <= x_verschil and x_verschil < -2) then

						if (-13 <= y_verschil and y_verschil < -12) then
							direction1_y <= "11000010";						 
							direction1_x <= "11110010";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction1_y <= "11000010";						 
							direction1_x <= "11101111";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction1_y <= "11000011";						 
							direction1_x <= "11101100";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction1_y <= "11000101";						 
							direction1_x <= "11100111";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction1_y <= "11001001";						 
							direction1_x <= "11011111";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction1_y <= "11010011";							 
							direction1_x <= "11010011";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction1_y <= "11101100";						 
							direction1_x <= "11000011";

						elsif (y_verschil = 0) then						 
							direction1_y <= "00000000";						 
							direction1_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction1_y <= "00010100";						 
							direction1_x <= "11000011";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction1_y <= "00101101";						 
							direction1_x <= "11010011";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction1_y <= "00110111";						 
							direction1_x <= "11011111";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction1_y <= "00111011";						 
							direction1_x <= "11100111";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction1_y <= "00111101";						 
							direction1_x <= "11101100";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction1_y <= "00111110";						 
							direction1_x <= "11101111";

						else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction1_y <= "00111110";						 
							direction1_x <= "11110010";
						end if;
						

					elsif (-2 <= x_verschil and x_verschil < 0) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction1_y <= "11000000";						 
							direction1_x <= "11111011";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction1_y <= "11000000";						 
							direction1_x <= "11111010";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction1_y <= "11000000";						 
							direction1_x <= "11111001";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction1_y <= "11000001";						 
							direction1_x <= "11110111";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction1_y <= "11000001";						 
							direction1_x <= "11110011";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction1_y <= "11000011";						 
							direction1_x <= "11101100";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction1_y <= "11010011";						 
							direction1_x <= "11010011";

						elsif (y_verschil = 0) then						 
							direction1_y <= "00000000";						 
							direction1_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction1_y <= "00101101";						 
							direction1_x <= "11010011";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction1_y <= "00111101";						 
							direction1_x <= "11101100";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction1_y <= "00111111";						 
							direction1_x <= "11110011";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction1_y <= "00111111";						 
							direction1_x <= "11110111";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction1_y <= "01000000";						 
							direction1_x <= "11111001";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction1_y <= "01000000";						 
							direction1_x <= "11111010";

						else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction1_y <= "01000000";						 
							direction1_x <= "11111011";							
						end if;
					

					elsif (x_verschil = 0) then
							direction1_y <= "00000000";
                   			direction1_x <= "01000000";


					elsif (0 < x_verschil and x_verschil < 2) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction1_y <= "11000000";						 
							direction1_x <= "00000101";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction1_y <= "11000000";						 
							direction1_x <= "00000110";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction1_y <= "11000000";						 
							direction1_x <= "00000111";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction1_y <= "11000001";						 
							direction1_x <= "00001001";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction1_y <= "11000001";						 
							direction1_x <= "00001101";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction1_y <= "11000011";						 
							direction1_x <= "00010100";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction1_y <= "11000011";						 
							direction1_x <= "00101101";

						elsif (y_verschil = 0) then						 
							direction1_y <= "00000000";						 
							direction1_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction1_y <= "00101101";						 
							direction1_x <= "00101101";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction1_y <= "00111101";						 
							direction1_x <= "00010100";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction1_y <= "00111111";						 
							direction1_x <= "00001101";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction1_y <= "00111111";						 
							direction1_x <= "00001001";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction1_y <= "01000000";						 
							direction1_x <= "00000111";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction1_y <= "01000000";						 
							direction1_x <= "00000110";

						else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction1_y <= "01000000";						 
							direction1_x <= "00000101";						
						end if;
					
				
					else 														-- has to be between (2 <= x_verschil and x_verschil <= 4) 
						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction1_y <= "11000010";						 
							direction1_x <= "00001110";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction1_y <= "11000010";						 
							direction1_x <= "00010001";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction1_y <= "11000011";						 
							direction1_x <= "00010100";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction1_y <= "11000101";						 
							direction1_x <= "00011001";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction1_y <= "11001001";						 
							direction1_x <= "00100001";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction1_y <= "11010011";						 
							direction1_x <= "00101101";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction1_y <= "11101100";						 
							direction1_x <= "00111101";

						elsif (y_verschil = 0) then						 
							direction1_y <= "00000000";						 
							direction1_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction1_y <= "00010100";						 
							direction1_x <= "00111101";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction1_y <= "00101101";						 
							direction1_x <= "00101101";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction1_y <= "00110111";						 
							direction1_x <= "00100001";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction1_y <= "00111011";						 
							direction1_x <= "00011001";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction1_y <= "00111101";						 
							direction1_x <= "00010100";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction1_y <= "00111110";								 
							direction1_x <= "00010001";

						else 														-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction1_y <= "00111110";						 
							direction1_x <= "00001110";
						end if;
					
					end if;


					if(o1='0' and a1='1') then
						direction_x2 <= direction1_x;						 
						direction_y2 <= direction1_y;
						collision1a2 <= '1';
						collision1b2 <= '0';

					else															-- means that it has to be (o1='0' and b1='1')
						direction_x2 <= direction1_x;						 
						direction_y2 <= direction1_y;
						collision1a2 <= '0';
						collision1b2 <= '1';
					end if;
								
				
				else
					direction1_y <= "00000000";						 
					direction1_x <= "00000000";	
					direction_y2 <= "00000000";
					direction_x2 <= "00000000";
					collision1a2 <= '0';
					collision1b2 <= '0';				
				end if;


			else
				direction1_y <= "00000000";						 
				direction1_x <= "00000000";
				direction_x2 <= "00000000";	
				direction_y2 <= "00000000";
				collision1a2 <= '0';
				collision1b2 <= '0';
			end if;

		
		else 
		direction1_y <= "00000000";						 
		direction1_x <= "00000000";
		direction_x2 <= "00000000";
		direction_y2 <= "00000000";
		collision1a2 <= '0';		
		collision1b2 <= '0';		
		end if;

	end process;

	



	--process for collision detection player 2

lbl: process(x_verschil, y_verschil, a2, a1, b1, b2, o2, direction2_y, direction2_x)
	begin

		if ((a2='1' or b2='1') and (-13 <= y_verschil and y_verschil <= 13)) then

            if ((o2='0' and (a2='1' or b2='1'))) then											--(a2='1' or b2='1') just to be sure
				
				if (-4 <= x_verschil and x_verschil <= 10) then
						
					if (-4 <= x_verschil and x_verschil < -2) then
						
						if (-13 <= y_verschil and y_verschil < -12) then
							direction2_y <= "11000010";						 
							direction2_x <= "11110010";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction2_y <= "11000010";						 
							direction2_x <= "11101111";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction2_y <= "11000011";						 
							direction2_x <= "11101100";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction2_y <= "11000101";						 
							direction2_x <= "11100111";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction2_y <= "11001001";						 
							direction2_x <= "11011111";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction2_y <= "11010011";							 
							direction2_x <= "11010011";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction2_y <= "11101100";						 
							direction2_x <= "11000011";

						elsif (y_verschil = 0) then						 
							direction2_y <= "00000000";						 
							direction2_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction2_y <= "00010100";						 
							direction2_x <= "11000011";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction2_y <= "00101101";						 
							direction2_x <= "11010011";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction2_y <= "00110111";						 
							direction2_x <= "11011111";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction2_y <= "00111011";						 
							direction2_x <= "11100111";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction2_y <= "00111101";						 
							direction2_x <= "11101100";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction2_y <= "00111110";						 
							direction2_x <= "11101111";

						else														-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction2_y <= "00111110";						 
							direction2_x <= "11110010";
						end if;
				

					elsif (-2 <= x_verschil and x_verschil < 0) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction2_y <= "11000000";						 
							direction2_x <= "11111011";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction2_y <= "11000000";						 
							direction2_x <= "11111010";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction2_y <= "11000000";						 
							direction2_x <= "11111001";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction2_y <= "11000001";						 
							direction2_x <= "11110111";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction2_y <= "11000001";						 
							direction2_x <= "11110011";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction2_y <= "11000011";						 
							direction2_x <= "11101100";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction2_y <= "11010011";						 
							direction2_x <= "11010011";

						elsif (y_verschil = 0) then						 
							direction2_y <= "00000000";						 
							direction2_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction2_y <= "00101101";						 
							direction2_x <= "11010011";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction2_y <= "00111101";						 
							direction2_x <= "11101100";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction2_y <= "00111111";						 
							direction2_x <= "11110011";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction2_y <= "00111111";						 
							direction2_x <= "11110111";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction2_y <= "01000000";						 
							direction2_x <= "11111001";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction2_y <= "01000000";						 
							direction2_x <= "11111010";

						else 														-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction2_y <= "01000000";						 
							direction2_x <= "11111011";
						end if;


					elsif (x_verschil = 0) then
							direction2_y <= "00000000";
                   			direction2_x <= "01000000";


					elsif (0 < x_verschil and x_verschil < 2) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction2_y <= "11000000";						 
							direction2_x <= "00000101";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction2_y <= "11000000";						 
							direction2_x <= "00000110";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction2_y <= "11000000";						 
							direction2_x <= "00000111";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction2_y <= "11000001";						 
							direction2_x <= "00001001";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction2_y <= "11000001";						 
							direction2_x <= "00001101";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction2_y <= "11000011";						 
							direction2_x <= "00010100";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction2_y <= "11000011";						 
							direction2_x <= "00101101";

						elsif (y_verschil = 0) then						 
							direction2_y <= "00000000";						 
							direction2_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction2_y <= "00101101";						 
							direction2_x <= "00101101";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction2_y <= "00111101";						 
							direction2_x <= "00010100";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction2_y <= "00111111";						 
							direction2_x <= "00001101";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction2_y <= "00111111";						 
							direction2_x <= "00001001";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction2_y <= "01000000";						 
							direction2_x <= "00000111";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction2_y <= "01000000";						 
							direction2_x <= "00000110";

						else 														-- has to be between (12 <= y_verschil and y_verschil <= 13) 					 
							direction2_y <= "01000000";						 
							direction2_x <= "00000101";							
						end if;
					

				
					elsif (2 <= x_verschil and x_verschil <= 4) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction2_y <= "11000010";						 
							direction2_x <= "00001110";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction2_y <= "11000010";						 
							direction2_x <= "00010001";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction2_y <= "11000011";						 
							direction2_x <= "00010100";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction2_y <= "11000101";						 
							direction2_x <= "00011001";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction2_y <= "11001001";						 
							direction2_x <= "00100001";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction2_y <= "11010011";						 
							direction2_x <= "00101101";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction2_y <= "11101100";						 
							direction2_x <= "00111101";

						elsif (y_verschil = 0) then						 
							direction2_y <= "00000000";						 
							direction2_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction2_y <= "00010100";						 
							direction2_x <= "00111101";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction2_y <= "00101101";						 
							direction2_x <= "00101101";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction2_y <= "00110111";						 
							direction2_x <= "00100001";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction2_y <= "00111011";						 
							direction2_x <= "00011001";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction2_y <= "00111101";						 
							direction2_x <= "00010100";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction2_y <= "00111110";								 
							direction2_x <= "00010001";

						else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction2_y <= "00111110";						 
							direction2_x <= "00001110";
						end if;
									
					
					elsif (4 < x_verschil and x_verschil <= 6) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction2_y <= "11000100";						 
							direction2_x <= "00010111";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction2_y <= "11000110";						 
							direction2_x <= "00011010";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction2_y <= "11001000";						 
							direction2_x <= "00011111";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction2_y <= "11001100";						 
							direction2_x <= "00100101";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction2_y <= "11010011";						 
							direction2_x <= "00101101";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction2_y <= "11011111";						 
							direction2_x <= "00110111";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction2_y <= "11110011";						 
							direction2_x <= "00111111";

						elsif (y_verschil = 0) then						 
							direction2_y <= "00000000";						 
							direction2_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction2_y <= "00001101";					 
							direction2_x <= "00111111";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction2_y <= "00100001";						 
							direction2_x <= "00110111";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction2_y <= "00101101";						 
							direction2_x <= "00101101";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction2_y <= "00110100";						 
							direction2_x <= "00100101";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction2_y <= "00111000";						 
							direction2_x <= "00011111";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction2_y <= "00111010";						 
							direction2_x <= "00011010";

						else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction2_y <= "00111100";						 
							direction2_x <= "00010111";
						end if;


					elsif (6 < x_verschil and x_verschil <= 8) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction2_y <= "11001000";						 
							direction2_x <= "00011110";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction2_y <= "11001010";						 
							direction2_x <= "00100010";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction2_y <= "11001101";						 
							direction2_x <= "00100111";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction2_y <= "11010011";						 
							direction2_x <= "00101101";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction2_y <= "11011011";						 
							direction2_x <= "00110100";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction2_y <= "11100111";						 
							direction2_x <= "00111011";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction2_y <= "11110111";						 
							direction2_x <= "00111111";

						elsif (y_verschil = 0) then						 
							direction2_y <= "00000000";												 
							direction2_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction2_y <= "00001001";						 
							direction2_x <= "00111111";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction2_y <= "00011001";						 
							direction2_x <= "00111011";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction2_y <= "00100101";						 
							direction2_x <= "00110100";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction2_y <= "00101101";						 
							direction2_x <= "00101101";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction2_y <= "00110011";						 
							direction2_x <= "00100111";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction2_y <= "00110110";						 
							direction2_x <= "00100010";

						else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction2_y <= "00111000";						 
							direction2_x <= "00011110";				
						end if;
					

                	else 														-- has to be between (8 < x_verschil and x_verschil <= 10) 
						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction2_y <= "11001011";						 
							direction2_x <= "00100100";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction2_y <= "11001110";						 
							direction2_x <= "00101001";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction2_y <= "11010011";						 
							direction2_x <= "00101101";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction2_y <= "11011001";																
							direction2_x <= "00110011";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction2_y <= "11100001";						 
							direction2_x <= "00111000";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction2_y <= "11101100";						 
							direction2_x <= "00111101";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction2_y <= "11111001";						 
							direction2_x <= "01000000";

						elsif (y_verschil = 0) then						 
							direction2_y <= "00000000";						 
							direction2_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction2_y <= "00000111";						 
							direction2_x <= "01000000";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction2_y <= "00010100";						 
							direction2_x <= "00111101";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction2_y <= "00011111";						 
							direction2_x <= "00111000";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction2_y <= "00100111";						 
							direction2_x <= "00110011";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction2_y <= "00101101";						 
							direction2_x <= "00101101";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction2_y <= "00110010";						 
							direction2_x <= "00101001";

						else													-- has to be between (12 <= y_verschil and y_verschil <= 13)						 
							direction2_y <= "00110101";						 
							direction2_x <= "00100100";
						end if;

					end if;
						

					if(o2='0' and a2='1') then
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction2_x))+ 1, direction_x1'length));				 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction2_y))+ 1, direction_y1'length));		
						collision2a1 <= '1';
						collision2b1 <= '0';

					else														-- has to be be (o2='0' and b2='1')
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction2_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction2_y))+ 1, direction_y1'length));
						collision2a1 <= '0';
						collision2b1 <= '1';
					end if;


                else
					direction2_y <= "00000000";						 
					direction2_x <= "00000000";	
					direction_y1 <= "00000000";
					direction_x1 <= "00000000";
					collision2a1 <= '0';
					collision2b1 <= '0';
				end if;


			elsif ((o2='1' and (a1='1' or b1='1'))) then										--(a2='1' or b2='1') just to be sure

				if (-10 <= x_verschil and x_verschil <= 4) then
						
					if (-10 <= x_verschil and x_verschil < -8) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction2_y <= "11001011";						 
							direction2_x <= "11011100";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction2_y <= "11001110";						 
							direction2_x <= "11010111";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction2_y <= "11010011";						 
							direction2_x <= "11010011";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction2_y <= "11011001";						 
							direction2_x <= "11001101";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction2_y <= "11100001";						 
							direction2_x <= "11001000";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction2_y <= "11101100";						 
							direction2_x <= "11000011";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction2_y <= "11111001";						 
							direction2_x <= "11000000";

						elsif (y_verschil = 0) then						 
							direction2_y <= "00000000";						 
							direction2_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction2_y <= "00000111";						 
							direction2_x <= "11000000";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction2_y <= "00010100";						 
							direction2_x <= "11000011";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction2_y <= "00011111";						 
							direction2_x <= "11001000";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction2_y <= "00100111";						 
							direction2_x <= "11001101";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction2_y <= "00101101";						 
							direction2_x <= "11010011";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction2_y <= "00110010";								 
							direction2_x <= "11010111";

						else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 					 
							direction2_y <= "00110101";						 
							direction2_x <= "11011100";
						end if;


				    elsif (-8 <= x_verschil and x_verschil < -6) then

					    if (-13 <= y_verschil and y_verschil < -12) then						 
                            direction2_y <= "11001000";						 
                           	direction2_x <= "11100010";

                       	elsif (-12 <= y_verschil and y_verschil < -10) then						 
                           	direction2_y <= "11001010";						 
                            direction2_x <= "11011110";

                        elsif (-10 <= y_verschil and y_verschil < -8) then						 
                            direction2_y <= "11001101";						 
                            direction2_x <= "11011001";

                    	elsif (-8 <= y_verschil and y_verschil < -6) then						 
                            direction2_y <= "11010011";						 
                            direction2_x <= "11010011";

                        elsif (-6 <= y_verschil and y_verschil < -4) then						 
                            direction2_y <= "11011011";						 
                            direction2_x <= "11001100";

                        elsif (-4 <= y_verschil and y_verschil < -2) then						 
                            direction2_y <= "11100111";						 
                            direction2_x <= "11000101";

                        elsif (-2 <= y_verschil and y_verschil < 0) then						 
                            direction2_y <= "11110111";						 
                            direction2_x <= "11000001";

                        elsif (y_verschil = 0) then						 
                            direction2_y <= "00000000";						 
                            direction2_x <= "11000000";

                        elsif (0 < y_verschil and y_verschil < 2) then						 
                            direction2_y <= "00001001";						 
                            direction2_x <= "11000001";

                        elsif (2 <= y_verschil and y_verschil < 4) then						 
                            direction2_y <= "00011001";						 
                            direction2_x <= "11000101";

                        elsif (4 <= y_verschil and y_verschil < 6) then						 
                            direction2_y <= "00100101";						 
                            direction2_x <= "11001100";

                        elsif (6 <= y_verschil and y_verschil < 8) then						 
                            direction2_y <= "00101101";						 
                            direction2_x <= "11010011";

                        elsif (8 <= y_verschil and y_verschil < 10) then						 
                            direction2_y <= "00110011";						 
                            direction2_x <= "11011001";

                        elsif (10 <= y_verschil and y_verschil < 12) then						 
                            direction2_y <= "00110110";								 
                            direction2_x <= "11011110";

                        else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
                            direction2_y <= "00111000";						 
                            direction2_x <= "11100010";
                        end if;					 
                        

				    elsif (-6 <= x_verschil and x_verschil < -4) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
                            direction2_y <= "11000100";						 
                            direction2_x <= "11101001";

                        elsif (-12 <= y_verschil and y_verschil < -10) then						 
                            direction2_y <= "11000110";						 
                            direction2_x <= "11100110";

                        elsif (-10 <= y_verschil and y_verschil < -8) then						 
                            direction2_y <= "11001000";						 
                            direction2_x <= "11100001";

                        elsif (-8 <= y_verschil and y_verschil < -6) then						 
                            direction2_y <= "11001100";						 
                            direction2_x <= "11011011";

                        elsif (-6 <= y_verschil and y_verschil < -4) then						 
                            direction2_y <= "11010011";						 
                            direction2_x <= "11010011";

                        elsif (-4 <= y_verschil and y_verschil < -2) then						 
                            direction2_y <= "11011111";						 
                            direction2_x <= "11001100";

                        elsif (-2 <= y_verschil and y_verschil < 0) then						 
                            direction2_y <= "11110011";						 
                            direction2_x <= "11000001";

                        elsif (y_verschil = 0) then						 
                            direction2_y <= "00000000";						 
                            direction2_x <= "11000000";

                        elsif (0 < y_verschil and y_verschil < 2) then						 
                            direction2_y <= "00001101";						 
                            direction2_x <= "11000001";

                        elsif (2 <= y_verschil and y_verschil < 4) then						 
                            direction2_y <= "00100001";						 
                            direction2_x <= "11001100";

                        elsif (4 <= y_verschil and y_verschil < 6) then						 
                            direction2_y <= "00101101";						 
                            direction2_x <= "11010011";

                        elsif (6 <= y_verschil and y_verschil < 8) then						 
                            direction2_y <= "00110100";						 
                            direction2_x <= "11011011";

                        elsif (8 <= y_verschil and y_verschil < 10) then						 
                            direction2_y <= "00111000";						 
                            direction2_x <= "11100001";

                        elsif (10 <= y_verschil and y_verschil < 12) then						 
                            direction2_y <= "00111010";												 
                            direction2_x <= "11100110";

                        else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 					 
                            direction2_y <= "00111100";						 
                            direction2_x <= "11101001";						
                        end if;


					elsif (-4 <= x_verschil and x_verschil < -2) then

						if (-13 <= y_verschil and y_verschil < -12) then
							direction2_y <= "11000010";						 
							direction2_x <= "11110010";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction2_y <= "11000010";						 
							direction2_x <= "11101111";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction2_y <= "11000011";						 
							direction2_x <= "11101100";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction2_y <= "11000101";						 
							direction2_x <= "11100111";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction2_y <= "11001001";						 
							direction2_x <= "11011111";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction2_y <= "11010011";							 
							direction2_x <= "11010011";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction2_y <= "11101100";						 
							direction2_x <= "11000011";

						elsif (y_verschil = 0) then						 
							direction2_y <= "00000000";						 
							direction2_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction2_y <= "00010100";						 
							direction2_x <= "11000011";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction2_y <= "00101101";						 
							direction2_x <= "11010011";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction2_y <= "00110111";						 
							direction2_x <= "11011111";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction2_y <= "00111011";						 
							direction2_x <= "11100111";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction2_y <= "00111101";						 
							direction2_x <= "11101100";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction2_y <= "00111110";						 
							direction2_x <= "11101111";

						else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 					 
							direction2_y <= "00111110";						 
							direction2_x <= "11110010";
						end if;
						

					elsif (-2 <= x_verschil and x_verschil < 0) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction2_y <= "11000000";						 
							direction2_x <= "11111011";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction2_y <= "11000000";						 
							direction2_x <= "11111010";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction2_y <= "11000000";						 
							direction2_x <= "11111001";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction2_y <= "11000001";						 
							direction2_x <= "11110111";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction2_y <= "11000001";						 
							direction2_x <= "11110011";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction2_y <= "11000011";						 
							direction2_x <= "11101100";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction2_y <= "11010011";						 
							direction2_x <= "11010011";

						elsif (y_verschil = 0) then						 
							direction2_y <= "00000000";						 
							direction2_x <= "11000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction2_y <= "00101101";						 
							direction2_x <= "11010011";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction2_y <= "00111101";						 
							direction2_x <= "11101100";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction2_y <= "00111111";						 
							direction2_x <= "11110011";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction2_y <= "00111111";						 
							direction2_x <= "11110111";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction2_y <= "01000000";						 
							direction2_x <= "11111001";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction2_y <= "01000000";						 
							direction2_x <= "11111010";

						else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction2_y <= "01000000";						 
							direction2_x <= "11111011";							
						end if;
					

					elsif (x_verschil = 0) then
							direction2_y <= "00000000";
                   			direction2_x <= "01000000";


					elsif (0 < x_verschil and x_verschil < 2) then

						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction2_y <= "11000000";						 
							direction2_x <= "00000101";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction2_y <= "11000000";						 
							direction2_x <= "00000110";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction2_y <= "11000000";						 
							direction2_x <= "00000111";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction2_y <= "11000001";						 
							direction2_x <= "00001001";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction2_y <= "11000001";						 
							direction2_x <= "00001101";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction2_y <= "11000011";						 
							direction2_x <= "00010100";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction2_y <= "11000011";						 
							direction2_x <= "00101101";

						elsif (y_verschil = 0) then						 
							direction2_y <= "00000000";						 
							direction2_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction2_y <= "00101101";						 
							direction2_x <= "00101101";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction2_y <= "00111101";						 
							direction2_x <= "00010100";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction2_y <= "00111111";						 
							direction2_x <= "00001101";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction2_y <= "00111111";						 
							direction2_x <= "00001001";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction2_y <= "01000000";						 
							direction2_x <= "00000111";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction2_y <= "01000000";						 
							direction2_x <= "00000110";

						else 													-- has to be between (12 <= y_verschil and y_verschil <= 13) 						 
							direction2_y <= "01000000";						 
							direction2_x <= "00000101";					
						end if;
					
				
					else 														-- has to be between (2 <= x_verschil and x_verschil <= 4) 
						if (-13 <= y_verschil and y_verschil < -12) then						 
							direction2_y <= "11000010";						 
							direction2_x <= "00001110";

						elsif (-12 <= y_verschil and y_verschil < -10) then						 
							direction2_y <= "11000010";						 
							direction2_x <= "00010001";

						elsif (-10 <= y_verschil and y_verschil < -8) then						 
							direction2_y <= "11000011";						 
							direction2_x <= "00010100";

						elsif (-8 <= y_verschil and y_verschil < -6) then						 
							direction2_y <= "11000101";						 
							direction2_x <= "00011001";

						elsif (-6 <= y_verschil and y_verschil < -4) then						 
							direction2_y <= "11001001";						 
							direction2_x <= "00100001";

						elsif (-4 <= y_verschil and y_verschil < -2) then						 
							direction2_y <= "11010011";						 
							direction2_x <= "00101101";

						elsif (-2 <= y_verschil and y_verschil < 0) then						 
							direction2_y <= "11101100";						 
							direction2_x <= "00111101";

						elsif (y_verschil = 0) then						 
							direction2_y <= "00000000";						 
							direction2_x <= "01000000";

						elsif (0 < y_verschil and y_verschil < 2) then						 
							direction2_y <= "00010100";						 
							direction2_x <= "00111101";

						elsif (2 <= y_verschil and y_verschil < 4) then						 
							direction2_y <= "00101101";						 
							direction2_x <= "00101101";

						elsif (4 <= y_verschil and y_verschil < 6) then						 
							direction2_y <= "00110111";						 
							direction2_x <= "00100001";

						elsif (6 <= y_verschil and y_verschil < 8) then						 
							direction2_y <= "00111011";						 
							direction2_x <= "00011001";

						elsif (8 <= y_verschil and y_verschil < 10) then						 
							direction2_y <= "00111101";						 
							direction2_x <= "00010100";

						elsif (10 <= y_verschil and y_verschil < 12) then						 
							direction2_y <= "00111110";								 
							direction2_x <= "00010001";

						else 													-- has to be between (12 <= y_verschil and y_verschil <= 13)						 
							direction2_y <= "00111110";						 
							direction2_x <= "00001110";
						end if;
					
					end if;


					if(o2='1' and a2='1') then
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction2_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction2_y))+ 1, direction_y1'length));
						collision2a1 <= '1';
						collision2b1 <= '0';

					else														-- has to be be (o2='1' and b2='1')
						direction_x1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction2_x))+ 1, direction_x1'length));						 
						direction_y1 <= std_logic_vector(to_signed(to_integer(unsigned(not direction2_y))+ 1, direction_y1'length));
						collision2a1 <= '0';
						collision2b1 <= '1';
					end if;
								
				
				else
					direction2_y <= "00000000";						 
					direction2_x <= "00000000";
					direction_y1 <= "00000000";
					direction_x1 <= "00000000";
					collision2a1 <= '0';
					collision2b1 <= '0';				
				end if;


			else
				direction2_y <= "00000000";						 
				direction2_x <= "00000000";
				direction_y1 <= "00000000";
				direction_x1 <= "00000000";
				collision2a1 <= '0';
				collision2b1 <= '0';
			end if;

		
		else 
			direction2_y <= "00000000";						 
			direction2_x <= "00000000";
			direction_y1 <= "00000000";
			direction_x1 <= "00000000";
			collision2a1 <= '0';
			collision2b1 <= '0';		
		end if;

	end process;

end behaviour;
