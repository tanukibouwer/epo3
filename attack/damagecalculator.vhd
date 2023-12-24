library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity damagecalculator is
    port (
        clk          : in std_logic;
        res          : in std_logic;
        collision1A2 : in std_logic;
        --collision1A3 : in std_logic;
        --collision1A4 : in std_logic;
        collision2A1 : in std_logic;
        --collision2A3 : in std_logic;
        --collision2A4 : in std_logic;
        --collision3A1 : in std_logic;
        --collision3A2 : in std_logic;
        --collision3A4 : in std_logic;
        --collision4A1 : in std_logic;
        --collision4A2 : in std_logic;
        --collision4A3 : in std_logic;
        collision1B2 : in std_logic;
        --collision1B3 : in std_logic;
        --collision1B4 : in std_logic;
        collision2B1 : in std_logic;
        --collision2B3 : in std_logic;
        --collision2B4 : in std_logic;
        --collision3B1 : in std_logic;
        --collision3B2 : in std_logic;
        --collision3B4 : in std_logic;
        --collision4B1 : in std_logic;
        --collision4B2 : in std_logic;
        --collision4B3 : in std_logic;
        oldpercentage1 : in std_logic_vector (7 downto 0);
        oldpercentage2 : in std_logic_vector (7 downto 0);
        --oldpercentage3  : in  std_logic_vector (7 downto 0);
        --oldpercentage4  : in  std_logic_vector (7 downto 0);
        percentage1 : out std_logic_vector (7 downto 0);
        percentage2 : out std_logic_vector (7 downto 0);
        --percentage3  : out  std_logic_vector (7 downto 0);
        --percentage4  : out  std_logic_vector (7 downto 0);
        newpercentage1 : out std_logic_vector (7 downto 0);
        --newpercentage3  : out  std_logic_vector (7 downto 0);
        --newpercentage4  : out  std_logic_vector (7 downto 0);
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

    --type c3_state is (neutral3, damageA3
    --, damageB3
    --); 
    --signal state3, new_state3: c3_state;

    --type c4_state is (neutral4, damageA4
    --, damageB4
    --); 
    --signal state4, new_state4: c4_state;

    signal s1, s2, s3, s4 : unsigned(7 downto 0);

    --signal s5, s6, s7, s8: unsigned(7 downto 0);

    signal s9, s10 : unsigned(7 downto 0);
    --signal s11, s12: unsigned(7 downto 0);
begin
    s1 <= unsigned(oldpercentage1); -- kan ik deze voor zowel de A als B attack gebruiken of overlapt dat waardoor er problemen ontstaan
    s3 <= unsigned(oldpercentage2); -- kan ik deze voor zowel de A als B attack gebruiken of overlapt dat waardoor er problemen ontstaan
    --s5 <= unsigned(oldpercentage3); -- kan ik deze voor zowel de A als B attack gebruiken of overlapt dat waardoor er problemen ontstaan
    --s7 <= unsigned(oldpercentage4); -- kan ik deze voor zowel de A als B attack gebruiken of overlapt dat waardoor er problemen ontstaan

    lbl0 : process (clk)
    begin
        if (clk'event and clk = '1') then
            if res = '1' then
                state1 <= neutral1;
                state2 <= neutral2;
                --state3 <= neutral3;
                --state4 <= neutral4;
            else
                state1 <= new_state1;
                state2 <= new_state2;
                --state3 <= new_state3;
                --state4 <= new_state4;
            end if;
        end if;
    end process;

    lbl1 : process (state1, collision2A1
        , collision2B1, s1, s2, oldpercentage1, s9-- B attack that player 1 receives
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

                
            when damageA1 => -- wat als twee spelers teglijk damage doen op ��n speler dan moeten meer states toegevoegd worden waarin de speler de cumulatieve damage krijgt (alleen als er meerdere spelers in het spel erbij komen)
                s2          <= s1 + to_unsigned(5, 8); --adding the value 5 to the old percentage to get the new percentage
                newpercentage1 <= std_logic_vector(s2);
                percentage1 <= oldpercentage1;
                
                s9 <= s1;
                
                new_state1 <= neutral1; -- met meerdere spelers niet gelijk uit deze state gooien maar kijken of iemand anders damage doet
            when damageB1 => -- wat als twee spelers teglijk damage doen op ��n speler dan moeten meer states toegevoegd worden waarin de speler de cumulatieve damage krijgt (alleen als er meerdere spelers in het spel erbij komen)
                s2             <= s1 + to_unsigned(10, 8); --adding the value 10 to the old percentage to get the new percentage -- deze waarde willen we wss nog wel aanpassen afhankelijk van hoe op deze move is of hoe moeilijk deze move is
                newpercentage1 <= std_logic_vector(s2);
                percentage1    <= std_logic_vector(s9);


                if (s1 < to_unsigned(50, 8)) then
                    s9 <= s1 + to_unsigned(10, 8); -- moet dit miss anders?
                elsif (s1 < to_unsigned(100, 8)) then
                    s9 <= s1 + to_unsigned(20, 8); -- moet dit miss anders?
                elsif (s1 < to_unsigned(200, 8)) then
                    s9 <= s1 + to_unsigned(50, 8); -- moet dit miss anders?
                else
                    s9 <= s1 + to_unsigned(120, 8); -- moet dit miss anders?
                end if;
                new_state1 <= neutral1; -- met meerdere spelers niet gelijk uit deze state gooien maar kijken of iemand anders damage doet

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
            when damageA2 => -- wat als twee spelers teglijk damage doen op ��n speler dan moeten meer states toegevoegd worden waarin de speler de cumulatieve damage krijgt (alleen als er meerdere spelers in het spel erbij komen)
                s4             <= s3 + to_unsigned(5, 8); --adding the value 5 to the old percentage to get the new percentage
                percentage2    <= oldpercentage2;
                newpercentage2 <= std_logic_vector(s4);

                s10 <= s3;

                new_state2     <= neutral2; -- met meerdere spelers niet gelijk uit deze state gooien maar kijken of iemand anders damage doet
            when damageB2 => -- wat als twee spelers teglijk damage doen op ��n speler dan moeten meer states toegevoegd worden waarin de speler de cumulatieve damage krijgt (alleen als er meerdere spelers in het spel erbij komen)
                s4             <= s3 + to_unsigned(10, 8); --adding the value 10 to the old percentage to get the new percentage -- deze waarde willen we wss nog wel aanpassen afhankelijk van hoe op deze move is of hoe moeilijk deze move is
                newpercentage2 <= std_logic_vector(s4);
                percentage2    <= std_logic_vector(s10);


                if (s3 < to_unsigned(50, 8)) then
                    s10 <= s3 + to_unsigned(10, 8); -- moet dit miss anders?
                elsif (s3 < to_unsigned(100, 8)) then
                    s10 <= s3 + to_unsigned(20, 8); -- moet dit miss anders?
                elsif (s3 < to_unsigned(200, 8)) then
                    s10 <= s3 + to_unsigned(50, 8); -- moet dit miss anders?
                else
                    s10 <= s3 + to_unsigned(120, 8); -- moet dit miss anders?
                end if;
                
                new_state2 <= neutral2; -- met meerdere spelers niet gelijk uit deze state gooien maar kijken of iemand anders damage doet
        end case;
    end process;

    --lbl3: process(state3, collision1A3)
    --begin
    --case state1 is
    --when neutral3 =>
    --newpercentage3 <= oldpercentage3;
    --percentage3 <= "00000000";
    --if (collision1A3 = '1') then
    --new_state3 <= damageA3;
    --else
    --new_state3 <= neutral3;
    --end if;
    --when damageA3 => -- wat als twee spelers teglijk damage doen op ��n speler dan moeten meer states toegevoegd worden waarin de speler de cumulatieve damage krijgt (alleen als er meerdere spelers in het spel erbij komen)
    --s6 <= s5 + to_unsigned(5,8); --adding the value 5 to the old percentage to get the new percentage
    --percentage3 <= oldpercentage3;
    --new_state3 <= neutral3; -- met meerdere spelers niet gelijk uit deze state gooien maar kijken of iemand anders damage doet
    --end case;
    --end process;

    --lbl4: process(state4, collision1A4)
    --begin
    --case state4 is
    --when neutral4 =>
    --newpercentage4 <= oldpercentage4;
    --percentage4 <= "00000000";
    --if (collision1A4 = '1') then
    --new_state4 <= damageA4;
    --else
    --new_state4 <= neutral4;
    --end if;
    --when damageA4 => -- wat als twee spelers teglijk damage doen op ��n speler dan moeten meer states toegevoegd worden waarin de speler de cumulatieve damage krijgt (alleen als er meerdere spelers in het spel erbij komen)
    --s8 <= s7 + to_unsigned(5,8); --adding the value 5 to the old percentage to get the new percentage
    --percentage4 <= oldpercentage4;
    --new_state4 <= neutral4; -- met meerdere spelers niet gelijk uit deze state gooien maar kijken of iemand anders damage doet
    --end case;
    --end process;

    --newpercentage3 <= std_logic_vector(s6);
    --newpercentage4 <= std_logic_vector(s8);
    --percentage3 <= std_logic_vector(s11);
    --percentage4 <= std_logic_vector(s12);
end architecture behavioural;