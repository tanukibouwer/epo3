library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity VGA_testbench is
end entity VGA_testbench;

architecture rtl of VGA_testbench is
    component graphics_card is
        port (
            clk    : in std_logic;
            reset  : in std_logic;
            Hsync  : out std_logic;
            Vsync  : out std_logic;
            R_data : out std_logic;
            G_data : out std_logic;
            B_data : out std_logic
        );
    end component;
    signal clk, reset : std_logic;
    signal Hsync, Vsync : std_logic;
    signal R_data, G_data, B_data : std_logic;

begin

    clk <= '0' after 0 ns,
        '1' after 20 ns when clk /= '1' else
        '0' after 20 ns;

    reset <= '1' after 0 ns,
        '0' after 80 ns;

    GC1: graphics_card port map (
        clk => clk, reset => reset, Hsync => Hsync, Vsync => Vsync,
        R_data => R_data, G_data => G_data, B_data => B_data
    );

    R_data <= '1';
    G_data <= '1';
    B_data <= '1';

end architecture;