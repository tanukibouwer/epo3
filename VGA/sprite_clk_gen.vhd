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

entity sprite_clk_gen is
    port (
        clk       : in std_logic;
        reset     : in std_logic;
        count     : in std_logic_vector (3 downto 0);
        sprite_clk      : out std_logic; 
        cnt_reset : out std_logic
    );
end entity sprite_clk_gen;

architecture behaviour of sprite_clk_gen is
    signal uns_count : unsigned(3 downto 0);
begin

    process (clk, uns_count)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                sprite_clk      <= '1';
                cnt_reset <= '1';
            elsif reset = '0' then
                if uns_count    <= 5 then --sync pulse
                    sprite_clk            <= '0';
                    cnt_reset       <= '0';
                else --reset counter
                    sprite_clk      <= '1';
                    cnt_reset <= '1';
                end if;
            end if;
        end if;
    end process;

    uns_count <= unsigned(count);

end architecture;
