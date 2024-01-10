library IEEE;
use IEEE.std_logic_1164.all;

entity topattack is
    port (
        --	newx1out  : out  std_logic_vector (7 downto 0); --x starting location after death player 1
        --	newy1out  : out  std_logic_vector (7 downto 0); --y starting location after death player 1
        --	newx2out  : out  std_logic_vector (7 downto 0); --x starting location after death player 2
        --	newy2out  : out  std_logic_vector (7 downto 0); --y starting location after death player 2
        clk                  : in std_logic; --clock
        res                  : in std_logic; --reset
        vsync                : in std_logic;
        controller1          : in std_logic_vector (7 downto 0);  --input player 1
        controller2          : in std_logic_vector (7 downto 0);  --input player 2
        x1in                 : in std_logic_vector (8 downto 0);  --x position of player 1
        y1in                 : in std_logic_vector (8 downto 0);  --y position of player 1
        x2in                 : in std_logic_vector (8 downto 0);  --x position of player 2
        y2in                 : in std_logic_vector (8 downto 0);  --y position of player 2
        percentage1in        : in std_logic_vector (7 downto 0);  --percentage of player 1
        percentage2in        : in std_logic_vector (7 downto 0);  --percentage of player 2
        killcount1in         : in std_logic_vector (3 downto 0);  --killcount of player 1
        killcount2in         : in std_logic_vector (3 downto 0);  --killcount of player 2
        directionx1out       : out std_logic_vector (7 downto 0); --x direction vector for knockback player 1
        directiony1out       : out std_logic_vector (7 downto 0); --y direction vector for knockback player 1
        directionx2out       : out std_logic_vector (7 downto 0); --x direction vector for knockback player 2
        directiony2out       : out std_logic_vector (7 downto 0); --y direction vector for knockback player 2
        damagepercentage1out : out std_logic_vector (7 downto 0); --damage percentage (output to physics) player 1
        damagepercentage2out : out std_logic_vector (7 downto 0); --damage percentage (output to physics) player 2
        percentage1out       : out std_logic_vector (7 downto 0); --new percentage (output to memory) player 1
        percentage2out       : out std_logic_vector (7 downto 0); --new percentage (output to memory) player 2
        orientation1         : out std_logic;                     --orientation player 1 for vga
        orientation2         : out std_logic;                     --orientation player 2 for vga
        killcount1out        : out std_logic_vector (3 downto 0); --killcount of player 1
        killcount2out        : out std_logic_vector (3 downto 0); --killcount of player 2
        restart1             : out std_logic;                     --restart bit of player 1 for physics in order to reset the velocity
        restart2             : out std_logic);                    --restart bit of player 2 for physics in order to reset the velocity
end entity topattack;

--dont forget to make extra component since there are two FSMs that give a new output percentage so make sure that one has priority over the other (percentage1out and percentage2out)

