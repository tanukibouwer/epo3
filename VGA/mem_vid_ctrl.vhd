--module: mem_vid
--version: 1.0
--author: Parama Fawwaz
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
-- deprecated
--
--
--
--
--
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity mem_vid_ctrl is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        vsync : in std_logic;

        address1 : out std_logic;
        address2 : out std_logic;
        address3 : out std_logic;
        address4 : out std_logic;
        write: out std_logic;
        
    );
end entity mem_vid_ctrl;

architecture behaviour of mem_vid_ctrl is
    type vmem_state is (Read_State, Write_State);
    signal state, new_state: vmem_state;
begin
    lbl1: process(clk)
        if (clk’event and clk = '1') then
            if res = '1' then
            state <= OFF0;
            else
            state <= new_state;
            end if;
        end if;
    end process;
        lbl2: process(state, reset)
    begin
        case state is
            when Read_State =>
                address1 <= '1';
                address2 <= '1';
                address3 <= '1';
                address4 <= '1';
                write <= '0';

                if(vsync = '1') then
                    new_state <= Write_state;
                else
                    new_state <= Read_state;
                end if;
            when Write_State =>
                address1 <= '1';
                address2 <= '1';
                address3 <= '1';
                address4 <= '1';
                write <= '1';


                if(vsync = '1') then
                    new_state <= Write_state;
                else
                    new_state <= Read_state;
                end if;
            
        end case;
    end process;
end architecture;