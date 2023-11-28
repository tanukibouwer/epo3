library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity killzonedetector is
   port(clk : in  std_logic;
        res : in  std_logic;
	olddeathcount1  : in  std_logic_vector (3 downto 0);
	olddeathcount2  : in  std_logic_vector (3 downto 0);
	oldpercentage1  : in  std_logic_vector (7 downto 0);
	oldpercentage2  : in  std_logic_vector (7 downto 0);
        oldvectorX1  : in  std_logic_vector (7 downto 0);
        oldvectorY1  : in  std_logic_vector (7 downto 0);
	oldvectorX2  : in  std_logic_vector (7 downto 0);
        oldvectorY2  : in  std_logic_vector (7 downto 0);
        newdeathcount1  : out  std_logic_vector (3 downto 0);
	newdeathcount2  : out  std_logic_vector (3 downto 0);
	newpercentage1  : out  std_logic_vector (7 downto 0);
	newpercentage2  : out  std_logic_vector (7 downto 0);
	newvectorX1  : out  std_logic_vector (7 downto 0);
        newvectorY1  : out  std_logic_vector (7 downto 0);
	newvectorX2  : out  std_logic_vector (7 downto 0);
        newvectorY2  : out  std_logic_vector (7 downto 0));
end entity killzonedetector;

architecture behavioural of killzonedetector is
	type c1_state is (neutral1, detection1, standardposition1, hold1); 
	signal state1, new_state1: c1_state;

	type c2_state is (neutral2, detection2, standardposition2, hold2); 
	signal state2, new_state2: c2_state;

	signal newlocationX1, newlocationY1, newlocationX2, newlocationY2: std_logic_vector (7 downto 0);

	signal s1, s2, s3, s4: unsigned(3 downto 0); 
begin
	s1 <= unsigned(olddeathcount1);
	s3 <= unsigned(olddeathcount2);

	newlocationX1 <= "00110010"; -- start location 50
	newlocationY1 <= "00011110"; -- start location 30
	newlocationX2 <= "01110100"; -- start location 116
	newlocationY2 <= "00011110"; -- start location 30

	lbl0: process (clk)
	begin
		if (clk'event and clk = '1') then
			if res = '1' then
				state1 <= neutral1;
				state2 <= neutral2;
			else
				state1 <= new_state1;
				state2 <= new_state2;
			end if;
		end if;
	end process;

	lbl1: process(state1, olddeathcount1, oldvectorX1, oldvectorY1)
	begin
		case state1 is
			when neutral1 =>
				newdeathcount1 <= "0000";
				newpercentage1 <= "00000001";
				newvectorX1 <= newlocationX1;
				newvectorY1 <= newlocationY1;
					new_state1 <= hold1;

			when detection1 =>
				s2 <= s1 + to_unsigned(1,4);
				newpercentage1 <= "00000001";
				newvectorX1 <= oldvectorX1;
				newvectorY1 <= oldvectorY1;
					new_state1 <= standardposition1;

			when standardposition1 =>
				newdeathcount1 <= olddeathcount1;
				newpercentage1 <= oldpercentage1;
				newvectorX1 <= newlocationX1;
				newvectorY1 <= newlocationY1;
					new_state1 <= hold1;

			when hold1 =>
				newdeathcount1 <= olddeathcount1;
				newpercentage1 <= oldpercentage1;
				newvectorX1 <= oldvectorX1;
				newvectorY1 <= oldvectorY1;
				if (oldvectorX1 > "10101000") or (oldvectorY1 > "01111000") or (oldvectorX1 < "00001000") or (oldvectorY1 < "00001000") then -- 168, 120, 8, 8
					new_state1 <= detection1;
				else
					new_state1 <= hold1;
				end if;
		end case;
	end process;

	lbl2: process(state2, olddeathcount2, oldvectorX2, oldvectorY2)
	begin
		case state2 is
			when neutral2 =>
				newdeathcount2 <= "0000";
				newpercentage2 <= "00000001";
				newvectorX2 <= newlocationX2;
				newvectorY2 <= newlocationY2;
					new_state2 <= hold2;

			when detection2 =>
				s4 <= s3 + to_unsigned(1,4);
				newpercentage2 <= "00000001";
				newvectorX2 <= oldvectorX2;
				newvectorY2 <= oldvectorY2;
					new_state2 <= standardposition2;

			when standardposition2 =>
				newdeathcount2 <= olddeathcount2;
				newpercentage2 <= oldpercentage2;
				newvectorX2 <= newlocationX2;
				newvectorY2 <= newlocationY2;
					new_state2 <= hold2;

			when hold2 =>
				newdeathcount2 <= olddeathcount2;
				newpercentage2 <= oldpercentage2;
				newvectorX2 <= oldvectorX2;
				newvectorY2 <= oldvectorY2;
				if (oldvectorX2 > "10101000") or (oldvectorY2 > "01111000") or (oldvectorX2 < "00001000") or (oldvectorY2 < "00001000") then -- 168, 120, 8, 8
					new_state2 <= detection2;
				else
					new_state2 <= hold2;
				end if;
		end case;
	end process;
	newdeathcount1 <= std_logic_vector(s2);
	newdeathcount2 <= std_logic_vector(s4);
end architecture behavioural;