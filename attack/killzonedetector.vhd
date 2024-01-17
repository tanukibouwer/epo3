library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity killzonedetector is
    port (clk      : in std_logic;
    res            : in std_logic;

    oldpercentage1 : in std_logic_vector (7 downto 0);
    oldpercentage2 : in std_logic_vector (7 downto 0);

    oldvectorX1 : in std_logic_vector (8 downto 0);
    oldvectorY1 : in std_logic_vector (8 downto 0);
    oldvectorX2 : in std_logic_vector (8 downto 0);
    oldvectorY2 : in std_logic_vector (8 downto 0);

    restart1       : out std_logic;
    restart2       : out std_logic;
    newdeathcount1 : out std_logic_vector (3 downto 0);
    newdeathcount2 : out std_logic_vector (3 downto 0));

end entity killzonedetector;


-- 336, 240, 16, 16 boundaries van het zichtbare scherm: xmax, ymax, xmin, ymin
-- 496, 464, 352, 288? boundaries van de killzone: xmax, ymax, xmin, ymin
-- teleportation wordt gergeld door physics


architecture behavioural of killzonedetector is
    type c1_state is (neutral1, detection1, standardposition1, hold1);
    signal state1, new_state1 : c1_state;

    type c2_state is (neutral2, detection2, standardposition2, hold2);
    signal state2, new_state2 : c2_state;

	 signal deathcount1, new_deathcount1 : unsigned(3 downto 0); 
	 signal deathcount2, new_deathcount2 : unsigned(3 downto 0); 
begin
	 newdeathcount1 <= std_logic_vector(deathcount1);
	 newdeathcount2 <= std_logic_vector(deathcount2);

    lbl0 : process (clk)
    begin
        if (clk'event and clk = '1') then
            if res = '1' then
                state1 <= neutral1;
                state2 <= neutral2;
					 deathcount1 <= (others => '0');
					 deathcount2 <= (others => '0');
            else
                state1 <= new_state1;
                state2 <= new_state2;
					 deathcount1 <= new_deathcount1;
					 deathcount2 <= new_deathcount2;
            end if;
        end if;
    end process;

    lbl1 : process (clk)
    begin
        case state1 is
            when neutral1 =>
                new_deathcount1 <= deathcount1;
                restart1   <= '1';
                new_state1 <= hold1;

            when detection1 =>
                new_deathcount1 <= deathcount1 + 1;
                restart1   <= '1';
                new_state1 <= standardposition1;

            when standardposition1 =>
                new_deathcount1 <= deathcount1;
                restart1   <= '1';
                new_state1 <= hold1;

            when hold1 =>
                new_deathcount1 <= deathcount1;
                restart1 <= '0';
                if ((oldvectorX1 > "101100000") and (oldvectorX1 < "111110000")) or ((oldvectorY1 > "100100000") and (oldvectorY1 < "111010000")) then -- boundaries killzone: xmax 496, ymax 464, xmin 352, ymin 288
                    new_state1 <= detection1;
                else
                    new_state1 <= hold1;
                end if;
        end case;
    end process;

    lbl2 : process (state2)
    begin
        case state2 is
            when neutral2 =>
                new_deathcount2 <= deathcount2;
                restart2   <= '1';
                new_state2 <= hold2;

            when detection2 =>
                new_deathcount2 <= deathcount2 + 1;
                restart2   <= '1';
                new_state2 <= standardposition2;

            when standardposition2 =>
                new_deathcount2 <= deathcount2;
                restart2   <= '1';
                new_state2 <= hold2;

            when hold2 =>
                new_deathcount2 <= deathcount2;
                restart2 <= '0';
                if ((oldvectorX2 > "101100000") and (oldvectorX2 < "111110000")) or ((oldvectorY2 > "100100000") and (oldvectorY2 < "111010000")) then -- boundaries killzone: xmax 496, ymax 464, xmin 352, ymin 288
                    new_state2 <= detection2;
                else
                    new_state2 <= hold2;
                end if;
        end case;
    end process;
end architecture behavioural;