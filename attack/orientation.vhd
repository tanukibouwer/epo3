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
	type orientation_state is (left1left2, left1right2, right1right2, right1left2);
	signal state, new_state: orientation_state;
begin
	lbl1: process (clk)
	begin
		if (clk'event and clk = '1') then
			if res = '1' then
				state <= right1left2;
			else
				state <= new_state;
			end if;
		end if;
	end process;
	lbl2: process(state, input1, input2)
	begin
		case state is
			when left1left2 =>
				output1 <= '0';
				output2 <= '0';
				if (input1(0 downto 0) = "0") and (input1(1 downto 1) = "0") and (input2(0 downto 0) = "0") and (input2(1 downto 1) = "1") then
					new_state <= left1right2;
				elsif (input1(0 downto 0) = "1") and (input1(1 downto 1) = "1") and (input2(0 downto 0) = "0") and (input2(1 downto 1) = "1") then
					new_state <= left1right2;
				elsif (input1(0 downto 0) = "1") and (input1(1 downto 1) = "0") and (input2(0 downto 0) = "0") and (input2(1 downto 1) = "1") then
					new_state <= left1right2;
				elsif (input1(0 downto 0) = "0") and (input1(1 downto 1) = "1") and (input2(0 downto 0) = "0") and (input2(1 downto 1) = "1") then
					new_state <= right1right2;
				elsif (input1(0 downto 0) = "0") and (input1(1 downto 1) = "1") and (input2(0 downto 0) = "0") and (input2(1 downto 1) = "0") then
					new_state <= right1left2;
				elsif (input1(0 downto 0) = "0") and (input1(1 downto 1) = "1") and (input2(0 downto 0) = "1") and (input2(1 downto 1) = "1") then
					new_state <= right1left2;
				elsif (input1(0 downto 0) = "0") and (input1(1 downto 1) = "1") and (input2(0 downto 0) = "1") and (input2(1 downto 1) = "0") then
					new_state <= right1left2;
				else
					new_state <= left1left2;
				end if;

			when left1right2 =>
				output1 <= '0';
				output2 <= '1';
				if (input1(0 downto 0) = "0") and (input1(1 downto 1) = "0") and (input2(0 downto 0) = "1") and (input2(1 downto 1) = "0") then
					new_state <= left1left2;
				elsif (input1(0 downto 0) = "1") and (input1(1 downto 1) = "1") and (input2(0 downto 0) = "1") and (input2(1 downto 1) = "0") then
					new_state <= left1left2;
				elsif (input1(0 downto 0) = "1") and (input1(1 downto 1) = "0") and (input2(0 downto 0) = "1") and (input2(1 downto 1) = "0") then
					new_state <= left1left2;
				elsif (input1(0 downto 0) = "0") and (input1(1 downto 1) = "1") and (input2(0 downto 0) = "0") and (input2(1 downto 1) = "0") then
					new_state <= right1right2;
				elsif (input1(0 downto 0) = "0") and (input1(1 downto 1) = "1") and (input2(0 downto 0) = "1") and (input2(1 downto 1) = "1") then
					new_state <= right1right2;
				elsif (input1(0 downto 0) = "0") and (input1(1 downto 1) = "1") and (input2(0 downto 0) = "0") and (input2(1 downto 1) = "1") then
					new_state <= right1right2;
				elsif (input1(0 downto 0) = "0") and (input1(1 downto 1) = "1") and (input2(0 downto 0) = "1") and (input2(1 downto 1) = "0") then
					new_state <= right1left2;
				else
					new_state <= left1right2;
				end if;

			when right1right2 =>
				output1 <= '1';
				output2 <= '1';
				if (input1(0 downto 0) = "1") and (input1(1 downto 1) = "0") and (input2(0 downto 0) = "1") and (input2(1 downto 1) = "0") then
					new_state <= left1left2;
				elsif (input1(0 downto 0) = "1") and (input1(1 downto 1) = "0") and (input2(0 downto 0) = "1") and (input2(1 downto 1) = "1") then
					new_state <= left1right2;
				elsif (input1(0 downto 0) = "1") and (input1(1 downto 1) = "0") and (input2(0 downto 0) = "0") and (input2(1 downto 1) = "0") then
					new_state <= left1right2;
				elsif (input1(0 downto 0) = "1") and (input1(1 downto 1) = "0") and (input2(0 downto 0) = "0") and (input2(1 downto 1) = "1") then
					new_state <= left1right2;
				elsif (input1(0 downto 0) = "0") and (input1(1 downto 1) = "0") and (input2(0 downto 0) = "1") and (input2(1 downto 1) = "0") then
					new_state <= right1left2;
				elsif (input1(0 downto 0) = "1") and (input1(1 downto 1) = "1") and (input2(0 downto 0) = "1") and (input2(1 downto 1) = "0") then
					new_state <= right1left2;
				elsif (input1(0 downto 0) = "0") and (input1(1 downto 1) = "1") and (input2(0 downto 0) = "1") and (input2(1 downto 1) = "0") then
					new_state <= right1left2;
				else
					new_state <= right1right2;
				end if;

			when right1left2 =>
				output1 <= '1';
				output2 <= '0';
				if (input1(0 downto 0) = "1") and (input1(1 downto 1) = "0") and (input2(0 downto 0) = "1") and (input2(1 downto 1) = "0") then
					new_state <= left1left2;
				elsif (input1(0 downto 0) = "1") and (input1(1 downto 1) = "0") and (input2(0 downto 0) = "1") and (input2(1 downto 1) = "1") then
					new_state <= left1left2;
				elsif (input1(0 downto 0) = "1") and (input1(1 downto 1) = "0") and (input2(0 downto 0) = "0") and (input2(1 downto 1) = "0") then
					new_state <= left1left2;
				elsif (input1(0 downto 0) = "1") and (input1(1 downto 1) = "0") and (input2(0 downto 0) = "0") and (input2(1 downto 1) = "1") then
					new_state <= left1right2;
				elsif (input1(0 downto 0) = "0") and (input1(1 downto 1) = "0") and (input2(0 downto 0) = "0") and (input2(1 downto 1) = "1") then
					new_state <= right1right2;
				elsif (input1(0 downto 0) = "1") and (input1(1 downto 1) = "1") and (input2(0 downto 0) = "0") and (input2(1 downto 1) = "1") then
					new_state <= right1right2;
				elsif (input1(0 downto 0) = "0") and (input1(1 downto 1) = "1") and (input2(0 downto 0) = "0") and (input2(1 downto 1) = "1") then
					new_state <= right1right2;
				else
					new_state <= right1left2;
				end if;
		end case;
	end process;
end architecture behavioural;

