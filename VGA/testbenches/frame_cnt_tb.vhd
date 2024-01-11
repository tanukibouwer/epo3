library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity frame_cnt_tb is
end entity frame_cnt_tb;

architecture rtl of frame_cnt_tb is

    component frame_cnt is
        port (
            clk : in std_logic;
            reset : in std_logic;
            vcount : in std_logic_vector(9 downto 0);
            hcount : in std_logic_vector(9 downto 0);
            count : out std_logic_vector(4 downto 0)
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
    signal count : std_logic_vector(4 downto 0);

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
    cnt : frame_cnt port map (
        clk => clk, reset => reset, vcount => vcount, hcount => hcount, count => count
    );

end architecture;