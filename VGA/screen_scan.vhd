--module: screen_scan
--version: 1.0
--author: Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
--! This module is the hierarchical connection of the module that keeps track of which pixel the VGA screen is at
--! This module contains 4 components, Hsync_gen, Vsync_gen, V_line_cnt, H_pix_cnt
--! Vsync_gen and Hsync_gen are the sync signal generators and the controllers of H_pix_cnt and V_line_cnt
--! V_line_cnt keeps track of which line the screen is on, H_pix_cnt keeps track of which pixel the screen is on
--!
--!
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity screen_scan is
    port (
        clk        : in std_logic;
        reset      : in std_logic;
        Hsync      : out std_logic;
        Vsync      : out std_logic;
        hcount_out : out std_logic_vector(9 downto 0);
        vcount_out : out std_logic_vector(9 downto 0)
    );
end entity screen_scan;

architecture rtl of screen_scan is

    component H_pix_cnt is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            count : out std_logic_vector (9 downto 0)
        );
    end component;

    component Hsync_gen is
        port (
            clk       : in std_logic;
            reset     : in std_logic;
            count     : in std_logic_vector (9 downto 0);
            sync      : out std_logic;
            cnt_reset : out std_logic
        );
    end component;

    component V_line_cnt is
        port (
            clk    : in std_logic;
            reset  : in std_logic;
            hcount : in std_logic_vector (9 downto 0);
            count  : out std_logic_vector (9 downto 0)
        );
    end component;

    component Vsync_gen is
        port (
            clk       : in std_logic;
            reset     : in std_logic;
            count     : in std_logic_vector (9 downto 0);
            sync      : out std_logic;
            cnt_reset : out std_logic
        );
    end component;

    signal vcount, hcount             : std_logic_vector (9 downto 0);
    signal vcount_reset, hcount_reset : std_logic;
    signal Hsync_int, Vsync_int       : std_logic;

begin

    gen1_vgen : Vsync_gen port map(
        clk => clk, reset => reset,
        count => vcount,
        sync => Vsync_int, cnt_reset => vcount_reset
    );

    gen2_hgen : Hsync_gen port map(
        clk => clk, reset => reset,
        count => hcount,
        sync => Hsync_int, cnt_reset => hcount_reset
    );

    cnt1_vcnt : V_line_cnt port map(
        clk => clk, reset => vcount_reset,
        hcount => hcount, count => vcount
    );

    cnt2_hcnt : H_pix_cnt port map(
        clk => clk, reset => hcount_reset,
        count => hcount
    );

    Vsync      <= Vsync_int;
    Hsync      <= Hsync_int;
    hcount_out <= hcount;
    vcount_out <= vcount;

end architecture;

configuration screen_scan_rtl_cfg of screen_scan is
    for rtl
        for all : vsync_gen
            use configuration work.vsync_gen_rtl_cfg;
        end for;
        for all : hsync_gen
            use configuration work.hsync_gen_rtl_cfg;
        end for;
        for all : v_line_cnt
            use configuration work.v_line_cnt_behavioural_cfg;
        end for;
        for all : h_pix_cnt
            use configuration work.h_pix_cnt_behavioural_cfg;
        end for;
    end for;
end configuration screen_scan_rtl_cfg;