architecture structural of topattack is

    component orientation is
        port (
            clk     : in std_logic;
            res     : in std_logic;
            input1  : in std_logic_vector (7 downto 0);
            input2  : in std_logic_vector (7 downto 0);
            output1 : out std_logic;
            output2 : out std_logic);
    end component orientation;

    signal or1,
    or2 : std_logic;

    component attackp is
        port (
            clk      : in std_logic;
            res      : in std_logic;
            input1   : in std_logic_vector (7 downto 0);
            input2   : in std_logic_vector (7 downto 0);
            vsync    : in std_logic;
            output1A : out std_logic;
            output1B : out std_logic;
            output2A : out std_logic;
            output2B : out std_logic);
    end component attackp;

    signal at1a,
    at1b,
    at2a,
    at2b : std_logic;

    component damagecalculator is
        port (
            clk            : in std_logic;
            res            : in std_logic;
            collision1A2   : in std_logic;
            collision1B2   : in std_logic;
            collision2A1   : in std_logic;
            collision2B1   : in std_logic;
            oldpercentage1 : in std_logic_vector (7 downto 0);
            oldpercentage2 : in std_logic_vector (7 downto 0);
            percentage1    : out std_logic_vector (7 downto 0);
            percentage2    : out std_logic_vector (7 downto 0);
            newpercentage1 : out std_logic_vector (7 downto 0);
            newpercentage2 : out std_logic_vector (7 downto 0));
    end component damagecalculator;

    component killzonedetector is
        port (
            clk            : in std_logic;
            res            : in std_logic;
            olddeathcount1 : in std_logic_vector (3 downto 0);
            olddeathcount2 : in std_logic_vector (3 downto 0);
            oldpercentage1 : in std_logic_vector (7 downto 0);
            oldpercentage2 : in std_logic_vector (7 downto 0);
            oldvectorX1    : in std_logic_vector (7 downto 0);
            oldvectorY1    : in std_logic_vector (7 downto 0);
            oldvectorX2    : in std_logic_vector (7 downto 0);
            oldvectorY2    : in std_logic_vector (7 downto 0);
            restart1       : out std_logic;
            restart2       : out std_logic;
            newdeathcount1 : out std_logic_vector (3 downto 0);
            newdeathcount2 : out std_logic_vector (3 downto 0));
    end component killzonedetector;

    component coldet is
        port (
            clk          : in std_logic;
            res          : in std_logic;
            a1           : in std_logic;
            a2           : in std_logic;
            b1           : in std_logic;
            b2           : in std_logic;
            o1           : in std_logic;
            o2           : in std_logic;
            x1           : in std_logic_vector (8 downto 0);
            x2           : in std_logic_vector (8 downto 0);
            y1           : in std_logic_vector (8 downto 0);
            y2           : in std_logic_vector (8 downto 0);
            direction_x1 : out std_logic_vector (7 downto 0);
            direction_x2 : out std_logic_vector (7 downto 0);
            direction_y1 : out std_logic_vector(7 downto 0);
            direction_y2 : out std_logic_vector(7 downto 0);
            collision1a2 : out std_logic;
            collision2a1 : out std_logic;
            collision1b2 : out std_logic;
            collision2b1 : out std_logic);
    end component coldet;

    signal co1a2,
    co1b2,
    co2a1,
    co2b1 : std_logic;

begin

    PM1 : orientation port map(
        clk     => clk,
        res     => res,
        input1  => controller1,
        input2  => controller2,
        output1 => or1,
        output2 => or2);
    PM2 : attackp port map(
        clk      => clk,
        res      => res,
        input1   => controller1,
        input2   => controller2,
        vsync    => vsync,
        output1A => at1a,
        output1B => at1b,
        output2A => at2a,
        output2B => at2b);
    PM3 : damagecalculator port map(
        clk            => clk,
        res            => res,
        collision1A2   => co1a2,
        collision1B2   => co1b2,
        collision2A1   => co2a1,
        collision2B1   => co2b1,
        oldpercentage1 => percentage1in,
        oldpercentage2 => percentage2in,
        percentage1    => damagepercentage1out,
        percentage2    => damagepercentage2out,
        newpercentage1 => percentage1out,
        newpercentage2 => percentage2out);
    PM4 : killzonedetector port map(
        clk            => clk,
        res            => res,
        olddeathcount1 => killcount1in,
        olddeathcount2 => killcount2in,
        oldpercentage1 => percentage1in,
        oldpercentage2 => percentage2in,
        oldvectorX1    => x1in,
        oldvectorY1    => y1in,
        oldvectorX2    => x2in,
        oldvectorY2    => y2in,
        restart1       => restart1,
        restart2       => restart2,
        newdeathcount1 => killcount1out,
        newdeathcount2 => killcount2out);
    PM5 : coldet port map(
        clk          => clk,
        res          => res,
        a1           => at1a,
        a2           => at2a,
        b1           => at1b,
        b2           => at2b,
        o1           => or1,
        o2           => or2,
        x1           => x1in,
        x2           => x2in,
        y1           => y1in,
        y2           => y2in,
        direction_x1 => directionx1out,
        direction_x2 => directionx2out,
        direction_y1 => directiony1out,
        direction_y2 => directiony2out,
        collision1a2 => co1a2,
        collision1b2 => co1b2,
        collision2a1 => co2a1,
        collision2b1 => co2b1);
    orientation1 <= or1;
    orientation2 <= or2;
end architecture structural;