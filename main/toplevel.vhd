library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity chip_toplevel is
    port (
        -- general i/o
        clk   : in std_logic;
        reset : in std_logic;
        -- input i/o
        p1_controller    : in std_logic;
        p2_controller    : in std_logic;
        controller_latch : out std_logic;
        controller_clk   : out std_logic;
        -- directionx1out   : out std_logic_vector(7 downto 0);
        -- graphics i/o
        Vsync  : out std_logic;                    -- sync signals -> active low
        Hsync  : out std_logic;                    -- sync signals -> active low
        R_data : out std_logic_vector(3 downto 0); -- RGB data to screen
        G_data : out std_logic_vector(3 downto 0); -- RGB data to screen
        B_data : out std_logic_vector(3 downto 0)  -- RGB data to screen
    );
end chip_toplevel;

architecture structural of chip_toplevel is

    -- knockback direction vectors as info from attack to physics
    signal dirx1new1 : std_logic_vector(8 downto 0); -- output from attack, into physics
    signal dirx2new1 : std_logic_vector(8 downto 0); -- output from attack, into physics
    signal diry1new1 : std_logic_vector(8 downto 0); -- output from attack, into physics
    signal diry2new1 : std_logic_vector(8 downto 0); -- output from attack, into physics
    signal dirx1new2 : std_logic_vector(8 downto 0); -- output from attack, into physics
    signal dirx2new2 : std_logic_vector(8 downto 0); -- output from attack, into physics
    signal diry1new2 : std_logic_vector(8 downto 0); -- output from attack, into physics
    signal diry2new2 : std_logic_vector(8 downto 0); -- output from attack, into physics

    -- orientation signal to know which direction to render the character
    signal orientationp1 : std_logic; -- output from attack, into graphics
    signal orientationp2 : std_logic; -- output from attack, into graphics

    -- to tap the vsync signal for global memory timing purposes
    signal vsyncintern : std_logic; -- input into memory, out from graphics

    -- character position and velocity vectors
    signal char1posx   : std_logic_vector(8 downto 0); -- output from memory, into graphics and physics
    signal char1posy   : std_logic_vector(8 downto 0); -- output from memory, into graphics and physics
    signal char2posx   : std_logic_vector(8 downto 0); -- output from memory, into graphics and physics
    signal char2posy   : std_logic_vector(8 downto 0); -- output from memory, into graphics and physics
    signal char1posxin : std_logic_vector(8 downto 0); -- inputs into memory, out from physics
    signal char1posyin : std_logic_vector(8 downto 0); -- inputs into memory, out from physics
    signal char2posxin : std_logic_vector(8 downto 0); -- inputs into memory, out from physics
    signal char2posyin : std_logic_vector(8 downto 0); -- inputs into memory, out from physics
    signal char1velx   : std_logic_vector(9 downto 0); -- output from memory, into physics
    signal char1vely   : std_logic_vector(9 downto 0); -- output from memory, into physics
    signal char2velx   : std_logic_vector(9 downto 0); -- output from memory, into physics
    signal char2vely   : std_logic_vector(9 downto 0); -- output from memory, into physics
    signal char1velxin : std_logic_vector(9 downto 0); -- inputs into memory, out from physics
    signal char1velyin : std_logic_vector(9 downto 0); -- inputs into memory, out from physics
    signal char2velxin : std_logic_vector(9 downto 0); -- inputs into memory, out from physics
    signal char2velyin : std_logic_vector(9 downto 0); -- inputs into memory, out from physics

    -- character damage percentages and death counts
    signal char1perc     : std_logic_vector(7 downto 0); -- output from memory, into attack and graphics
    signal char2perc     : std_logic_vector(7 downto 0); -- output from memory, into attack and graphics
    signal char1percin   : std_logic_vector(7 downto 0); -- inputs into memory, from attack
    signal char2percin   : std_logic_vector(7 downto 0); -- inputs into memory, from attack
    signal char1perctemp : std_logic_vector(7 downto 0); -- inputs into physics, from attack
    signal char2perctemp : std_logic_vector(7 downto 0); -- inputs into physics, from attack
    signal char1dc       : std_logic_vector(3 downto 0); -- output from memory, into attack
    signal char2dc       : std_logic_vector(3 downto 0); -- output from memory, into attack
    signal char1dcin     : std_logic_vector(3 downto 0); -- inputs into memory, from attack
    signal char2dcin     : std_logic_vector(3 downto 0); -- inputs into memory, from attack
    signal char1death    : std_logic;                    -- inputs into memory, from attack
    signal char2death    : std_logic;                    -- inputs into memory, from attack

    -- synchronised controller vectors
    signal inputsp1 : std_logic_vector(7 downto 0); -- inputs from input, into physics and graphics and attack
    signal inputsp2 : std_logic_vector(7 downto 0); -- inputs from input, into physics and graphics and attack

    -- dummy signal that should be linked to the counter through an fsm or something like that
    signal readyphysicsin  : std_logic;
    signal readyphysicsout : std_logic;

    component input_toplevel is
        port (
            clk   : in std_logic;
            reset : in std_logic;
            vsync : in std_logic;

            controller_latch : out std_logic;
            controller_clk   : out std_logic;

            data_p1    : in std_logic;                     -- serial in
            buttons_p1 : out std_logic_vector(7 downto 0); -- parallel out

            data_p2    : in std_logic;                    -- serial in
            buttons_p2 : out std_logic_vector(7 downto 0) -- parallel out
        );
    end component input_toplevel;

    component topattack is
        port (
            clk                  : in std_logic;
            res                  : in std_logic;
            vsync                : in std_logic;
            controller1          : in std_logic_vector(7 downto 0);
            controller2          : in std_logic_vector(7 downto 0);
            x1in                 : in std_logic_vector(8 downto 0);
            y1in                 : in std_logic_vector(8 downto 0);
            x2in                 : in std_logic_vector(8 downto 0);
            y2in                 : in std_logic_vector(8 downto 0);
            percentage1in        : in std_logic_vector(7 downto 0);
            percentage2in        : in std_logic_vector(7 downto 0);
            killcount1in         : in std_logic_vector(3 downto 0);
            killcount2in         : in std_logic_vector(3 downto 0);
            directionx1out       : out std_logic_vector(8 downto 0);
            directiony1out       : out std_logic_vector(8 downto 0);
            directionx2out       : out std_logic_vector(8 downto 0);
            directiony2out       : out std_logic_vector(8 downto 0);
            damagepercentage1out : out std_logic_vector(7 downto 0);
            damagepercentage2out : out std_logic_vector(7 downto 0);
            percentage1out       : out std_logic_vector(7 downto 0);
            percentage2out       : out std_logic_vector(7 downto 0);
            killcount1out        : out std_logic_vector(3 downto 0);
            killcount2out        : out std_logic_vector(3 downto 0);
            orientation1         : out std_logic;
            orientation2         : out std_logic;
            restart1             : out std_logic;
            restart2             : out std_logic
        );
    end component;

    component physics_system is
        port (
            vin_x                : in std_logic_vector(9 downto 0);
            vin_y                : in std_logic_vector(9 downto 0);
            pin_x                : in std_logic_vector(8 downto 0);
            pin_y                : in std_logic_vector(8 downto 0);
            player_input         : in std_logic_vector(7 downto 0);
            knockback_percentage : in std_logic_vector(7 downto 0);
            knockback_x          : in std_logic_vector(8 downto 0);
            knockback_y          : in std_logic_vector(8 downto 0);
            vout_x               : out std_logic_vector(9 downto 0);
            vout_y               : out std_logic_vector(9 downto 0);
            pout_x               : out std_logic_vector(8 downto 0);
            pout_y               : out std_logic_vector(8 downto 0));
    end component physics_system;

    component graphics_card is
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
            controllerp1  : in std_logic_vector(7 downto 0);
            controllerp2  : in std_logic_vector(7 downto 0);
            orientationp1 : in std_logic;
            orientationp2 : in std_logic;
            -- outputs to screen (and other components)
            -- vcount : out std_logic_vector(9 downto 0);
            Vsync  : out std_logic;                     -- sync signals -> active low
            Hsync  : out std_logic;                     -- sync signals -> active low
            R_data : out std_logic_vector(3 downto 0);  -- RGB data to screen
            G_data : out std_logic_vector(3 downto 0);  -- RGB data to screen
            B_data : out std_logic_vector(3 downto 0)); -- RGB data to screen
    end component graphics_card;

    component memory is
        port (
            clk         : in std_logic;
            reset       : in std_logic;
            resetp1     : in std_logic;
            resetp2     : in std_logic;
            vsync       : in std_logic;
            data_in4b1  : in std_logic_vector(3 downto 0);
            data_in4b2  : in std_logic_vector(3 downto 0);
            data_out4b1 : out std_logic_vector(3 downto 0);
            data_out4b2 : out std_logic_vector(3 downto 0);
            data_inhp1  : in std_logic_vector(7 downto 0);
            data_inhp2  : in std_logic_vector(7 downto 0);
            data_outhp1 : out std_logic_vector(7 downto 0);
            data_outhp2 : out std_logic_vector(7 downto 0);
            data_in8b1  : in std_logic_vector(8 downto 0);
            data_in8b2  : in std_logic_vector(8 downto 0);
            data_in8b3  : in std_logic_vector(8 downto 0);
            data_in8b4  : in std_logic_vector(8 downto 0);
            data_out8b1 : out std_logic_vector(8 downto 0);
            data_out8b2 : out std_logic_vector(8 downto 0);
            data_out8b3 : out std_logic_vector(8 downto 0);
            data_out8b4 : out std_logic_vector(8 downto 0);
            data_in9b1  : in std_logic_vector(9 downto 0);
            data_in9b2  : in std_logic_vector(9 downto 0);
            data_in9b3  : in std_logic_vector(9 downto 0);
            data_in9b4  : in std_logic_vector(9 downto 0);
            data_out9b1 : out std_logic_vector(9 downto 0);
            data_out9b2 : out std_logic_vector(9 downto 0);
            data_out9b3 : out std_logic_vector(9 downto 0);
            data_out9b4 : out std_logic_vector(9 downto 0));
    end component memory;

    component t_8bregs is
        port (
            clk     : in std_logic;
            reset   : in std_logic;
            vec_in  : in std_logic_vector(8 downto 0);
            vec_out : out std_logic_vector(8 downto 0)
        );
    end component;
