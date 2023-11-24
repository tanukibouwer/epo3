library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity damagecalculator is
   port(clk : in  std_logic;
        res : in  std_logic;
	collision12 : in std_logic;
	collision21 : in std_logic;
	oldpercentage1  : in  std_logic_vector (7 downto 0);
	oldpercentage2  : in  std_logic_vector (7 downto 0);
	percentage1  : out  std_logic_vector (7 downto 0);
	percentage2  : out  std_logic_vector (7 downto 0);
	newpercentage1  : out  std_logic_vector (7 downto 0);
	newpercentage2  : out  std_logic_vector (7 downto 0));
end entity damagecalculator;

architecture behavioural of damagecalculator is
	type c1_state is (neutral1, damageA1); 
	signal state1, new_state1: c1_state;

	type c2_state is (neutral2, damageA2); 
	signal state2, new_state2: c2_state;

	signal s1, s2, s3, s4: unsigned(7 downto 0);
begin
	s1 <= unsigned(oldpercentage1);
	s3 <= unsigned(oldpercentage2);

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

	lbl1: process(state1, collision21)
	begin
		case state1 is
			when neutral1 =>
				newpercentage1 <= oldpercentage1;
				percentage1 <= "00000000";
				if (collision21 = '1') then
					new_state1 <= damageA1;
				else
					new_state1 <= neutral1;
				end if;
			when damageA1 => -- wat als twee spelers teglijk damage doen op één speler dan moeten meer states toegevoegd worden waarin de speler de cumulatieve damage krijgt (alleen als er meerdere spelers in het spel erbij komen)
				s2 <= s1 + to_unsigned(5,8); --adding the value 5 to the old percentage to get the new percentage
				percentage1 <= oldpercentage1;
					new_state1 <= neutral1; -- met meerdere spelers niet gelijk uit deze state gooien maar kijken of iemand anders damage doet
		end case;
	end process;

	lbl2: process(state2, collision12)
	begin
		case state2 is
			when neutral2 =>
				newpercentage2 <= oldpercentage2;
				percentage2 <= "00000000";
				if (collision12 = '1') then
					new_state2 <= damageA2;
				else
					new_state2 <= neutral2;
				end if;
			when damageA2 => -- wat als twee spelers teglijk damage doen op één speler dan moeten meer states toegevoegd worden waarin de speler de cumulatieve damage krijgt (alleen als er meerdere spelers in het spel erbij komen)
				s4 <= s3 + to_unsigned(5,8); --adding the value 5 to the old percentage to get the new percentage
				percentage2 <= oldpercentage2;
					new_state2 <= neutral2; -- met meerdere spelers niet gelijk uit deze state gooien maar kijken of iemand anders damage doet
		end case;
	end process;
	newpercentage1 <= std_logic_vector(s2);
	newpercentage2 <= std_logic_vector(s4);
end architecture behavioural;