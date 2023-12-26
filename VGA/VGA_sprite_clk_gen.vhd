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
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity animation_clk_gen is
    port (
        clk       : in std_logic;
        reset     : in std_logic;
        count     : in std_logic_vector (4 downto 0);
        cnt_reset : out std_logic  -- this also functions as the animation clock
    );
end entity animation_clk_gen;

architecture behaviour of animation_clk_gen is
    signal uns_count : unsigned(4 downto 0);
begin

    process (clk, uns_count)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                cnt_reset <= '1';
            elsif reset = '0' then
                if uns_count = 9 then -- reset the counter when ready
                    cnt_reset <= '1';
                else -- when not ready for next frame keep counting
                    cnt_reset <= '0';
                end if;
            end if;
        end if;
    end process;

    uns_count <= unsigned(count);

end architecture;
