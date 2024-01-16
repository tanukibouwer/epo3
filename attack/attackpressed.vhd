library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity attackp is
    port (
        clk    : in std_logic;
        res    : in std_logic;
        input1 : in std_logic_vector (7 downto 0);
        input2 : in std_logic_vector (7 downto 0);
        vsync  : in std_logic;
        --input3  : in  std_logic_vector (7 downto 0);
        --input4  : in  std_logic_vector (7 downto 0);
        output1A : out std_logic;
        output1B : out std_logic;
        --output3A  : out std_logic;
        --output3B  : out std_logic;
        --output4A  : out std_logic;
        --output4B  : out std_logic;
        output2A : out std_logic;
        output2B : out std_logic);
end entity attackp;

architecture behavioural of attackp is
    type c1_state is (neutral1, holdA1, holdB1, A1, B1, count1);
    signal state1, new_state1 : c1_state;

    type c2_state is (neutral2, holdA2, holdB2, A2, B2, count2);
    signal state2, new_state2 : c2_state;

	signal cur_count1, new_count1 : unsigned(6 downto 0);
	signal cur_count2, new_count2 : unsigned(6 downto 0);

    --type c3_state is (neutral3, holdA3, holdB3, A3, B3); 
    --signal state3, new_state3: c3_state;

    --type c4_state is (neutral4, holdA4, holdB4, A4, B4); 
    --signal state4, new_state4: c4_state;
