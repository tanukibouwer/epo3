library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
entity coloring_new_tb is
end;

architecture bench of coloring_new_tb is

    component coloring_new is
        port (
            --! global inputs
            clk   : in std_logic;
            reset : in std_logic;
            --! counter data
            hcount : in std_logic_vector(9 downto 0);
            vcount : in std_logic_vector(9 downto 0);
            -- relevant data for x-y locations
            char1x : in std_logic_vector(7 downto 0); --! character 1 coordinates
            char1y : in std_logic_vector(7 downto 0); --! character 1 coordinates
            char2x : in std_logic_vector(7 downto 0); --! character 2 coordinates
            char2y : in std_logic_vector(7 downto 0); --! character 2 coordinates
            -- percentage from attack module
            percentage_p1 : in std_logic_vector(9 downto 0);

            -- RGB data outputs
            R_data : out std_logic_vector(3 downto 0); --! RGB data output
            G_data : out std_logic_vector(3 downto 0); --! RGB data output
            B_data : out std_logic_vector(3 downto 0)  --! RGB data output
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
    -- Ports
    signal clk                    : std_logic;
    signal reset                  : std_logic;
    signal hcount                 : std_logic_vector(9 downto 0);
    signal vcount                 : std_logic_vector(9 downto 0);
    signal char1x                 : std_logic_vector(7 downto 0);
    signal char1y                 : std_logic_vector(7 downto 0);
    signal char2x                 : std_logic_vector(7 downto 0);
    signal char2y                 : std_logic_vector(7 downto 0);
    signal percentage_p1          : std_logic_vector(9 downto 0);
    signal R_data                 : std_logic_vector(3 downto 0);
    signal G_data                 : std_logic_vector(3 downto 0);
    signal B_data                 : std_logic_vector(3 downto 0);
    signal Hsync, Vsync           : std_logic;

begin

    clk <= '0' after 0 ns,
        '1' after 20 ns when clk /= '1' else
        '0' after 20 ns;

    reset <= '1' after 0 ns,
        '0' after 80 ns;

    coloring_new_inst : coloring_new port map(
        clk           => clk,
        reset         => reset,
        hcount        => hcount,
        vcount        => vcount,
        char1x        => char1x,
        char1y        => char1y,
        char2x        => char2x,
        char2y        => char2y,
        percentage_p1 => percentage_p1,
        R_data        => R_data,
        G_data        => G_data,
        B_data        => B_data
    );

    percentage_p1 <= "0100011100";
    char1x        <= "00001111";
    char1y        <= "00001111";
    char2x        <= "00001111";
    char2y        <= "00001111";
    SCNR1 : screen_scan port map(
        clk => clk, reset => reset, Hsync => Hsync, Vsync => Vsync, vcount_out => vcount, hcount_out => hcount
    );

end;