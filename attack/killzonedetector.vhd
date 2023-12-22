library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity killzonedetector is
    port (clk      : in std_logic;
    res            : in std_logic;
    olddeathcount1 : in std_logic_vector (3 downto 0);
    olddeathcount2 : in std_logic_vector (3 downto 0);
    --olddeathcount3  : in  std_logic_vector (3 downto 0);
    --olddeathcount4  : in  std_logic_vector (3 downto 0);
    oldpercentage1 : in std_logic_vector (7 downto 0);
    oldpercentage2 : in std_logic_vector (7 downto 0);
    --oldpercentage3  : in  std_logic_vector (7 downto 0);
    --oldpercentage4  : in  std_logic_vector (7 downto 0);
    oldvectorX1 : in std_logic_vector (7 downto 0);
    oldvectorY1 : in std_logic_vector (7 downto 0);
    oldvectorX2 : in std_logic_vector (7 downto 0);
    oldvectorY2 : in std_logic_vector (7 downto 0);
    --oldvectorX3  : in  std_logic_vector (7 downto 0);
    --oldvectorY3  : in  std_logic_vector (7 downto 0);
    --oldvectorX4  : in  std_logic_vector (7 downto 0);
    --oldvectorY4  : in  std_logic_vector (7 downto 0);
    restart1       : out std_logic;
    restart2       : out std_logic;
    newdeathcount1 : out std_logic_vector (3 downto 0);
    newdeathcount2 : out std_logic_vector (3 downto 0);
    --newdeathcount3  : out  std_logic_vector (3 downto 0);
    --newdeathcount4  : out  std_logic_vector (3 downto 0);
    -- -- newpercentage1  : out  std_logic_vector (7 downto 0);
    -- -- newpercentage2  : out  std_logic_vector (7 downto 0));
    ---- newpercentage3  : out  std_logic_vector (7 downto 0);
    ---- newpercentage4  : out  std_logic_vector (7 downto 0);
    --newvectorX3  : out  std_logic_vector (7 downto 0);
    --newvectorY3  : out  std_logic_vector (7 downto 0);
    --newvectorX4  : out  std_logic_vector (7 downto 0);
    --newvectorY4  : out  std_logic_vector (7 downto 0);
    --	newvectorX1  : out  std_logic_vector (7 downto 0);
    --        newvectorY1  : out  std_logic_vector (7 downto 0);
    --	newvectorX2  : out  std_logic_vector (7 downto 0);
    --        newvectorY2  : out  std_logic_vector (7 downto 0));
end entity killzonedetector;

architecture behavioural of killzonedetector is
    type c1_state is (neutral1, detection1, standardposition1, hold1);
    signal state1, new_state1 : c1_state;

    type c2_state is (neutral2, detection2, standardposition2, hold2);
    signal state2, new_state2 : c2_state;

    --type c3_state is (neutral3, detection3, standardposition3, hold3); 
    --signal state3, new_state3: c3_state;

    --type c4_state is (neutral4, detection4, standardposition4, hold4); 
    --signal state4, new_state4: c4_state;

    --	signal newlocationX1, newlocationY1, newlocationX2, newlocationY2: std_logic_vector (7 downto 0);
    --signal newlocationX3, newlocationY3, newlocationX4, newlocationY4: std_logic_vector (7 downto 0);

    signal s1, s2, s3, s4 : unsigned(3 downto 0);
    --signal s5, s6, s7, s8: unsigned(3 downto 0); 