begin
    lbl0 : process (clk)
    begin
        if (clk'event and clk = '1') then
            if res = '1' then
                state1 <= neutral1;
                state2 <= neutral2;
		cur_count2 <= (others => '0');
		cur_count2 <= (others => '0');
                --state3 <= neutral3;
                --state4 <= neutral4;
            else
                state1 <= new_state1;
                state2 <= new_state2;
		cur_count1 <= new_count1;
		cur_count2 <= new_count2;
                --state3 <= new_state3;
                --state4 <= new_state4;
            end if;
        end if;
    end process;

    lbl1 : process (state1, input1, vsync, cur_count1, new_count1) -- voor de B attack nog een soort delay toevoegen -- misschien als het hier niet lukt met wait dat het in hitboxcollision kan omdat die niet met processes werken, dus wnnr ze het binnkrijgen eerst wachten en dan pas hitbox checken
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
                    --wait 500 ms; -- dit werkt sws nie met synthesis maar miss wel
                    new_state1 <= count1;
                elsif (input1(4 downto 4) = "1") and (input1(5 downto 5) = "0") then
                    --wait 500 ms; -- dit werkt sws nie met synthesis maar miss wel
                    new_state1 <= count1;
                else
                    new_state1 <= holdB1;
                end if;

	    when count1 =>
		output1A <= '0';
                output1B <= '0';
		if vsync = '0' then
			if (cur_count1 < "1111000" ) then
				new_count1 <= cur_count1 + 1;
				new_state1 <= count1;
			else
				cur_count1 <= (others => '0');
				new_count1 <= (others => '0');
				new_state1 <= B1;
			end if;
		else
			new_state1 <= count1;
		end if;
		


            when A1 =>
                output1A   <= '1';
                output1B   <= '0';
				if vsync = '0' then
					new_state1 <= neutral1; -- gaat dit werken? of is dit te kort en moet hij met een delay ofso tijdelijk in deze state bliven want je wil ook niet dat hij oneindig blijft slaan?????
				else
					new_state1 <= A1;
				end if;

            when B1 =>
                output1A   <= '0';
                output1B   <= '1';
                if vsync = '0' then
					new_state1 <= neutral1; -- gaat dit werken? of is dit te kort en moet hij met een delay ofso tijdelijk in deze state bliven want je wil ook niet dat hij oneindig blijft slaan?????
				else
					new_state1 <= B1;
				end if;

        end case;
    end process;

    lbl2 : process (state2, input2, vsync, cur_count2, new_count2) -- voor de B attack nog een soort delay toevoegen -- misschien als het hier niet lukt met wait dat het in hitboxcollision kan omdat die niet met processes werken, dus wnnr ze het binnkrijgen eerst wachten en dan pas hitbox checken
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
                    --wait 500 ms; -- dit werkt sws nie met synthesis maar miss wel
                    new_state2 <= count2;
                elsif (input2(4 downto 4) = "1") and (input2(5 downto 5) = "0") then
                    --wait 500 ms; -- dit werkt sws nie met synthesis maar miss wel
                    new_state2 <= count2;
                else
                    new_state2 <= holdB2;
                end if;

	    when count2 =>
		output2A <= '0';
                output2B <= '0';
		if vsync = '0' then
			if (cur_count2 < "1111000" ) then
				new_count2 <= cur_count2 + 1;
				new_state2 <= count2;
			else
				cur_count2 <= (others => '0');
				new_count2 <= (others => '0');
				new_state2 <= B2;
			end if;
		else
			new_state2 <= count2;
		end if;

            when A2 =>
                output2A   <= '1';
                output2B   <= '0';
                if vsync = '0' then
					new_state2 <= neutral2; -- gaat dit werken? of is dit te kort en moet hij met een delay ofso tijdelijk in deze state bliven want je wil ook niet dat hij oneindig blijft slaan?????
				else
					new_state2 <= A2;
				end if;

            when B2 =>
                output2A   <= '0';
                output2B   <= '1';
				if vsync = '0' then
					new_state2 <= neutral2; -- gaat dit werken? of is dit te kort en moet hij met een delay ofso tijdelijk in deze state bliven want je wil ook niet dat hij oneindig blijft slaan?????
				else
					new_state2 <= B2;
				end if;

        end case;
    end process;

    --lbl3: process(state3, input3) -- voor de B attack nog een soort delay toevoegen -- misschien als het hier niet lukt met wait dat het in hitboxcollision kan omdat die niet met processes werken, dus wnnr ze het binnkrijgen eerst wachten en dan pas hitbox checken
    --begin
    --case state3 is
    --when neutral3 =>
    --output3A <= '0';
    --output3B <= '0';
    --if (input3(4 downto 4) = "1") and (input3(5 downto 5) = "0") then
    --new_state3 <= holdA3;
    --elsif (input3(4 downto 4) = "0") and (input3(5 downto 5) = "1") then
    --new_state3 <= holdB3;
    --else
    --new_state3 <= neutral3;
    --end if;

    --when holdA3 =>
    --output3A <= '0';
    --output3B <= '0';
    --if (input3(4 downto 4) = "0") and (input3(5 downto 5) = "1") then
    --new_state3 <= A3;
    --elsif (input3(4 downto 4) = "0") and (input3(5 downto 5) = "0") then
    --new_state3 <= A3;
    --else
    --new_state3 <= holdA3;
    --end if;

    --when holdB3 =>
    --output3A <= '0';
    --output3B <= '0';
    --if (input3(4 downto 4) = "0") and (input3(5 downto 5) = "0") then
    --wait 500 ms; -- dit werkt sws nie met synthesis maar miss wel
    --new_state3 <= B3;
    --elsif (input3(4 downto 4) = "1") and (input3(5 downto 5) = "0") then
    --wait 500 ms; -- dit werkt sws nie met synthesis maar miss wel
    --new_state3 <= B3;
    --else
    --new_state3 <= holdB3;
    --end if;

    --when A3 =>
    --output3A <= '1';
    --output3B <= '0';
    --new_state3 <= neutral3; -- gaat dit werken? of is dit te kort en moet hij met een delay ofso tijdelijk in deze state bliven want je wil ook niet dat hij oneindig blijft slaan?????

    --when B3 =>
    --output3A <= '0';
    --output3B <= '1';
    --new_state3 <= neutral3; -- gaat dit werken? of is dit te kort en moet hij met een delay ofso tijdelijk in deze state bliven want je wil ook niet dat hij oneindig blijft slaan?????

    --end case;
    --end process;

    --lbl4: process(state4, input4) -- voor de B attack nog een soort delay toevoegen -- misschien als het hier niet lukt met wait dat het in hitboxcollision kan omdat die niet met processes werken, dus wnnr ze het binnkrijgen eerst wachten en dan pas hitbox checken
    --begin
    --case state4 is
    --when neutral4 =>
    --output4A <= '0';
    --output4B <= '0';
    --if (input4(4 downto 4) = "1") and (input4(5 downto 5) = "0") then
    --new_state4 <= holdA4;
    --elsif (input4(4 downto 4) = "0") and (input4(5 downto 5) = "1") then
    --new_state4 <= holdB4;
    --else
    --new_state4 <= neutral4;
    --end if;

    --when holdA4 =>
    --output4A <= '0';
    --output4B <= '0';
    --if (input4(4 downto 4) = "0") and (input4(5 downto 5) = "1") then
    --new_state4 <= A4;
    --elsif (input4(4 downto 4) = "0") and (input4(5 downto 5) = "0") then
    --new_state4 <= A4;
    --else
    --new_state4 <= holdA4;
    --end if;

    --when holdB4 =>
    --output4A <= '0';
    --output4B <= '0';
    --if (input4(4 downto 4) = "0") and (input4(5 downto 5) = "0") then
    --wait 500 ms; -- dit werkt sws nie met synthesis maar miss wel
    --new_state4 <= B4;
    --elsif (input4(4 downto 4) = "1") and (input4(5 downto 5) = "0") then
    --wait 500 ms; -- dit werkt sws nie met synthesis maar miss wel
    --new_state4 <= B4;
    --else
    --new_state4 <= holdB4;
    --end if;

    --when A4 =>
    --output4A <= '1';
    --output4B <= '0';
    --new_state4 <= neutral4; -- gaat dit werken? of is dit te kort en moet hij met een delay ofso tijdelijk in deze state bliven want je wil ook niet dat hij oneindig blijft slaan?????

    --when B4 =>
    --output4A <= '0';
    --output4B <= '1';
    --new_state4 <= neutral4; -- gaat dit werken? of is dit te kort en moet hij met een delay ofso tijdelijk in deze state bliven want je wil ook niet dat hij oneindig blijft slaan?????

    --end case;
    --end process;
end architecture behavioural;