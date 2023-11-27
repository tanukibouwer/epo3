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
        x_lowerbound_ch1 : in std_logic_vector(9 downto 0);
        x_upperbound_ch1 : in std_logic_vector(9 downto 0);
        y_lowerbound_ch1 : in std_logic_vector(9 downto 0);
        y_upperbound_ch1 : in std_logic_vector(9 downto 0);

        x_lowerbound_ch2 : in std_logic_vector(9 downto 0);
        x_upperbound_ch2 : in std_logic_vector(9 downto 0);
        y_lowerbound_ch2 : in std_logic_vector(9 downto 0);
        y_upperbound_ch2 : in std_logic_vector(9 downto 0);
        -- percentage sprites
        -- p1_dig1_line1    : in std_logic_vector(3 downto 0);
        -- p1_dig1_line2    : in std_logic_vector(3 downto 0);   
        -- p1_dig1_line3    : in std_logic_vector(3 downto 0);   
        -- p1_dig1_line4    : in std_logic_vector(3 downto 0);
        -- p1_dig1_line5    : in std_logic_vector(3 downto 0);   
        -- p1_dig1_line6    : in std_logic_vector(3 downto 0);   
        -- p1_dig1_line7    : in std_logic_vector(3 downto 0);

        -- p1_dig2_line1    : in std_logic_vector(3 downto 0);
        -- p1_dig2_line2    : in std_logic_vector(3 downto 0);   
        -- p1_dig2_line3    : in std_logic_vector(3 downto 0);   
        -- p1_dig2_line4    : in std_logic_vector(3 downto 0);
        -- p1_dig2_line5    : in std_logic_vector(3 downto 0);   
        -- p1_dig2_line6    : in std_logic_vector(3 downto 0);   
        -- p1_dig2_line7    : in std_logic_vector(3 downto 0);

        -- p1_dig3_line1    : in std_logic_vector(3 downto 0);
        -- p1_dig3_line2    : in std_logic_vector(3 downto 0);   
        -- p1_dig3_line3    : in std_logic_vector(3 downto 0);   
        -- p1_dig3_line4    : in std_logic_vector(3 downto 0);
        -- p1_dig3_line5    : in std_logic_vector(3 downto 0);   
        -- p1_dig3_line6    : in std_logic_vector(3 downto 0);   
        -- p1_dig3_line7    : in std_logic_vector(3 downto 0);

        -- p2_dig1_line1    : in std_logic_vector(3 downto 0);
        -- p2_dig1_line2    : in std_logic_vector(3 downto 0);   
        -- p2_dig1_line3    : in std_logic_vector(3 downto 0);   
        -- p2_dig1_line4    : in std_logic_vector(3 downto 0);
        -- p2_dig1_line5    : in std_logic_vector(3 downto 0);   
        -- p2_dig1_line6    : in std_logic_vector(3 downto 0);   
        -- p2_dig1_line7    : in std_logic_vector(3 downto 0);

        -- p2_dig2_line1    : in std_logic_vector(3 downto 0);
        -- p2_dig2_line2    : in std_logic_vector(3 downto 0);   
        -- p2_dig2_line3    : in std_logic_vector(3 downto 0);   
        -- p2_dig2_line4    : in std_logic_vector(3 downto 0);
        -- p2_dig2_line5    : in std_logic_vector(3 downto 0);   
        -- p2_dig2_line6    : in std_logic_vector(3 downto 0);   
        -- p2_dig2_line7    : in std_logic_vector(3 downto 0);

        -- p2_dig3_line1    : in std_logic_vector(3 downto 0);
        -- p2_dig3_line2    : in std_logic_vector(3 downto 0);   
        -- p2_dig3_line3    : in std_logic_vector(3 downto 0);   
        -- p2_dig3_line4    : in std_logic_vector(3 downto 0);
        -- p2_dig3_line5    : in std_logic_vector(3 downto 0);   
        -- p2_dig3_line6    : in std_logic_vector(3 downto 0);   
        -- p2_dig3_line7    : in std_logic_vector(3 downto 0);
        -- RGB data outputs
        R_data : out std_logic;
        G_data : out std_logic;
        B_data : out std_logic

    );
end entity coloring;

architecture behavioural of coloring is
    signal uns_hcount, uns_vcount                                 : unsigned(9 downto 0);
    signal ch1x1, ch1x2, ch1y1, ch1y2, ch2x1, ch2x2, ch2y1, ch2y2 : unsigned(9 downto 0);

