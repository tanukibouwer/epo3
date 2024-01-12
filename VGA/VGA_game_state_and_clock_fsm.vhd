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

        -- controller input signal
        controller_in : in std_logic_vector(7 downto 0); -- bit 0 = left, bit 1 = right, bit 2 = up, bit 3 = down, bit 4 = A, bit 5 = B, bit 6 = Start, bit 7 = Select

        -- sprite output value
        game : out std_logic;
        game_over : out std_logic;

        -- reset to freeze the game at the start of the game
        reset_game : out std_logic;
        
        -- ewi clk sprites
        -- ewi_clk_sprite : out std_logic_vector(2 downto 0)

        
        -- global frame counters
        vcount : in std_logic_vector(9 downto 0); -- vertical frame counter
        hcount : in std_logic_vector(9 downto 0) -- horizontal line counter
    );
end game_state_fsm;
architecture behaviour of game_state_fsm is

    component timer_cnt is
        port (
            clk : in std_logic;
            reset : in std_logic;
            vcount : in std_logic_vector(9 downto 0);
            hcount : in std_logic_vector(9 downto 0);
            count : out std_logic_vector(13 downto 0)
        );
    end component;

    signal cnt_reset     : std_logic;
    signal timer_count : std_logic_vector(13 downto 0);
    type sprite_state is (
        startscreen, gamescreen, endscreen
    );
    signal state, new_state : sprite_state;

begin
    cnt : timer_cnt port map(
        clk    => clk,
        reset  => cnt_reset,
        vcount => vcount,
        hcount => hcount,
        count  => timer_count
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
            if reset = '1' then 
                new_state <= startscreen;
            else
                case state is
                    when startscreen =>
                        game <= '0';
                        game_over <= '0';
                        cnt_reset <= '1';
                        reset_game <= '1';
                    --    ewi_clk_state <= "000";

                    if (controller_in = "01000000") then
                        new_state <= gamescreen;
                    else
                        new_state <= startscreen;
                    end if;
          
                    -- when game1 =>
                    --     game <= '1';
                    --     game_over <= '0';
                    --     cnt_reset <= '0';
                    --     ewi_clk_state <= "000";

                    -- if (unsigned(timer_count) = 11250)
                    --     new_state <= game_over;
                    -- else
                    --     new_state <= game;
                    -- end if;

                    -- when game2 =>
                    --     game <= '1';
                    --     game_over <= '0';
                    --     cnt_reset <= '0';
                    --     ewi_clk_state <= "001";

                    -- if (unsigned(timer_count) = 8437)
                    --     new_state <= game_over;
                    -- else
                    --     new_state <= game;
                    -- end if;

                    -- when game3 =>
                    --     game <= '1';
                    --     game_over <= '0';
                    --     cnt_reset <= '0';
                    --     ewi_clk_state <= "010";

                    -- if (unsigned(timer_count) = 5625)
                    --     new_state <= game_over;
                    -- else
                    --     new_state <= game;
                    -- end if;

                    -- when game4 =>
                    --     game <= '1';
                    --     game_over <= '0';
                    --     cnt_reset <= '0';
                    --     ewi_clk_state <= "011";

                    -- if (unsigned(timer_count) = 2821)
                    --     new_state <= game_over;
                    -- else
                    --     new_state <= game;
                    -- end if;

                    when gamescreen =>
                        game <= '1';
                        game_over <= '0';
                        cnt_reset <= '0';
                        --ewi_clk_state <= "100";
                        reset_game <= '0';

                    if (unsigned(timer_count) = 0) then
                        new_state <= endscreen;
                    else
                        new_state <= gamescreen;
                    end if;


                    when endscreen =>
                        game <= '0';
                        game_over <= '1';
                        cnt_reset <= '1';
                      --  ewi_clk_state <= "100";
                        reset_game <= '0';

                    if (controller_in = "10000000") then
                        new_state <= startscreen;
                    else
                        new_state <= endscreen;
                    end if;

                end case;
            end if;
        end if;
    end process;
end behaviour;