begin

    TL00 : memory port map(
        clk     => clk,
        reset   => reset,
        vsync   => vsyncintern,
        resetp1 => char1death,
        resetp2 => char2death,
        -- death count and percentage
        data_in4b1  => char1dcin,
        data_in4b2  => char2dcin,
        data_out4b1 => char1dc,
        data_out4b2 => char2dc,
        data_inhp1  => char1percin,
        data_inhp2  => char2percin,
        data_outhp1 => char1perc,
        data_outhp2 => char2perc,
        --location
        data_in8b1  => char1posxin,
        data_in8b2  => char1posyin,
        data_in8b3  => char2posxin,
        data_in8b4  => char2posyin,
        data_out8b1 => char1posx,
        data_out8b2 => char1posy,
        data_out8b3 => char2posx,
        data_out8b4 => char2posy,
        --velocity
        data_in9b1  => char1velxin,
        data_in9b2  => char1velyin,
        data_in9b3  => char2velxin,
        data_in9b4  => char2velyin,
        data_out9b1 => char1velx,
        data_out9b2 => char1vely,
        data_out9b3 => char2velx,
        data_out9b4 => char2vely

    );
    TL01 : graphics_card port map(
        clk           => clk,
        reset         => reset,
        char1_x       => char1posx,
        char1_y       => char1posy,
        char2_x       => char2posx,
        char2_y       => char2posy,
        percentage_p1 => char1perc,
        percentage_p2 => char2perc,
        controllerp1  => inputsp1,
        controllerp2  => inputsp2,
        orientationp1 => orientationp1,
        orientationp2 => orientationp2,
        Vsync         => vsyncintern,
        Hsync         => Hsync,
        R_data        => R_data,
        G_data        => G_data,
        B_data        => B_data
    );
    TL02 : physics_system port map(
        vin_x                => char1velx,
        vin_y                => char1vely,
        pin_x                => char1posx,
        pin_y                => char1posy,
        player_input         => inputsp1,
        knockback_percentage => char1perctemp,
        knockback_x          => dirx1new2,
        knockback_y          => diry1new2,
        vout_x               => char1velxin,
        vout_y               => char1velyin,
        pout_x               => char1posxin,
        pout_y               => char1posyin
    );
    TL03 : physics_system port map(
        vin_x                => char2velx,
        vin_y                => char2vely,
        pin_x                => char2posx,
        pin_y                => char2posy,
        player_input         => inputsp2,
        knockback_percentage => char2perctemp,
        knockback_x          => dirx2new2,
        knockback_y          => diry2new2,
        vout_x               => char2velxin,
        vout_y               => char2velyin,
        pout_x               => char2posxin,
        pout_y               => char2posyin
    );
    ATT1 : topattack port map(
        -- timing signals
        clk   => clk,
        res   => reset,
        vsync => vsyncintern,
        -- data input
        controller1   => inputsp1,
        controller2   => inputsp2,
        x1in          => char1posx,
        y1in          => char1posy,
        x2in          => char2posx,
        y2in          => char2posy,
        percentage1in => char1perc,
        percentage2in => char2perc,
        killcount1in  => char1dc,
        killcount2in  => char2dc,
        -- data output
        -- data for physics
        directionx1out       => dirx1new1,     -- knockback direction for physics calculation
        directiony1out       => diry1new1,     -- knockback direction for physics calculation
        directionx2out       => dirx2new1,     -- knockback direction for physics calculation
        directiony2out       => diry2new1,     -- knockback direction for physics calculation
        damagepercentage1out => char1perctemp, -- percentage data for physics calculation
        damagepercentage2out => char2perctemp, -- percentage data for physics calculation
        -- data for storage
        percentage1out => char1percin, -- percentage data input to memory for storage
        percentage2out => char2percin, -- percentage data input to memory for storage
        orientation1   => orientationp1,
        orientation2   => orientationp2,
        killcount1out  => char1dcin,
        killcount2out  => char2dcin,
        restart1       => char1death,
        restart2       => char2death
    );
    --------------------------------------------------------------------------------
    -- these buffers are here as this was easier to write at the time.
    -- the sole purpose of these buffers is to make sure the knockback works
    -- these make sure the knockback direction is set steady forever, without
    -- these buffers the whole attack system breaks.
    --------------------------------------------------------------------------------
    buf3 : t_8bregs port map(
        clk     => clk,
        reset   => reset,
        vec_in  => dirx1new1,
        vec_out => dirx1new2
    );
    buf4 : t_8bregs port map(
        clk     => clk,
        reset   => reset,
        vec_in  => diry1new1,
        vec_out => diry1new2
    );
    buf5 : t_8bregs port map(
        clk     => clk,
        reset   => vsyncintern,
        vec_in  => dirx2new1,
        vec_out => dirx2new2
    );
    buf6 : t_8bregs port map(
        clk     => clk,
        reset   => vsyncintern,
        vec_in  => diry2new1,
        vec_out => diry2new2
    );
    --------------------------------------------------------------------------------
    TL04 : input_toplevel port map(
        clk              => clk,
        reset            => reset,
        vsync            => vsyncintern,
        controller_latch => controller_latch,
        controller_clk   => controller_clk,
        data_p1          => p1_controller,
        buttons_p1       => inputsp1,
        data_p2          => p2_controller,
        buttons_p2       => inputsp2
    );

    Vsync <= vsyncintern; -- this is the only way I know to have an output signal also work as an internal one
end architecture structural;