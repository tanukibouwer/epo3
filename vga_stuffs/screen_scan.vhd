--module: screen_scan
--version: 1.0
--author: Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--module description
--
--
--
--
--
--
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity scanner is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        Hsync : out std_logic;
        Vsync : out std_logic
    );
end entity scanner;

architecture rtl of scanner is

    component H_pix_cnt is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            count : out std_logic_vector (10 downto 0)
        );
    end component;

    component Hsync_gen is
        port (
            clk       : in std_logic;
            reset     : in std_logic;
            count     : in std_logic_vector (10 downto 0);
            sync      : out std_logic;
            cnt_reset : out std_logic
        );
    end component;

    component V_line_cnt is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            count : out std_logic_vector (10 downto 0)
        );
    end component;

    component Vsync_gen is
        port (
            clk       : in std_logic;
            reset     : in std_logic;
            count     : in std_logic_vector (10 downto 0);
            sync      : out std_logic;
            cnt_reset : out std_logic
        );
    end component;

    signal vcount, hcount             : std_logic_vector (10 downto 0);
    signal vcount_reset, hcount_reset : std_logic;
    signal Hsync, Vsync               : std_logic;

begin

    gen1_vgen : Vsync_gen port map(
        clk => clk, reset => reset,
        count => vcount,
        sync => Vsync, cnt_reset => vcount_reset
    );

    gen2_hgen : Hsync_gen port map(
        clk => clk, reset => reset,
        count => hcount,
        sync => Hsync, cnt_reset => hcount_reset
    );

    cnt1_vcnt : V_line_cnt port map(
        clk => clk, reset => hcount_reset,
        count => vcount
    );

    cnt2_hcnt : H_pix_cnt port map(
        clk => clk, reset => hcount_reset,
        count => hcount
    );

end architecture;