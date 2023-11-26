library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity number_fsm is
port(
	clk         : in std_logic;
    number  	: in std_logic_vector(3 downto 0); -- 9 (max is 1001 in binary)
    reset  	: in std_logic;

	line1 	: out std_logic_vector(3 downto 0);
    line2	: out std_logic_vector(3 downto 0);
    line3 	: out std_logic_vector(3 downto 0);
    line4 	: out std_logic_vector(3 downto 0);
    line5  	: out std_logic_vector(3 downto 0);
    line6  	: out std_logic_vector(3 downto 0);
    line7  	: out std_logic_vector(3 downto 0)); 


end number_fsm;

architecture behaviour of number_fsm is
    type number_state is (one, two, three, four, five, six, seven, eight, nine, zero);
    signal state, new_state: number_state;
begin
    lbl1:process(clk)
    begin
        if(clk'event and clk = '1') then
            if reset = '1' then
                state <= zero;
            else 
                state <= new_state;
            end if;
        end if;
    end process;
    lbl2: process(state, number) --inverted colored numbers! 
    begin
        case state is 
            when zero =>
            line1 <= "0000";
            line2 <= "0110";
            line3 <= "0110";
            line4 <= "0110";
            line5 <= "0110";
            line6 <= "0110";
            line7 <= "0000";

            if (number = "0000") then --0
                new_state <= zero;
            elsif (number = "0001") then --1
                new_state <= one;
            elsif (number = "0010") then --2
                new_state <= two;
            elsif (number = "0011") then --3
                new_state <= three;
            elsif (number = "0100") then --4
                new_state <= four;
            elsif (number = "0101") then --5
                new_state <= five;
            elsif (number = "0110") then --6
                new_state <= six;
            elsif (number = "0111") then --7
                new_state <= seven;
            elsif (number = "1000") then --8
                new_state <= eight;
            else  --9
                new_state <= nine;
            end if;

            when one =>
            line1 <= "1110";
            line2 <= "1110";
            line3 <= "1110";
            line4 <= "1110";
            line5 <= "1110";
            line6 <= "1110";
            line7 <= "1110";

            if (number = "0000") then --0
                new_state <= zero;
            elsif (number = "0001") then --1
                new_state <= one;
            elsif (number = "0010") then --2
                new_state <= two;
            elsif (number = "0011") then --3
                new_state <= three;
            elsif (number = "0100") then --4
                new_state <= four;
            elsif (number = "0101") then --5
                new_state <= five;
            elsif (number = "0110") then --6
                new_state <= six;
            elsif (number = "0111") then --7
                new_state <= seven;
            elsif (number = "1000") then --8
                new_state <= eight;
            else  --9
                new_state <= nine;
            end if;
            
            when two =>
            line1 <= "0000";
            line2 <= "1110";
            line3 <= "1110";
            line4 <= "0000";
            line5 <= "0111";
            line6 <= "0111";
            line7 <= "0000";

            if (number = "0000") then --0
                new_state <= zero;
            elsif (number = "0001") then --1
                new_state <= one;
            elsif (number = "0010") then --2
                new_state <= two;
            elsif (number = "0011") then --3
                new_state <= three;
            elsif (number = "0100") then --4
                new_state <= four;
            elsif (number = "0101") then --5
                new_state <= five;
            elsif (number = "0110") then --6
                new_state <= six;
            elsif (number = "0111") then --7
                new_state <= seven;
            elsif (number = "1000") then --8
                new_state <= eight;
            else  --9
                new_state <= nine;
            end if;

            when three =>
            line1 <= "0000";
            line2 <= "1110";
            line3 <= "1110";
            line4 <= "0000";
            line5 <= "1110";
            line6 <= "1110";
            line7 <= "0000";

            if (number = "0000") then --0
                new_state <= zero;
            elsif (number = "0001") then --1
                new_state <= one;
            elsif (number = "0010") then --2
                new_state <= two;
            elsif (number = "0011") then --3
                new_state <= three;
            elsif (number = "0100") then --4
                new_state <= four;
            elsif (number = "0101") then --5
                new_state <= five;
            elsif (number = "0110") then --6
                new_state <= six;
            elsif (number = "0111") then --7
                new_state <= seven;
            elsif (number = "1000") then --8
                new_state <= eight;
            else  --9
                new_state <= nine;
            end if;

            when four =>
            line1 <= "0110";
            line2 <= "0110";
            line3 <= "0110";
            line4 <= "0000";
            line5 <= "1110";
            line6 <= "1110";
            line7 <= "1110";

            if (number = "0000") then --0
                new_state <= zero;
            elsif (number = "0001") then --1
                new_state <= one;
            elsif (number = "0010") then --2
                new_state <= two;
            elsif (number = "0011") then --3
                new_state <= three;
            elsif (number = "0100") then --4
                new_state <= four;
            elsif (number = "0101") then --5
                new_state <= five;
            elsif (number = "0110") then --6
                new_state <= six;
            elsif (number = "0111") then --7
                new_state <= seven;
            elsif (number = "1000") then --8
                new_state <= eight;
            else  --9
                new_state <= nine;
            end if;

            when five =>
            line1 <= "0000";
            line2 <= "0111";
            line3 <= "0111";
            line4 <= "0000";
            line5 <= "1110";
            line6 <= "1110";
            line7 <= "0000";

            if (number = "0000") then --0
                new_state <= zero;
            elsif (number = "0001") then --1
                new_state <= one;
            elsif (number = "0010") then --2
                new_state <= two;
            elsif (number = "0011") then --3
                new_state <= three;
            elsif (number = "0100") then --4
                new_state <= four;
            elsif (number = "0101") then --5
                new_state <= five;
            elsif (number = "0110") then --6
                new_state <= six;
            elsif (number = "0111") then --7
                new_state <= seven;
            elsif (number = "1000") then --8
                new_state <= eight;
            else  --9
                new_state <= nine;
            end if;

            when six =>
            line1 <= "0000";
            line2 <= "0111";
            line3 <= "0111";
            line4 <= "0000";
            line5 <= "0110";
            line6 <= "0110";
            line7 <= "0000";

            if (number = "0000") then --0
                new_state <= zero;
            elsif (number = "0001") then --1
                new_state <= one;
            elsif (number = "0010") then --2
                new_state <= two;
            elsif (number = "0011") then --3
                new_state <= three;
            elsif (number = "0100") then --4
                new_state <= four;
            elsif (number = "0101") then --5
                new_state <= five;
            elsif (number = "0110") then --6
                new_state <= six;
            elsif (number = "0111") then --7
                new_state <= seven;
            elsif (number = "1000") then --8
                new_state <= eight;
            else  --9
                new_state <= nine;
            end if;

            when seven =>
            line1 <= "0000";
            line2 <= "1110";
            line3 <= "1110";
            line4 <= "1110";
            line5 <= "1110";
            line6 <= "1110";
            line7 <= "1110";

            if (number = "0000") then --0
                new_state <= zero;
            elsif (number = "0001") then --1
                new_state <= one;
            elsif (number = "0010") then --2
                new_state <= two;
            elsif (number = "0011") then --3
                new_state <= three;
            elsif (number = "0100") then --4
                new_state <= four;
            elsif (number = "0101") then --5
                new_state <= five;
            elsif (number = "0110") then --6
                new_state <= six;
            elsif (number = "0111") then --7
                new_state <= seven;
            elsif (number = "1000") then --8
                new_state <= eight;
            else  --9
                new_state <= nine;
            end if;

            when eight =>
            line1 <= "0000";
            line2 <= "0110";
            line3 <= "0110";
            line4 <= "0000";
            line5 <= "0110";
            line6 <= "0110";
            line7 <= "0000";

            if (number = "0000") then --0
                new_state <= zero;
            elsif (number = "0001") then --1
                new_state <= one;
            elsif (number = "0010") then --2
                new_state <= two;
            elsif (number = "0011") then --3
                new_state <= three;
            elsif (number = "0100") then --4
                new_state <= four;
            elsif (number = "0101") then --5
                new_state <= five;
            elsif (number = "0110") then --6
                new_state <= six;
            elsif (number = "0111") then --7
                new_state <= seven;
            elsif (number = "1000") then --8
                new_state <= eight;
            else  --9
                new_state <= nine;
            end if;

            when nine =>
            line1 <= "0000";
            line2 <= "0110";
            line3 <= "0110";
            line4 <= "0000";
            line5 <= "1110";
            line6 <= "1110";
            line7 <= "0000";

            if (number = "0000") then --0
                new_state <= zero;
            elsif (number = "0001") then --1
                new_state <= one;
            elsif (number = "0010") then --2
                new_state <= two;
            elsif (number = "0011") then --3
                new_state <= three;
            elsif (number = "0100") then --4
                new_state <= four;
            elsif (number = "0101") then --5
                new_state <= five;
            elsif (number = "0110") then --6
                new_state <= six;
            elsif (number = "0111") then --7
                new_state <= seven;
            elsif (number = "1000") then --8
                new_state <= eight;
            else  --9
                new_state <= nine;
            end if;
        end case;

    end process;

end behaviour;

