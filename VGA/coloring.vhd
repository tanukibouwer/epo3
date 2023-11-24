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
        x_lowerbound_ch1 : in std_logic_vector(7 downto 0);
        x_upperbound_ch1 : in std_logic_vector(7 downto 0);
        y_lowerbound_ch1 : in std_logic_vector(7 downto 0);
        y_upperbound_ch1 : in std_logic_vector(7 downto 0);

        x_lowerbound_ch2 : in std_logic_vector(7 downto 0);
        x_upperbound_ch2 : in std_logic_vector(7 downto 0);
        y_lowerbound_ch2 : in std_logic_vector(7 downto 0);
        y_upperbound_ch2 : in std_logic_vector(7 downto 0);
        -- RGB data outputs
        R_data : out std_logic;
        G_data : out std_logic;
        B_data : out std_logic

    );
end entity coloring;

architecture behavioural of coloring is
    signal uns_hcount, uns_vcount                                 : unsigned(9 downto 0);
    signal ch1x1, ch1x2, ch1y1, ch1y2, ch2x1, ch2x2, ch2y1, ch2y2 : unsigned(7 downto 0);

begin

    process (clk, hcount, vcount)
    begin
        uns_hcount <= unsigned(hcount);
        uns_vcount <= unsigned(vcount);

        ch1x1 <= unsigned(x_lowerbound_ch1);
        ch1x2 <= unsigned(x_upperbound_ch1);
        ch2x1 <= unsigned(y_lowerbound_ch2);
        ch2x2 <= unsigned(y_upperbound_ch2);

        if rising_edge(clk) then
            if reset = '1' then
                R_data <= '0';
                G_data <= '0';
                B_data <= '0';
            elsif (uns_hcount > 143 and uns_hcount <= 783) and (uns_vcount > 34 and uns_vcount <= 514) then -- active screen time
                -- priority -> highest priority is first, lowest is last
                if(uns_hcount > 143 and uns_hcount <= 783) and (uns_vcount > 492 and uns_vcount <= 505) then --platform 12 pixels thick 
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                elsif (uns_hcount >= ch1x1 and uns_hcount <= ch1x2) and (uns_vcount >= ch1y1 and uns_vcount <= ch1y2) then
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                elsif (uns_hcount >= ch2x1 and uns_hcount <= ch2x2) and (uns_vcount >= ch2y1 and uns_vcount <= ch2y2) then
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                else
                    R_data <= '0';
                    G_data <= '0';
                    B_data <= '0';
                end if;
            else
                R_data <= '0';
                G_data <= '0';
                B_data <= '0';
            end if;
        end if;
    end process;

end architecture;