library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity sprite_clock_tb is
end entity sprite_clock_tb;

architecture rtl of sprite_clock_tb is

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

    component vsync_cnt is
        port (
            clk : in std_logic;
            reset : in std_logic;
            vcount : in std_logic_vector(9 downto 0);
            count : out std_logic_vector(3 downto 0)
        );
    end component;

    signal clk, reset, Hsync, Vsync : std_logic;
    signal hcount, vcount : std_logic_vector(9 downto 0);
    signal count : std_logic_vector(3 downto 0);
    
begin

    clk <= '0' after 0 ns,
        '1' after 20 ns when clk /= '1' else
        '0' after 20 ns;

    reset <= '1' after 0 ns,
        '0' after 80 ns;

    scan1 : screen_scan port map (
        clk => clk,
        reset => reset,
        Hsync => Hsync,
        Vsync => Vsync,
        hcount_out =>  hcount,
        vcount_out => vcount
    );

    cnt1: vsync_cnt port map (
        clk => clk,
        reset => reset,
        vcount => vcount,
        count => count
    );



end architecture;