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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity game_state_fsm is
    port (
        clk    : in std_logic;
        reset  : in std_logic;

        -- controller input signal, player 1 controls start menu! (see top level)
        controller_in : in std_logic_vector(7 downto 0); -- bit 0 = left, bit 1 = right, bit 2 = up, bit 3 = down, bit 4 = A, bit 5 = B, bit 6 = Start, bit 7 = Select

        --killcounters
        killcountp1 : in std_logic_vector(3 downto 0);
        killcountp2 : in std_logic_vector(3 downto 0);
        
        -- reset to freeze the game at the start of the game
        reset_game : out std_logic;
        

        -- game states
        game : out std_logic;
        p1_wins : out std_logic;
        p2_wins : out std_logic

    );
end game_state_fsm;
architecture behaviour of game_state_fsm is

  
    type sprite_state is (
        startscreen, gamescreen, endscreen1, endscreen2, endscreen3
    );
    signal state, new_state : sprite_state;

begin
    

    process (clk) -- state register -> ONLY REGISTER
    begin
        if rising_edge(clk) then
            state <= new_state;
        end if;
    end process;

    process (clk, controller_in, killcountp1, killcountp2)
    begin
        if rising_edge(clk) then
            if reset = '1' then 
                new_state <= startscreen;
            else
                case state is
                    when startscreen =>
                        game <= '0';
                        p1_wins <= '0';
                        p2_wins <= '0';
     
                        reset_game <= '1';
                   

                    if (controller_in = "01000000") then
                        new_state <= gamescreen;
                    else
                        new_state <= startscreen;
                    end if;
          

                    when gamescreen =>
                        game <= '1';
        
                        p1_wins <= '0';
                        p2_wins <= '0';

           
                        reset_game <= '0';

                    if (unsigned(killcountp2) >= 1) and (unsigned(killcountp2) > unsigned(killcountp1)) then
                        new_state <= endscreen1;
                    elsif (unsigned(killcountp1) >= 1) and (unsigned(killcountp1) > unsigned(killcountp2)) then
                        new_state <= endscreen2;
                    elsif (unsigned(killcountp2) = 1) and (unsigned(killcountp1) = 1) then
                        new_state <= endscreen3;
                    else
                        new_state <= gamescreen;
                    end if;


                    when endscreen1 =>
                        game <= '0';
      
                        p1_wins <= '1';
                        p2_wins <= '0';

   
                        reset_game <= '0';

                    if (controller_in = "10000000") then
                        new_state <= startscreen;
                    else
                        new_state <= endscreen1;
                    end if;

                    when endscreen2 =>
                        game <= '0';
            
                        p1_wins <= '0';
                        p2_wins <= '1';
                        
                        reset_game <= '0';

                        if (controller_in = "10000000") then
                            new_state <= startscreen;
                        else
                            new_state <= endscreen2;
                        end if;

                    when endscreen3 =>
                        game <= '0';

                        p1_wins <= '1';
                        p2_wins <= '1';
                        
                        reset_game <= '0';

                        if (controller_in = "10000000") then
                            new_state <= startscreen;
                        else
                            new_state <= endscreen3;
                        end if;

                end case;
            end if;
        end if;
    end process;
end behaviour;