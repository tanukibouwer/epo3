
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VDC_tb is
end;

architecture bench of VDC_tb is
    -- Ports
    signal clk           : std_logic;
    signal reset         : std_logic;
    signal char1_x       : std_logic_vector(8 downto 0);
    signal char1_y       : std_logic_vector(8 downto 0);
    signal char2_x       : std_logic_vector(8 downto 0);
    signal char2_y       : std_logic_vector(8 downto 0);
    signal percentage_p1 : std_logic_vector(7 downto 0);
    signal percentage_p2 : std_logic_vector(7 downto 0);
    signal controllerp1  : std_logic_vector(7 downto 0);
    signal controllerp2  : std_logic_vector(7 downto 0);
    signal orientationp1 : std_logic;
    signal orientationp2 : std_logic;
    signal hcount        : std_logic_vector(9 downto 0);
    signal vcount        : std_logic_vector(9 downto 0);
    signal Vsync         : std_logic;
    signal Hsync         : std_logic;
    signal R_data        : std_logic_vector(3 downto 0);
    signal G_data        : std_logic_vector(3 downto 0);
    signal B_data        : std_logic_vector(3 downto 0);
    signal game          : std_logic;
    signal p1_wins       : std_logic;
    signal p2_wins       : std_logic;
    component VDC is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            -- inputs from memory -> relevant data to be displayed on screen
            char1_x       : in std_logic_vector(8 downto 0); -- character 1 x-location
            char1_y       : in std_logic_vector(8 downto 0); -- character 1 y-location
            char2_x       : in std_logic_vector(8 downto 0); -- character 2 x-location
            char2_y       : in std_logic_vector(8 downto 0); -- character 2 y-location
            percentage_p1 : in std_logic_vector(7 downto 0);
            percentage_p2 : in std_logic_vector(7 downto 0);
            -- inputs from attack and input
            controllerp1 : in std_logic_vector(7 downto 0);
            controllerp2 : in std_logic_vector(7 downto 0);
            orientationp1 : in std_logic;
            orientationp2 : in std_logic;
            -- outputs to screen (and other components)
            hcount : out std_logic_vector(9 downto 0);
            vcount : out std_logic_vector(9 downto 0);
            Vsync  : out std_logic; -- sync signals -> active low
            Hsync  : out std_logic; -- sync signals -> active low
            R_data : out std_logic_vector(3 downto 0); -- RGB data to screen
            G_data : out std_logic_vector(3 downto 0); -- RGB data to screen
            B_data : out std_logic_vector(3 downto 0); -- RGB data to screen
    
            -- game states
            game : in std_logic;
            p1_wins : in std_logic;
            p2_wins : in std_logic
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

begin

    VDC_inst : VDC
        port map(
            clk           => clk,
            reset         => reset,
            char1_x       => char1_x,
            char1_y       => char1_y,
            char2_x       => char2_x,
            char2_y       => char2_y,
            percentage_p1 => percentage_p1,
            percentage_p2 => percentage_p2,
            controllerp1  => controllerp1,
            controllerp2  => controllerp2,
            orientationp1 => orientationp1,
            orientationp2 => orientationp2,
            hcount        => hcount,
            vcount        => vcount,
            Vsync         => Vsync,
            Hsync         => Hsync,
            R_data        => R_data,
            G_data        => G_data,
            B_data        => B_data,
            game          => game,
            p1_wins       => p1_wins,
            p2_wins       => p2_wins
        );
    scn: screen_scan
        port map (
            clk   => clk,
            reset => reset,
            Hsync => Hsync,
            Vsync => Vsync,
            hcount_out => hcount,
            vcount_out => vcount
        );
    clk <= '0' after 0 ns,
        '1' after 20 ns when clk /= '1' else
        '0' after 20 ns;

    reset <= '1' after 0 ns,
        '0' after 80 ns;

    char1_x <= "001000110";
    char1_y <= "001100100";
    char2_x <= "011111010";
    char2_y <= "001100100";
    percentage_p1 <= "11010100";
    percentage_p2 <= "00001011";
    controllerp1 <= "00000000" after 0 ns, "00000010" after 15 ms;
    controllerp2 <= "00000000" after 0 ns, "00000010" after 15 ms;
    orientationp1 <= '1' after 0 ns, '0' after 15 ms;
    orientationp2 <= '1' after 0 ns, '0' after 15 ms;

    game <= '0';
    p1_wins <= '0';
    p2_wins <=  '0';

end;