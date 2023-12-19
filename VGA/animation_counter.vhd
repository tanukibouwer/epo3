--module: animation_counter
--version: 1
--author: Parama Fawwaz 
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
--! To time the animation sprites resolution to our will
--! 
--! 
--! 
--! 
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity animation_counter is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        vsync  : in std_logic;
        sprite: out std_logic_vector(2 downto 0)
    );
end animation_counter;

architecture behavioural of animation_counter is
    signal cur_count, new_count : unsigned(2 downto 0);

begin

    
    process (clk) --storage of the count
    begin
        if rising_edge(clk) then
            if reset = '1' then
                cur_count <= (others => '0');
            else
                cur_count <= new_count;
            end if;
        end if;
    end process;

    process (cur_count, vsync) --count on clock/input
    begin
        if (vsync = '1' and cur_count = 0) then
            new_count <= cur_count + 1;
        elsif (vsync = '1' and cur_count = 1) then
            new_count <= cur_count + 1;
        elsif (vsync = '1' and cur_count = 2) then
            new_count <= (others => '0');
        else
        new_count <= cur_count;
        end if;

    sprite <= std_logic_vector(cur_count);
    end process;
    



end architecture;

