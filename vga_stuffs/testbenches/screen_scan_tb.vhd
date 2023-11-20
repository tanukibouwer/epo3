library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity screen_scan_tb is
    port (
    );
end entity screen_scan_tb;

architecture rtl of screen_scan_tb is

    component screen_scan is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            Hsync : out std_logic;
            Vsync : out std_logic
        );
    end component;
    signal clk, reset   : std_logic;
    signal Hsync, Vsync : std_logic;
begin

    clk <= '0' after 0 ns,
        '1' after 20 ns when clk /= '1' else
        '0' after 20 ns;

    reset <= '1' after 0 ns,
        '0' after 80 ns;

    sc1 : screen_scan port map(
        clk => clk, reset => reset, Hsync => Hsync, Vsync => Vsync
    );

end architecture;