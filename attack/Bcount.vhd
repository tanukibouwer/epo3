library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity b_cnt is
    port (
        vsync : in std_logic;
        reset : in std_logic;
	b1    : in std_logic;
	b2    : in std_logic;
        count1 : out std_logic_vector(4 downto 0);
	count2 : out std_logic_vector(4 downto 0)
    );
end entity;

architecture behavioural of b_cnt is
	signal cur_count1, new_count1 : unsigned(4 downto 0);
	signal cur_count2, new_count2 : unsigned(4 downto 0);
begin

    process (vsync) 
    begin
        if falling_edge(vsync) then
            if reset = '1' then
                cur_count1 <= (others => '0');
            elsif (b1 = '1') then
                cur_count1 <= new_count1;
            end if;
        end if;
    end process;

    process (vsync) 
    begin
        if falling_edge(vsync) then
            if reset = '1' then
                cur_count2 <= (others => '0');
            elsif (b2 = '1') then
                cur_count2 <= new_count2;
            end if;
        end if;
    end process;

    process (cur_count1) --count on falling edge vsync
    begin
        new_count1 <= cur_count1 + 1;
    end process;


    process (cur_count2) --count on falling edge vsync
    begin
        new_count2 <= cur_count2 + 1;
    end process;

    	count1 <= std_logic_vector(cur_count1);
	count2 <= std_logic_vector(cur_count2);

    
end architecture;