begin
    s1 <= unsigned(olddeathcount1);
    s3 <= unsigned(olddeathcount2);
    --s5 <= unsigned(olddeathcount3);
    --s7 <= unsigned(olddeathcount4);

    --	newlocationX1 <= "00110010"; -- start location 50
    --	newlocationY1 <= "00011110"; -- start location 30
    --	newlocationX2 <= "01110100"; -- start location 116
    --	newlocationY2 <= "00011110"; -- start location 30
    --newlocationX3 <= "01001000"; -- start location 72 (deze is goed)
    --newlocationY3 <= "00011110"; -- start location 30 (deze is goed)
    --newlocationX4 <= "01011110"; -- start location 94 (deze is goed)
    --newlocationY4 <= "00011110"; -- start location 30 (deze is goed)

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

    lbl1 : process (state1, olddeathcount1, oldvectorX1, oldvectorY1)
    begin
        case state1 is
            when neutral1 =>
                newdeathcount1 <= "0000";
                -- newpercentage1 <= "00000001";
                --				newvectorX1 <= newlocationX1;
                --				newvectorY1 <= newlocationY1;
                restart1   <= '1';
                new_state1 <= hold1;

            when detection1 =>
                s2             <= s1 + to_unsigned(1, 4);
                newdeathcount1 <= std_logic_vector(s2);

                -- newpercentage1 <= "00000001";
                --				newvectorX1 <= oldvectorX1;
                --				newvectorY1 <= oldvectorY1;
                restart1   <= '1';
                new_state1 <= standardposition1;

            when standardposition1 =>
                newdeathcount1 <= olddeathcount1;
                -- newpercentage1 <= oldpercentage1;
                --				newvectorX1 <= newlocationX1;
                --				newvectorY1 <= newlocationY1;
                restart1   <= '1';
                new_state1 <= hold1;

            when hold1 =>
                newdeathcount1 <= olddeathcount1;
                -- newpercentage1 <= oldpercentage1;
                --				newvectorX1 <= oldvectorX1;
                --				newvectorY1 <= oldvectorY1;
                restart1 <= '0';
                if (oldvectorX1 > "10101000") or (oldvectorY1 > "01111000") or (oldvectorX1 < "00001000") or (oldvectorY1 < "00001000") then -- 168, 120, 8, 8
                    new_state1 <= detection1;
                else
                    new_state1 <= hold1;
                end if;
        end case;
    end process;

    lbl2 : process (state2, olddeathcount2, oldvectorX2, oldvectorY2)
    begin
        case state2 is
            when neutral2 =>
                newdeathcount2 <= "0000";
                -- newpercentage2 <= "00000001";
                --				newvectorX2 <= newlocationX2;
                --				newvectorY2 <= newlocationY2;
                restart2   <= '1';
                new_state2 <= hold2;

            when detection2 =>
                s4             <= s3 + to_unsigned(1, 4);
                newdeathcount2 <= std_logic_vector(s4);

                -- newpercentage2 <= "00000001";
                --				newvectorX2 <= oldvectorX2;
                --				newvectorY2 <= oldvectorY2;
                restart2   <= '1';
                new_state2 <= standardposition2;

            when standardposition2 =>
                newdeathcount2 <= olddeathcount2;
                -- newpercentage2 <= oldpercentage2;
                --				newvectorX2 <= newlocationX2;
                --				newvectorY2 <= newlocationY2;
                restart2   <= '1';
                new_state2 <= hold2;

            when hold2 =>
                newdeathcount2 <= olddeathcount2;
                -- newpercentage2 <= oldpercentage2;
                --				newvectorX2 <= oldvectorX2;
                --				newvectorY2 <= oldvectorY2;
                restart2 <= '0';
                if (oldvectorX2 > "10101000") or (oldvectorY2 > "01111000") or (oldvectorX2 < "00001000") or (oldvectorY2 < "00001000") then -- 168, 120, 8, 8
                    new_state2 <= detection2;
                else
                    new_state2 <= hold2;
                end if;
        end case;
    end process;

    --lbl3: process(state3, olddeathcount3, oldvectorX3, oldvectorY3)
    --begin
    --case state3 is
    --when neutral3 =>
    --newdeathcount3 <= "0000";
    ---- newpercentage3 <= "00000001";
    --newvectorX3 <= newlocationX3;
    --newvectorY3 <= newlocationY3;
    --new_state3 <= hold3;

    --when detection3 =>
    --s6 <= s5 + to_unsigned(1,4);
    ---- newpercentage3 <= "00000001";
    --newvectorX3 <= oldvectorX3;
    --newvectorY3 <= oldvectorY3;
    --new_state3 <= standardposition3;

    --when standardposition3 =>
    --newdeathcount3 <= olddeathcount3;
    ---- newpercentage3 <= oldpercentage3;
    --newvectorX3 <= newlocationX3;
    --newvectorY3 <= newlocationY3;
    --new_state3 <= hold3;

    --when hold3 =>
    --newdeathcount3 <= olddeathcount3;
    ---- newpercentage3 <= oldpercentage3;
    --newvectorX3 <= oldvectorX3;
    --newvectorY3 <= oldvectorY3;
    --if (oldvectorX3 > "10101000") or (oldvectorY3 > "01111000") or (oldvectorX3 < "00001000") or (oldvectorY3 < "00001000") then -- 168, 120, 8, 8
    --new_state3 <= detection3;
    --else
    --new_state3 <= hold3;
    --end if;
    --end case;
    --end process;

    --lbl4: process(state4, olddeathcount4, oldvectorX4, oldvectorY4)
    --begin
    --case state4 is
    --when neutral4 =>
    --newdeathcount4 <= "0000";
    ---- newpercentage4 <= "00000001";
    --newvectorX4 <= newlocationX4;
    --newvectorY4 <= newlocationY4;
    --new_state4 <= hold4;

    --when detection4 =>
    --s8 <= s7 + to_unsigned(1,4);
    ---- newpercentage4 <= "00000001";
    --newvectorX4 <= oldvectorX4;
    --newvectorY4 <= oldvectorY4;
    --new_state4 <= standardposition4;

    --when standardposition4 =>
    --newdeathcount4 <= olddeathcount4;
    ---- newpercentage4 <= oldpercentage4;
    --newvectorX4 <= newlocationX4;
    --newvectorY4 <= newlocationY4;
    --new_state4 <= hold4;

    --when hold4 =>
    --newdeathcount4 <= olddeathcount4;
    ---- newpercentage4 <= oldpercentage4;
    --newvectorX4 <= oldvectorX4;
    --newvectorY4 <= oldvectorY4;
    --if (oldvectorX4 > "10101000") or (oldvectorY4 > "01111000") or (oldvectorX4 < "00001000") or (oldvectorY4 < "00001000") then -- 168, 120, 8, 8
    --new_state4 <= detection4;
    --else
    --new_state4 <= hold4;
    --end if;
    --end case;
    --end process;

    --newdeathcount3 <= std_logic_vector(s6);
    --newdeathcount4 <= std_logic_vector(s8);
end architecture behavioural;