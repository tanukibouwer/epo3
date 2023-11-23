--module: coloring
--version: 1.1
--author: Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
-- this module is made to allow the VGA module to actually draw colours to the screen
-- this is done by only allowing the module to write a color whenever the scanning is on active screen time
-- 
-- this module also requires the different x (horizontal) and y (vertical) locations of what needs to be drawn
--
--
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity coloring is
    port (
        -- global inputs
        clk   : in std_logic;
        reset : in std_logic;
        -- counter data
        hcount : in std_logic_vector(9 downto 0);
        vcount : in std_logic_vector(9 downto 0);
        -- relevant data for x-y locations
        -- RGB data outputs
        R_data : out std_logic;
        G_data : out std_logic;
        B_data : out std_logic

    );
end entity coloring;

architecture behavioural of coloring is
    signal uns_hcount, uns_vcount : unsigned(9 downto 0);

begin

    process (clk, hcount, vcount)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                R_data <= '0';
                G_data <= '0';
                B_data <= '0';
            elsif (uns_hcount > 143 and uns_hcount <= 783) and (uns_vcount > 34 and uns_vcount <= 514) then -- active screen time
                -- priority -> highest priority is first, lowest is last
                R_data <= '0';
                G_data <= '0';
                B_data <= '1';
            else
                R_data <= '0';
                G_data <= '0';
                B_data <= '0';
            end if;
        end if;
    end process;

end architecture;
