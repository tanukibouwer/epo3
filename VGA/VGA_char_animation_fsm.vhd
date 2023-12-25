--module: animation_counter
--version: 1
--author: Parama Fawwaz 
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
--! The fsm that controls the animation of character movement
--! 
--! 
--! 
--! 
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity char_animation_fsm is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        animation_clk : in std_logic_vector(3 downto 0);
        numstate: out std_logic_vector(6 downto 0);

        controller_in : in std_logic_vector(7 downto 0); -- bit 0 = left, bit 1 = right, bit 2 = up, bit 3 = down
        sprite : out std_logic_vector(1 downto 0)
    );
end char_animation_fsm;
architecture behaviour of char_animation_fsm is

    type sprite_state is (
        idle, duck, run_frame1, run_frame2
        );
    signal state, new_state : sprite_state;

begin
    process (clk)
    begin
        if rising_edge(clk) then
            state <= new_state;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                new_state <= idle;
                sprite <= "00";
            else
                case state is
                    when idle =>
                        numstate <= "1111001"; --1
                        sprite <= "00"; -- set sprite to idle
                        if (controller_in = "00000100" or controller_in = "00001000" or controller_in = "00001001" or controller_in = "00001010" or controller_in = "00000110" or controller_in = "00000101" or controller_in = "00000111" or controller_in = "00001011") then -- make sure that going to duck is prioritised
                            new_state <= duck;
                        elsif (controller_in = "00000001" or controller_in = "00000010") then
                            new_state <= run_frame1;
                        else -- remain in idle whenever nothing is pressed
                            new_state <= idle;
                        end if;
                    when duck => 
                        numstate <= "0100100"; --2
                        sprite <= "01"; -- set sprite to duck
                        if (controller_in = "00000000" or controller_in = "00000011") then -- back to idle when nothing is pressed
                            new_state <= idle;
                        elsif (controller_in = "00000001" or controller_in = "00000010") then -- go to the run animation only when left or right is pressed
                            new_state <=  run_frame1;
                        else
                            new_state <= duck;
                        end if;
                    when run_frame1 =>
                        numstate <= "0110000"; --3
                        sprite <= "10"; -- set sprite to run
                        if animation_clk = "1000" then
                            new_state <= run_frame2;
                        elsif (controller_in = "00000000" or controller_in = "00000011") then -- back to idle when nothing is pressed
                            new_state <= idle;
                        elsif (controller_in = "00000100" or controller_in = "00001000" or controller_in = "00001001" or controller_in = "00001010" or controller_in = "00000110" or controller_in = "00000101" or controller_in = "00000111" or controller_in = "00001011") then -- make sure that going to duck is prioritised
                            new_state <= duck;
                        else
                            new_state <= run_frame1;
                        end if;
                    when run_frame2 =>
                        numstate <= "0011001"; --4
                        sprite <= "00"; -- set sprite to idle for animation purposes
                        if animation_clk = "1000" then
                            new_state <= run_frame1;
                        elsif (controller_in = "00000000" or controller_in = "00000011") then -- back to idle when nothing is pressed
                            new_state <= idle;
                        elsif (controller_in = "00000100" or controller_in = "00001000" or controller_in = "00001001" or controller_in = "00001010" or controller_in = "00000110" or controller_in = "00000101" or controller_in = "00000111" or controller_in = "00001011") then -- make sure that going to duck is prioritised
                            new_state <= duck;
                        else
                            new_state <= run_frame2;
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
end behaviour;