begin

    uns_hcount <= unsigned(hcount);
    uns_vcount <= unsigned(vcount);

    ch1x1 <= unsigned(x_lowerbound_ch1);
    ch1x2 <= unsigned(x_upperbound_ch1);
    ch2x1 <= unsigned(y_lowerbound_ch2);
    ch2x2 <= unsigned(y_upperbound_ch2);

    process (clk, hcount, vcount)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                R_data <= '0';
                G_data <= '0';
                B_data <= '0';
            elsif (uns_hcount > 143 and uns_hcount <= 783) and (uns_vcount > 34 and uns_vcount <= 514) then -- active screen time
                -- priority -> highest priority is first, lowest is last
                if(uns_hcount > 143 and uns_hcount <= 783) and (uns_vcount > 429 and uns_vcount <= 434) then --platform horizon (4) pixels thick y = 21 (in coords from below) 
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                elsif (uns_hcount >= ch1x1 and uns_hcount <= ch1x2) and (uns_vcount >= ch1y1 and uns_vcount <= ch1y2) then --character 1
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                elsif (uns_hcount >= ch2x1 and uns_hcount <= ch2x2) and (uns_vcount >= ch2y1 and uns_vcount <= ch2y2) then --character 2
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                elsif (uns_hcount > 143 and uns_hcount <= 183) and (uns_vcount > 434 and uns_vcount <= 514 ) then --percentage box1 player 1: this displays a constant image
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                elsif (uns_hcount > 183 and uns_hcount <= 223) and (uns_vcount > 434 and uns_vcount <= 514) then --percentage box2 player 1

                    if(uns_hcount > 183 and uns_hcount <= 187) and (uns_vcount > 434 and uns_vcount <= 514 ) then -- horizontal separation
                        R_data <= '1';
                        G_data <= '1';
                        B_data <= '1';

                    elsif(uns_hcount > 187 and uns_hcount <= 219) and (uns_vcount > 434 and uns_vcount <= 446 ) then -- vertical separation
                        R_data <= '1';
                        G_data <= '1';
                        B_data <= '1';


                        elsif(uns_hcount > 187 and uns_hcount <= 195) and (uns_vcount > 446  and uns_vcount <= 454) then --line1(0)
                            if(p1_dig1_line1(0) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 195 and uns_hcount <= 203) and (uns_vcount > 446  and uns_vcount <= 454) then --line1(1)
                            if(p1_dig1_line1(1) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 203 and uns_hcount <= 211) and (uns_vcount > 446  and uns_vcount <= 454) then --line1(2)
                            if(p1_dig1_line1(2) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;
                        elsif(uns_hcount > 211 and uns_hcount <= 219) and (uns_vcount > 446  and uns_vcount <= 454) then --line1(3)
                            if(p1_dig1_line1(3) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 187 and uns_hcount <= 195) and (uns_vcount > 446  and uns_vcount <= 454) then --line2(0)
                            if(p1_dig1_line2(0) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 195 and uns_hcount <= 203) and (uns_vcount > 446  and uns_vcount <= 454) then --line2(1)
                            if(p1_dig1_line2(1) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 203 and uns_hcount <= 211) and (uns_vcount > 446  and uns_vcount <= 454) then --line2(2)
                            if(p1_dig1_line2(2) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;
                        elsif(uns_hcount > 211 and uns_hcount <= 219) and (uns_vcount > 446  and uns_vcount <= 454) then --line2(3)
                            if(p1_dig1_line2(3) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;



                        elsif(uns_hcount > 187 and uns_hcount <= 195) and (uns_vcount > 446  and uns_vcount <= 454) then --line3(0)
                            if(p1_dig1_line3(0) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 195 and uns_hcount <= 203) and (uns_vcount > 446  and uns_vcount <= 454) then --line3(1)
                            if(p1_dig1_line3(1) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 203 and uns_hcount <= 211) and (uns_vcount > 446  and uns_vcount <= 454) then --line3(2)
                            if(p1_dig1_line3(2) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;
                        elsif(uns_hcount > 211 and uns_hcount <= 219) and (uns_vcount > 446  and uns_vcount <= 454) then --line3(3)
                            if(p1_dig1_line3(3) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 187 and uns_hcount <= 195) and (uns_vcount > 446  and uns_vcount <= 454) then --line4(0)
                            if(p1_dig1_line4(0) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 195 and uns_hcount <= 203) and (uns_vcount > 446  and uns_vcount <= 454) then --line4(1)
                            if(p1_dig1_line4(1) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 203 and uns_hcount <= 211) and (uns_vcount > 446  and uns_vcount <= 454) then --line4(2)
                            if(p1_dig1_line4(2) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;
                        elsif(uns_hcount > 211 and uns_hcount <= 219) and (uns_vcount > 446  and uns_vcount <= 454) then --line4(3)
                            if(p1_dig1_line4(3) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 187 and uns_hcount <= 195) and (uns_vcount > 446  and uns_vcount <= 454) then --line5(0)
                            if(p1_dig1_line5(0) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 195 and uns_hcount <= 203) and (uns_vcount > 446  and uns_vcount <= 454) then --line5(1)
                            if(p1_dig1_line5(1) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 203 and uns_hcount <= 211) and (uns_vcount > 446  and uns_vcount <= 454) then --line5(2)
                            if(p1_dig1_line1(2) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;
                        elsif(uns_hcount > 211 and uns_hcount <= 219) and (uns_vcount > 446  and uns_vcount <= 454) then --line5(3)
                            if(p1_dig1_line5(3) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 187 and uns_hcount <= 195) and (uns_vcount > 446  and uns_vcount <= 454) then --line6(0)
                            if(p1_dig1_line6(0) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 195 and uns_hcount <= 203) and (uns_vcount > 446  and uns_vcount <= 454) then --line6(1)
                            if(p1_dig1_line6(1) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 203 and uns_hcount <= 211) and (uns_vcount > 446  and uns_vcount <= 454) then --line6(2)
                            if(p1_dig1_line6(2) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;
                        elsif(uns_hcount > 211 and uns_hcount <= 219) and (uns_vcount > 446  and uns_vcount <= 454) then --line6(3)
                            if(p1_dig1_line6(3) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;



                        elsif(uns_hcount > 187 and uns_hcount <= 195) and (uns_vcount > 446  and uns_vcount <= 454) then --line7(0)
                            if(p1_dig1_line7(0) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 195 and uns_hcount <= 203) and (uns_vcount > 446  and uns_vcount <= 454) then --line7(1)
                            if(p1_dig1_line7(1) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        elsif(uns_hcount > 203 and uns_hcount <= 211) and (uns_vcount > 446  and uns_vcount <= 454) then --line7(2)
                            if(p1_dig1_line7(2) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;
                        elsif(uns_hcount > 211 and uns_hcount <= 219) and (uns_vcount > 446  and uns_vcount <= 454) then --line7(3)
                            if(p1_dig1_line7(3) = 1) then
                                R_data <= '1';
                                G_data <= '1';
                                B_data <= '1';
                            else
                                R_data <= '0';
                                G_data <= '0';
                                B_data <= '0';
                            end if;

                        
                    elsif(uns_hcount > 187 and uns_hcount <= 219) and (uns_vcount > 502  and uns_vcount <= 514) then -- vertical separation
                        R_data <= '1';
                        G_data <= '1';
                        B_data <= '1';

                    elsif(uns_hcount > 219 and uns_hcount <= 223) and (uns_vcount > 434  and uns_vcount <= 514) then -- horizontal separation
                        R_data <= '1';
                        G_data <= '1';
                        B_data <= '1';
                    end if;

                    

                elsif (uns_hcount > 223 and uns_hcount <=263) and (uns_vcount >=  and uns_vcount <= ) then --percentage box3 player 1
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                elsif (uns_hcount > 263 and uns_hcount <= 303) and (uns_vcount >=  and uns_vcount <= 514) then --percentage box4 player 1
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                
            

                elsif (uns_hcount >= 624 and uns_hcount <= 663) and (uns_vcount >= 497 and uns_vcount <= 514) then --percentage box1 player 2
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                elsif (uns_hcount >= 664 and uns_hcount <= 703) and (uns_vcount >= 497 and uns_vcount <= 514) then --percentage box2 player 2 
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                elsif (uns_hcount >= 704 and uns_hcount <= 743) and (uns_vcount >= 497 and uns_vcount <= 514) then --percentage box3 player 2
                    R_data <= '1';
                    G_data <= '1';
                    B_data <= '1';
                elsif (uns_hcount >= 744 and uns_hcount <= 783) and (uns_vcount >= 497 and uns_vcount <= 514) then --percentage box4 player 2
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