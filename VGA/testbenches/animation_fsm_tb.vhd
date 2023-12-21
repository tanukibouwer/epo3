library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity char_animation_fsm_tb is
end entity char_animation_fsm_tb;

architecture tb of char_animation_fsm_tb is
    component char_animation_fsm is
        port(sprite_clk  :in    std_logic;
            reset  :in    std_logic;

            controller_in : in std_logic_vector(7 downto 0); -- bit 0 = left, bit 1 = right, bit 2 = up, bit 3 = down
            orientation   : in std_logic; --1 is right, 0 is left
            sprite  : out std_logic_vector(2 downto 0)
        );
    end component;
    signal reset, sprite_clk : std_logic;
    signal sprite: std_logic_vector(2 downto 0);
    signal controller_in : std_logic_vector(7 downto 0); 
    signal orientation  : std_logic; 


begin

    animation_fsm: char_animation_fsm port map (
        sprite_clk => sprite_clk, reset => reset, controller_in => controller_in, orientation => orientation, sprite => sprite
    );

    sprite_clk <= '0' after 0 ns,
        '1' after 1 ms when sprite_clk /= '1' else
        '0' after 99 ms; 

    
    reset <= '1' after 0 ns,
            '0' after 1 ms;

    controller_in <= "00000000" after 0 ns,
    "00000001" after 100 ms, -- going left
    "00000000" after 500 ms, -- not anymore
    "00000010" after 600 ms, --going right
    "00000000" after 1000 ms, --not anymore
    "00000100" after 1100 ms, --going up
    "00000000" after 1500 ms, --not anymore
    "00001000" after 1600 ms, --going down
    "00000000" after 2000 ms, --not anymore
    "00000001" after 2600 ms, --going one direction
    "00000101" after 3000 ms; --jump!

    orientation <= '1' after 0 ns;






end architecture;