library IEEE;
use IEEE.std_logic_1164.ALL;

entity orientation is
   port(clk : in  std_logic;
        res : in  std_logic;
        input1  : in  std_logic_vector (7 downto 0);
        input2  : in  std_logic_vector (7 downto 0);
        output1  : out std_logic;
        output2  : out std_logic);
end entity orientation;

architecture behavioural of orientation is
	type c1_state is (left1, right1); 
	signal state1, new_state1: c1_state;

	type c2_state is (left2, right2); 
	signal state2, new_state2: c2_state;
begin
	lbl0: process (clk)
	begin
		if (clk'event and clk = '1') then
			if res = '1' then
				state1 <= right1;
				state2 <= left2;
			else
				state1 <= new_state1;
				state2 <= new_state2;
			end if;
		end if;
	end process;

	lbl1: process(state1, input1)
	begin
		case state1 is
			when left1 =>
				output1 <= '0';
				if (input1(0 downto 0) = "0") and (input1(1 downto 1) = "1") then
					new_state1 <= right1;
				else
					new_state1 <= left1;
				end if;
			when right1 =>
				output1 <= '1';
				if (input1(0 downto 0) = "1") and (input1(1 downto 1) = "0") then
					new_state1 <= left1;
				else
					new_state1 <= right1;
				end if;
		end case;
	end process;

	lbl2: process(state2, input2)
	begin
		case state2 is
			when left2 =>
				output2 <= '0';
				if (input2(0 downto 0) = "0") and (input2(1 downto 1) = "1") then
					new_state2 <= right2;
				else
					new_state2 <= left2;
				end if;
			when right2 =>
				output2 <= '1';
				if (input2(0 downto 0) = "1") and (input2(1 downto 1) = "0") then
					new_state2 <= left2;
				else
					new_state2 <= right2;
				end if;
		end case;
	end process;
end architecture behavioural;