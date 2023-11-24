library IEEE;
use IEEE.std_logic_1164.ALL;

entity attackp is
   port(clk : in  std_logic;
        res : in  std_logic;
        input1  : in  std_logic_vector (7 downto 0);
        input2  : in  std_logic_vector (7 downto 0);
        output1A  : out std_logic;
	output1B  : out std_logic;
	output2A  : out std_logic;
        output2B  : out std_logic);
end entity attackp;

architecture behavioural of attackp is
	type c1_state is (neutral1, holdA1, holdB1, A1, B1); 
	signal state1, new_state1: c1_state;

	type c2_state is (neutral2, holdA2, holdB2, A2, B2); 
	signal state2, new_state2: c2_state;
begin
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

	lbl1: process(state1, input1)
	begin
		case state1 is
			when neutral1 =>
				output1A <= '0';
				output1B <= '0';
				if (input1(4 downto 4) = "1") and (input1(5 downto 5) = "0") then
					new_state1 <= holdA1;
				elsif (input1(4 downto 4) = "0") and (input1(5 downto 5) = "1") then
					new_state1 <= holdB1;
				else
					new_state1 <= neutral1;
				end if;

			when holdA1 =>
				output1A <= '0';
				output1B <= '0';
				if (input1(4 downto 4) = "0") and (input1(5 downto 5) = "1") then
					new_state1 <= A1;
				elsif (input1(4 downto 4) = "0") and (input1(5 downto 5) = "0") then
					new_state1 <= A1;
				else
					new_state1 <= holdA1;
				end if;

			when holdB1 =>
				output1A <= '0';
				output1B <= '0';
				if (input1(4 downto 4) = "0") and (input1(5 downto 5) = "0") then
					new_state1 <= B1;
				elsif (input1(4 downto 4) = "1") and (input1(5 downto 5) = "0") then
					new_state1 <= B1;
				else
					new_state1 <= holdB1;
				end if;

			when A1 =>
				output1A <= '1';
				output1B <= '0';
					new_state1 <= neutral1; -- gaat dit werken? of is dit te kort en moet hij met een delay ofso tijdelijk in deze state bliven want je wil ook niet dat hij oneindig blijft slaan?????

			when B1 =>
				output1A <= '0';
				output1B <= '1';
					new_state1 <= neutral1; -- gaat dit werken? of is dit te kort en moet hij met een delay ofso tijdelijk in deze state bliven want je wil ook niet dat hij oneindig blijft slaan?????

		end case;
	end process;

	lbl2: process(state2, input2)
	begin
		case state2 is
			when neutral2 =>
				output2A <= '0';
				output2B <= '0';
				if (input2(4 downto 4) = "1") and (input2(5 downto 5) = "0") then
					new_state2 <= holdA2;
				elsif (input2(4 downto 4) = "0") and (input2(5 downto 5) = "1") then
					new_state2 <= holdB2;
				else
					new_state2 <= neutral2;
				end if;

			when holdA2 =>
				output2A <= '0';
				output2B <= '0';
				if (input2(4 downto 4) = "0") and (input2(5 downto 5) = "1") then
					new_state2 <= A2;
				elsif (input2(4 downto 4) = "0") and (input2(5 downto 5) = "0") then
					new_state2 <= A2;
				else
					new_state2 <= holdA2;
				end if;

			when holdB2 =>
				output2A <= '0';
				output2B <= '0';
				if (input2(4 downto 4) = "0") and (input2(5 downto 5) = "0") then
					new_state2 <= B2;
				elsif (input2(4 downto 4) = "1") and (input2(5 downto 5) = "0") then
					new_state2 <= B2;
				else
					new_state2 <= holdB2;
				end if;

			when A2 =>
				output2A <= '1';
				output2B <= '0';
					new_state2 <= neutral2; -- gaat dit werken? of is dit te kort en moet hij met een delay ofso tijdelijk in deze state bliven want je wil ook niet dat hij oneindig blijft slaan?????

			when B2 =>
				output2A <= '0';
				output2B <= '1';
					new_state2 <= neutral2; -- gaat dit werken? of is dit te kort en moet hij met een delay ofso tijdelijk in deze state bliven want je wil ook niet dat hij oneindig blijft slaan?????

		end case;
	end process;
end architecture behavioural;

