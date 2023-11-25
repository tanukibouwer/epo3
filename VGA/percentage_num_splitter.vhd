library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity num_splitter is
    port (
        -- clk       : in std_logic;
        -- reset     : in std_logic;
        num2dig      : in std_logic_vector(9 downto 0);
        num1      : out std_logic_vector(3 downto 0);
        num2      : out std_logic_vector(3 downto 0);
    );
end entity num_splitter;


architecture behaviour of perc_num_splitter is
    type perc_num_state is (zero, five, one, two, three, four, five, six, seven, eight, nine, ten, 
                            ten1,ten2, ten3, ten4,ten5,ten6, ten7, ten8, ten9, twenty
                            twenty1, twenty2, twenty3, twenty4, twenty5, twenty6, twenty7, twenty8, twenty9, thirty
                            thirty1, thirty2, thirty3, thirty4, thirty5, thirty6, thirty7, thirty8, thirty9, forty
                            forty1, forty2, forty3, forty4, forty5, forty6, forty7, forty8, forty9, fifty,
                            fifty1, fifty2, fifty3, fifty4, fifty5, fifty6, fifty7, fifty8, fifty9, sixty,
                            sixty1, sixty2, sixty3, sixty4, sixty5, sixty6, sixty7, sixty8, sixty9, zeventy,
                            zeventy1, zeventy2, zeventy3, zeventy4, zeventy5, zeventy6, zeventy7, zeventy8, zeventy9, eighty,
                            eighty1, eighty2, eighty3, eighty4, eighty5, eighty6, eighty7, eighty8, eighty9, zeventy,
                            ninety1, ninety2, ninety3, ninety4, ninety5, ninety6, ninety7, ninety8, ninety9);
    signal state, new_state: number_state;

