library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity animation_counter_tb is
end entity animation_counter_tb;

architecture tb of animation_counter_tb is
    component animation_counter is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            vsync  : in std_logic;
            sprite: out std_logic_vector(2 downto 0)
        );
    end component;
    signal clk, reset, vsync : std_logic;
    signal sprite: std_logic_vector(2 downto 0);

begin

    ani: animation_counter port map (
        clk => clk, reset => reset, vsync => vsync, sprite => sprite
    );

    clk <= '0' after 0 ns,
        '1' after 20 ns when clk /= '1' else
        '0' after 20 ns;

    
    reset <= '1' after 0 ns,
    '0' after 80 ns;

    vsync <= '0' after 0 ns,
    '1' after 16 ms,
    '0' after 17 ms,
    '1' after 33 ms,
    '0' after 34 ms,
    '1' after 50 ms,
    '0' after 51 ms;





end architecture;