library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity number_fsm is
port(
	clk         : in std_logic;
    number  	: in std_logic_vector(3 downto 0); -- 9 (max is 1001 in binary)
    reset  	: in std_logic;

	line1 	: out std_logic_vector(4 downto 0);
    line2	: out std_logic_vector(4 downto 0);
    line3 	: out std_logic_vector(4 downto 0);
    line4 	: out std_logic_vector(4 downto 0);
    line5  	: out std_logic_vector(4 downto 0);
    line6  	: out std_logic_vector(4 downto 0);
    line7  	: out std_logic_vector(4 downto 0)); 


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
    lbl2: process(state, number)
    begin
        case state is 
            when zero =>
            line1 <= "11111";
            line2 <= "10001";
            line3 <= "10001";
            line4 <= "10001";
            line5 <= "10001";
            line6 <= "10001";
            line7 <= "11111";

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
            line1 <= "00001";
            line2 <= "00001";
            line3 <= "00001";
            line4 <= "00001";
            line5 <= "00001";
            line6 <= "00001";
            line7 <= "00001";

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
            line1 <= "11111";
            line2 <= "00001";
            line3 <= "00001";
            line4 <= "11111";
            line5 <= "10000";
            line6 <= "10000";
            line7 <= "11111";

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
            line1 <= "11111";
            line2 <= "00001";
            line3 <= "00001";
            line4 <= "11111";
            line5 <= "00001";
            line6 <= "00001";
            line7 <= "11111";

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
            line1 <= "10001";
            line2 <= "10001";
            line3 <= "10001";
            line4 <= "11111";
            line5 <= "00001";
            line6 <= "00001";
            line7 <= "00001";

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
            line1 <= "11111";
            line2 <= "10000";
            line3 <= "10000";
            line4 <= "11111";
            line5 <= "00001";
            line6 <= "00001";
            line7 <= "11111";

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
            line1 <= "11111";
            line2 <= "10000";
            line3 <= "10000";
            line4 <= "11111";
            line5 <= "10001";
            line6 <= "10001";
            line7 <= "11111";

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
            line1 <= "11111";
            line2 <= "00001";
            line3 <= "00001";
            line4 <= "00001";
            line5 <= "00001";
            line6 <= "00001";
            line7 <= "00001";

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
            line1 <= "11111";
            line2 <= "10001";
            line3 <= "10001";
            line4 <= "11111";
            line5 <= "10001";
            line6 <= "10001";
            line7 <= "11111";

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
            line1 <= "11111";
            line2 <= "10001";
            line3 <= "10001";
            line4 <= "11111";
            line5 <= "00001";
            line6 <= "00001";
            line7 <= "11111";

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