begin
    
    lbl1:process(clk)
    begin
        if(clk'event and clk = '1') then
            if reset = '1' then
                state <= zero;
            else 
                state <= new_state;
            end if;
        end if;
    end process;
    lbl2: process(state, number)
    begin
        when zero => 
            num1 <= "0000"; --0
            num2 <= "0000"; --0
        when one => 
            num1 <= "0000"; --0
            num2 <= "0001"; --1
        when two => 
            num1 <= "0000"; --0
            num2 <= "0010"; --2
        when three => 
            num1 <= "0000"; --0
            num2 <= "0011"; --3
        when four => 
            num1 <= "0000"; --0
            num2 <= "0100"; --4
        when five => 
            num1 <= "0000"; --0
            num2 <= "0101"; --5
        when six => 
            num1 <= "0000"; --0
            num2 <= "0110"; --6
        when seven => 
            num1 <= "0000"; --0
            num2 <= "0111"; --7
        when eight => 
            num1 <= "0000"; --0
            num2 <= "1000"; --8
        when nine => 
            num1 <= "0000"; --0
            num2 <= "1001"; --9
        when ten => 
            num1 <= "0001"; --1
            num2 <= "0000"; --0


        when ten1 => 
            num1 <= "0001"; --1
            num2 <= "0001"; --1
        when ten2 => 
            num1 <= "0001"; --1
            num2 <= "0010"; --2
        when ten3 => 
            num1 <= "0001"; --1
            num2 <= "0011"; --3
        when ten4 => 
            num1 <= "0001"; --1
            num2 <= "0100"; --4
        when ten5 => 
            num1 <= "0001"; --1
            num2 <= "0101"; --5
        when ten6 => 
            num1 <= "0001"; --1
            num2 <= "0110"; --6
        when ten7 => 
            num1 <= "0001"; --1
            num2 <= "0111"; --7
        when ten8 => 
            num1 <= "0001"; --1
            num2 <= "1000"; --8
        when ten9 => 
            num1 <= "0001"; --1
            num2 <= "1001"; --9
        when twenty => 
            num1 <= "0010"; --2
            num2 <= "0000"; --0

        when ten1 => 
            num1 <= "0001"; --1
            num2 <= "0001"; --1
        when ten2 => 
            num1 <= "0001"; --1
            num2 <= "0010"; --2
        when ten3 => 
            num1 <= "0001"; --1
            num2 <= "0011"; --3
        when ten4 => 
            num1 <= "0001"; --1
            num2 <= "0100"; --4
        when ten5 => 
            num1 <= "0001"; --1
            num2 <= "0101"; --5
        when ten6 => 
            num1 <= "0001"; --1
            num2 <= "0110"; --6
        when ten7 => 
            num1 <= "0001"; --1
            num2 <= "0111"; --7
        when ten8 => 
            num1 <= "0001"; --1
            num2 <= "1000"; --8
        when ten9 => 
            num1 <= "0001"; --1
            num2 <= "1001"; --9
        when twenty => 
            num1 <= "0010"; --2
            num2 <= "0000"; --0

        when twenty1 => 
            num1 <= "0010"; --2
            num2 <= "0001"; --1
        when twenty2 => 
            num1 <= "0010"; --2
            num2 <= "0010"; --2
        when twenty3 => 
            num1 <= "0010"; --2
            num2 <= "0011"; --3
        when twenty4 => 
            num1 <= "0010"; --2
            num2 <= "0100"; --4
        when twenty5 => 
            num1 <= "0010"; --2
            num2 <= "0101"; --5
        when twenty6 => 
            num1 <= "0010"; --2
            num2 <= "0110"; --6
        when twenty7 => 
            num1 <= "0010"; --2
            num2 <= "0111"; --7
        when twenty8 => 
            num1 <= "0010"; --2
            num2 <= "1000"; --8
        when twenty9 => 
            num1 <= "0010"; --2
            num2 <= "1001"; --9
        when twenty => 
            num1 <= "0011"; --3
            num2 <= "0000"; --0

        when thirty1 => 
            num1 <= "0011"; --3
            num2 <= "0001"; --1
        when thirty2 => 
            num1 <= "0011"; --3
            num2 <= "0010"; --2
        when thirty3 => 
            num1 <= "0011"; --3
            num2 <= "0011"; --3
        when thirty4 => 
            num1 <= "0011"; --3
            num2 <= "0100"; --4
        when thirty5 => 
            num1 <= "0011"; --3
            num2 <= "0101"; --5
        when thirty6 => 
            num1 <= "0011"; --3
            num2 <= "0110"; --6
        when thirty7 => 
            num1 <= "0011"; --3
            num2 <= "0111"; --7
        when thirty8 => 
            num1 <= "0011"; --3
            num2 <= "1000"; --8
        when thirty9 => 
            num1 <= "0011"; --3
            num2 <= "1001"; --9
        when thirty => 
            num1 <= "0100"; --4
            num2 <= "0000"; --0

        when forty1 => 
            num1 <= "0100"; --4
            num2 <= "0001"; --1
        when forty2 => 
            num1 <= "0100"; --4
            num2 <= "0010"; --2
        when forty3 => 
            num1 <= "0100"; --4
            num2 <= "0011"; --3
        when forty4 => 
            num1 <= "0100"; --4
            num2 <= "0100"; --4
        when forty5 => 
            num1 <= "0100"; --4
            num2 <= "0101"; --5
        when forty6 => 
            num1 <= "0100"; --4
            num2 <= "0110"; --6
        when forty7 => 
            num1 <= "0100"; --4
            num2 <= "0111"; --7
        when forty8 => 
            num1 <= "0100"; --4
            num2 <= "1000"; --8
        when forty9 => 
            num1 <= "0100"; --4
            num2 <= "1001"; --9
        when fifty => 
            num1 <= "0101"; --5
            num2 <= "0000"; --0

        when fifty1 => 
            num1 <= "0101"; --5
            num2 <= "0001"; --1
        when fifty2 => 
            num1 <= "0101"; --5
            num2 <= "0010"; --2
        when fifty3 => 
            num1 <= "0101"; --5
            num2 <= "0011"; --3
        when fifty4 => 
            num1 <= "0101"; --5
            num2 <= "0100"; --4
        when fifty5 => 
            num1 <= "0101"; --5
            num2 <= "0101"; --5
        when fifty6 => 
            num1 <= "0101"; --5
            num2 <= "0110"; --6
        when fifty7 => 
            num1 <= "0101"; --5
            num2 <= "0111"; --7
        when fifty8 => 
            num1 <= "0101"; --5
            num2 <= "1000"; --8
        when fifty9 => 
            num1 <= "0101"; --5
            num2 <= "1001"; --9
        when sixty => 
            num1 <= "0110"; --6
            num2 <= "0000"; --0


            
        when sixty1 => 
            num1 <= "0110"; --6
            num2 <= "0001"; --1
        when sixty2 => 
            num1 <= "0110"; --6
            num2 <= "0010"; --2
        when sixty3 => 
            num1 <= "0110"; --6
            num2 <= "0011"; --3
        when sixty4 => 
            num1 <= "0110"; --6
            num2 <= "0100"; --4
        when sixty5 => 
            num1 <= "0110"; --6
            num2 <= "0101"; --5
        when sixty6 => 
            num1 <= "0110"; --6
            num2 <= "0110"; --6
        when sixty7 => 
            num1 <= "0110"; --6
            num2 <= "0111"; --7
        when sixty8 => 
            num1 <= "0110"; --6
            num2 <= "1000"; --8
        when sixty9 => 
            num1 <= "0110"; --6
            num2 <= "1001"; --9
        when seventy => 
            num1 <= "0111"; --7
            num2 <= "0000"; --0
            
        when seventy1 => 
            num1 <= "0111"; --7
            num2 <= "0001"; --1
        when seventy2 => 
            num1 <= "0111"; --7
            num2 <= "0010"; --2
        when seventy3 => 
            num1 <= "0111"; --7
            num2 <= "0011"; --3
        when seventy4 => 
            num1 <= "0111"; --7
            num2 <= "0100"; --4
        when seventy5 => 
            num1 <= "0111"; --7
            num2 <= "0101"; --5
        when seventy6 => 
            num1 <= "0111"; --7
            num2 <= "0110"; --6
        when seventy7 => 
            num1 <= "0111"; --7
            num2 <= "0111"; --7
        when seventy8 => 
            num1 <= "0111"; --7
            num2 <= "1000"; --8
        when seventy9 => 
            num1 <= "0111"; --7
            num2 <= "1001"; --9
        when eighty => 
            num1 <= "1000"; --8
            num2 <= "0000"; --0


        when eighty1 => 
            num1 <= "1000"; --8
            num2 <= "0001"; --1
        when eighty2 => 
            num1 <= "1000"; --8
            num2 <= "0010"; --2
        when eighty3 => 
            num1 <= "1000"; --8
            num2 <= "0011"; --3
        when eighty4 => 
            num1 <= "1000"; --8
            num2 <= "0100"; --4
        when eighty5 => 
            num1 <= "1000"; --8
            num2 <= "0101"; --5
        when eighty6 => 
            num1 <= "1000"; --8
            num2 <= "0110"; --6
        when eighty7 => 
            num1 <= "1000"; --8
            num2 <= "0111"; --7
        when eighty8 => 
            num1 <= "1000"; --8
            num2 <= "1000"; --8
        when eighty9 => 
            num1 <= "1000"; --8
            num2 <= "1001"; --9
        when ninety => 
            num1 <= "1001"; --9
            num2 <= "0000"; --0

        when ninenty1 => 
            num1 <= "1001"; --9
            num2 <= "0001"; --1
        when ninenty2 => 
            num1 <= "1001"; --9
            num2 <= "0010"; --2
        when ninenty3 =>
            num1 <= "1001"; --9
            num2 <= "0011"; --3
        when ninenty4 => 
            num1 <= "1001"; --9
            num2 <= "0100"; --4
        when ninenty5 => 
            num1 <= "1001"; --9
            num2 <= "0101"; --5
        when ninenty6 => 
            num1 <= "1001"; --9
            num2 <= "0110"; --6
        when ninenty7 => 
            num1 <= "1001"; --9
            num2 <= "0111"; --7
        when ninenty8 => 
            num1 <= "1001"; --9
            num2 <= "1000"; --8
        when ninenty9 => 
            num1 <= "1001"; --9
            num2 <= "1001"; --9
        end case;
    end process;






end architecture;