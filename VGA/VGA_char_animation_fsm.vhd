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


entity char_animation_fsm is
    port (
        clk    : in std_logic;
        reset  : in std_logic;

        -- global frame counters
        vcount : in std_logic_vector(9 downto 0); -- vertical frame counter
        hcount : in std_logic_vector(9 downto 0); -- horizontal line counter

        -- controller input signal
        controller_in : in std_logic_vector(7 downto 0); -- bit 0 = left, bit 1 = right, bit 2 = up, bit 3 = down

        -- sprite output value
        sprite        : out std_logic_vector(1 downto 0)  
    );
end char_animation_fsm;
architecture behaviour of char_animation_fsm is

    component frame_cnt is
        port (
            clk : in std_logic;
            reset : in std_logic;
            vcount : in std_logic_vector(9 downto 0);
            hcount : in std_logic_vector(9 downto 0);
            count : out std_logic_vector(4 downto 0)
        );
    end component;

    signal cnt_reset     : std_logic;
    signal frame_count : std_logic_vector(4 downto 0);
    type sprite_state is (
        idle, duck, jump, run_frame1, run_frame2
    );
    signal state, new_state : sprite_state;

begin
    cnt : frame_cnt port map(
        clk    => clk,
        reset  => cnt_reset,
        vcount => vcount,
        hcount => hcount,
        count  => frame_count
    );

    process (clk) -- state register -> ONLY REGISTER
    begin
        if rising_edge(clk) then
            state <= new_state;
        end if;
    end process;

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then -- when reset, go back to the initial state and set the output values
                new_state <= idle;
                sprite    <= "00";
            else
                case state is
                    when idle =>
                        -- numstate <= "1111001"; --1
                        cnt_reset <= '1';
                        sprite    <= "00"; -- set sprite to idle
                        if (controller_in = "00001000" or controller_in = "00001001" or controller_in = "00001010" or controller_in = "00001011") then -- make sure that going to duck is prioritised
                            new_state <= duck;
                        elsif (controller_in = "00000100" or controller_in = "00000110" or controller_in = "00000101" or controller_in = "00000111") then -- second priority is the jump animation
                            cnt_reset <= '0';
                            new_state <= jump;
                        elsif (controller_in = "00000001" or controller_in = "00000010") then -- go to the run animation only when left or right is pressed
                            cnt_reset <= '0';
                            new_state <= run_frame1;
                        else -- remain in idle whenever nothing is pressed
                            new_state <= idle;
                        end if;
                    when duck =>
                        -- numstate <= "0100100"; --2
                        cnt_reset <= '1';
                        sprite    <= "01"; -- set sprite to duck
                        if (controller_in = "00000000" or controller_in = "00000011") then -- back to idle when nothing is pressed
                            new_state <= idle;
                        elsif (controller_in = "00000001" or controller_in = "00000010") then -- go to the run animation only when left or right is pressed
                            cnt_reset <= '0';
                            new_state <= run_frame1;
                        elsif (controller_in = "00000100" or controller_in = "00000110" or controller_in = "00000101" or controller_in = "00000111") then 
                            cnt_reset <= '0';
                            new_state <= jump;
                        else
                            new_state <= duck;
                        end if;
                    when run_frame1 =>
                        -- numstate <= "0110000"; --3
                        cnt_reset <= '0';
                        sprite    <= "10"; -- set sprite to run
                        if unsigned(frame_count) >= 3 then
                            cnt_reset <= '1';
                            new_state <= run_frame2;
                        elsif (controller_in = "00000000" or controller_in = "00000011") then -- back to idle when nothing is pressed
                            cnt_reset <= '1';
                            new_state <= idle;
                        elsif (controller_in = "00001000" or controller_in = "00001001" or controller_in = "00001010" or controller_in = "00001011") then -- make sure that going to duck is prioritised
                            cnt_reset <= '1';
                            new_state <= duck;
                        elsif (controller_in = "00000100" or controller_in = "00000110" or controller_in = "00000101" or controller_in = "00000111") then -- second priority is the jump animation
                            cnt_reset <= '0';
                            new_state <= jump;
                        else
                            cnt_reset <= '0';
                            new_state <= run_frame1;
                        end if;
                    when run_frame2 =>
                        -- numstate <= "0011001"; --4
                        cnt_reset <= '0';
                        sprite    <= "00"; -- set sprite to idle for animation purposes
                        if unsigned(frame_count) >= 3 then
                            cnt_reset <= '1';
                            new_state <= run_frame1;
                        elsif (controller_in = "00000000" or controller_in = "00000011") then -- back to idle when nothing is pressed
                            cnt_reset <= '1';
                            new_state <= idle;
                        elsif (controller_in = "00001000" or controller_in = "00001001" or controller_in = "00001010" or controller_in = "00001011") then -- make sure that going to duck is prioritised
                            cnt_reset <= '1';
                            new_state <= duck;
                        elsif (controller_in = "00000100" or controller_in = "00000110" or controller_in = "00000101" or controller_in = "00000111") then -- second priority is the jump animation
                            cnt_reset <= '0';
                            new_state <= jump;
                        else
                            cnt_reset <= '0';
                            new_state <= run_frame2;
                        end if;
                    when jump => 
                        cnt_reset <=  '0';
                        sprite <= "01";
                        if unsigned(frame_count) >= 10 then
                            cnt_reset <= '1';
                            if (controller_in = "00001011" or controller_in = "00001010" or controller_in = "00001001" or controller_in = "00001000" or controller_in = "00000011" or controller_in = "00000010" or controller_in = "00000001"  or controller_in = "00000000")  then
                                new_state <=  idle;
                            else
                                new_state <= jump;
                            end if;
                        else
                            cnt_reset <= '0';
                            new_state <= jump;
                        end if;
                    when others =>
                        cnt_reset <= '1';
                        sprite <= "00";
                        new_state <= idle;
                end case;
            end if;
        end if;
    end process;
end behaviour;