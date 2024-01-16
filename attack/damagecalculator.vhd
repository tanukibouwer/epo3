library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity damagecalculator is
    port (
        clk          : in std_logic;
        res          : in std_logic;
        collision1A2 : in std_logic;
        collision2A1 : in std_logic;
        collision1B2 : in std_logic;
        collision2B1 : in std_logic;
        oldpercentage1 : in std_logic_vector (7 downto 0);
        oldpercentage2 : in std_logic_vector (7 downto 0);
        percentage1 : out std_logic_vector (7 downto 0);
        percentage2 : out std_logic_vector (7 downto 0);
        newpercentage1 : out std_logic_vector (7 downto 0);
        newpercentage2 : out std_logic_vector (7 downto 0));
end entity damagecalculator;

architecture behavioural of damagecalculator is
    type c1_state is (neutral1, damageA1
        , damageB1
    );
    signal state1, new_state1 : c1_state;

    type c2_state is (neutral2, damageA2
        , damageB2
    );
    signal state2, new_state2 : c2_state;

    signal s1, s2, s3, s4 : unsigned(7 downto 0);

    signal s9, s10 : unsigned(7 downto 0);
begin
    s1 <= unsigned(oldpercentage1); 
    s3 <= unsigned(oldpercentage2); 

    lbl0 : process (clk)
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

    lbl1 : process (state1, collision2A1
        , collision2B1, s1, s2, oldpercentage1, s9 -- B attack that player 1 receives
        )
    begin
        case state1 is
            when neutral1 =>
                s2 <= s1;
                newpercentage1 <= oldpercentage1;
                percentage1    <= "00000000";

                s9 <= s1;
                
                if (collision2A1 = '1') then
                    new_state1 <= damageA1;
                elsif (collision2B1 = '1') then
                    new_state1 <= damageB1;
                else
                    new_state1 <= neutral1;
                end if;

                
            when damageA1 => 
                s2          <= s1 + to_unsigned(5, 8); 
                newpercentage1 <= std_logic_vector(s2);
                percentage1    <= std_logic_vector(s9);
                
                if (s1 < to_unsigned(80, 8)) then
                    s9 <= to_unsigned(80, 8);
		else
			s9 <= s1;
		end if;
                
                new_state1 <= neutral1; 
            	
		

	    when damageB1 => 
                s2             <= s1 + to_unsigned(10, 8); --adding the value 10 to the old percentage to get the new percentage 
                newpercentage1 <= std_logic_vector(s2);
                percentage1    <= std_logic_vector(s9);


                if (s1 < to_unsigned(50, 8)) then
                    s9 <= s1 + to_unsigned(10, 8); 
                elsif (s1 < to_unsigned(100, 8)) then
                    s9 <= s1 + to_unsigned(20, 8); 
                elsif (s1 < to_unsigned(150, 8)) then
                    s9 <= s1 + to_unsigned(50, 8); 
                elsif (s1 < to_unsigned(200, 8)) then
                    s9 <= s1 + to_unsigned(120, 8); 
		else
			s9 <= s1;
                end if;
                new_state1 <= neutral1; 

        end case;
    end process;

    lbl2 : process (state2, collision1A2
        , collision1B2, s3, s10, s4, oldpercentage2 -- B attack that player 2 receives
        )
    begin
        case state2 is
            when neutral2 =>
                s4 <= s3;
                percentage2    <= "00000000";
                newpercentage2 <= oldpercentage2;

                s10 <= s3;

                if (collision1A2 = '1') then
                    new_state2 <= damageA2;
                elsif (collision1B2 = '1') then
                    new_state2 <= damageB2;
                else
                    new_state2 <= neutral2;
                end if;
            when damageA2 => 
                s4             <= s3 + to_unsigned(5, 8); --adding the value 5 to the old percentage to get the new percentage
                percentage2    <= std_logic_vector(s10);
                newpercentage2 <= std_logic_vector(s4);

                if (s3 < to_unsigned(80, 8)) then
                    s10 <= to_unsigned(80, 8);
		else
			s10 <= s3;
		end if;

                new_state2     <= neutral2; 
            when damageB2 => 
                s4             <= s3 + to_unsigned(10, 8); --adding the value 10 to the old percentage to get the new percentage
                newpercentage2 <= std_logic_vector(s4);
                percentage2    <= std_logic_vector(s10);


                if (s3 < to_unsigned(50, 8)) then
                    s10 <= s3 + to_unsigned(10, 8); 
                elsif (s3 < to_unsigned(100, 8)) then
                    s10 <= s3 + to_unsigned(20, 8); 
                elsif (s3 < to_unsigned(150, 8)) then
                    s10 <= s3 + to_unsigned(50, 8); 
                elsif (s3 < to_unsigned(200, 8)) then
                    s10 <= s3 + to_unsigned(120, 8); 
		else
			s10 <= s3;
                end if;
                
                new_state2 <= neutral2; 
        end case;
    end process;
end architecture behavioural;
