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
            num1 <= "0000" --0
            num2 <= "0000" --0
        when one => 
        num1 <= "0000" --0
        num2 <= "0001" --1

        --etc




end architecture;