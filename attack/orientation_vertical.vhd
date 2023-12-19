library IEEE;
use IEEE.std_logic_1164.ALL;

entity orientation is
   port(clk : in  std_logic;
        res : in  std_logic;
        input1  : in  std_logic_vector (7 downto 0);
        input2  : in  std_logic_vector (7 downto 0);
	--input3  : in  std_logic_vector (7 downto 0);
	--input4  : in  std_logic_vector (7 downto 0);
        output1  : out std_logic;
	--output3  : out std_logic;
	--output4  : out std_logic;
        output2  : out std_logic);
end entity orientation;

architecture behavioural of orientation is
	type c1_state is (up1, down1); 
	signal state1, new_state1: c1_state;

	type c2_state is (up2, down2); 
	signal state2, new_state2: c2_state;

	--type c3_state is (left3, right3); 
	--signal state3, new_state3: c3_state;

	--type c4_state is (left4, right4); 
	--signal state4, new_state4: c4_state;
begin
	lbl0: process (clk)
	begin
		if (clk'event and clk = '1') then
			if res = '1' then
				state1 <= up1;
				--state3 <= right3;
				state2 <= down2;
				--state4 <= left4;
			else
				state1 <= new_state1;
				state2 <= new_state2;
				--state3 <= new_state3;
				--state4 <= new_state4;
			end if;
		end if;
	end process;

	lbl1: process(state1, input1)
	begin
		case state1 is
			when down1 =>
				output1 <= '0';
				if (input1(3 downto 3) = "0") and (input1(2 downto 2) = "1") then
					new_state1 <= up1;
				else
					new_state1 <= down1;
				end if;
			when up1 =>
				output1 <= '1';
				if (input1(3 downto 3) = "1") and (input1(2 downto 2) = "0") then
					new_state1 <= down1;
				else
					new_state1 <= up1;
				end if;
		end case;
	end process;

	lbl2: process(state2, input2)
	begin
		case state2 is
			when down2 =>
				output2 <= '0';
				if (input2(3 downto 3) = "0") and (input2(2 downto 2) = "1") then
					new_state2 <= up2;
				else
					new_state2 <= down2;
				end if;
			when up2 =>
				output2 <= '1';
				if (input2(3 downto 3) = "1") and (input2(2 downto 2) = "0") then
					new_state2 <= down2;
				else
					new_state2 <= up2;
				end if;
		end case;
	end process;

	--lbl3: process(state3, input3)
	--begin
		--case state3 is
			--when left3 =>
				--output3 <= '0';
				--if (input3(0 downto 0) = "0") and (input3(1 downto 1) = "1") then
					--new_state3 <= right3;
				--else
					--new_state3 <= left3;
				--end if;
			--when right3 =>
				--output3 <= '1';
				--if (input3(0 downto 0) = "1") and (input3(1 downto 1) = "0") then
					--new_state3 <= left3;
				--else
					--new_state3 <= right3;
				--end if;
		--end case;
	--end process;

	--lbl4: process(state4, input4)
	--begin
		--case state4 is
			--when left4 =>
				--output4 <= '0';
				--if (input4(0 downto 0) = "0") and (input4(1 downto 1) = "1") then
					--new_state4 <= right4;
				--else
					--new_state4 <= left4;
				--end if;
			--when right4 =>
				--output4 <= '1';
				--if (input4(0 downto 0) = "1") and (input4(1 downto 1) = "0") then
					--new_state4 <= left4;
				--else
					--new_state4 <= right4;
				--end if;
		--end case;
	--end process;
end architecture behavioural;