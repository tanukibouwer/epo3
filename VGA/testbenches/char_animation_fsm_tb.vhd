library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity char_animation_fsm_tb is
end entity char_animation_fsm_tb;

architecture rtl of char_animation_fsm_tb is

    component char_animation_fsm is
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
    end component;
    
    component screen_scan is
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            Hsync      : out std_logic;
            Vsync      : out std_logic;
            hcount_out : out std_logic_vector(9 downto 0);
            vcount_out : out std_logic_vector(9 downto 0)
        );
    end component;

    signal clk, reset     : std_logic;
    signal vcount, hcount : std_logic_vector(9 downto 0);
    signal Hsync, Vsync   : std_logic;
    signal controller_in  : std_logic_vector(7 downto 0);
    signal sprite         : std_logic_vector(1 downto 0);

begin

    clk <= '0' after 0 ns,
        '1' after 20 ns when clk /= '1' else
        '0' after 20 ns;

    reset <= '1' after 0 ns,
        '0' after 80 ns;

    scnr : screen_scan port map(
        clk        => clk,
        reset      => reset,
        Hsync      => Hsync,
        Vsync      => Vsync,
        hcount_out => hcount,
        vcount_out => vcount
    );
    fsm: char_animation_fsm port map (
        clk => clk,
        reset => reset,
        vcount => vcount,
        hcount => hcount,
        controller_in => controller_in,
        sprite => sprite
    );

    controller_in <= "00000000" after 0 ns,
        "00000100" after 400 ns,
        "00000110" after 800 ns,
        "00000011" after 1200 ns,
        "00001100" after 1600 ns,
        "00000010" after 2000 ns;

end architecture;