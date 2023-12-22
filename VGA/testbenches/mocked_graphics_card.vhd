--module: graphics_card
--version: 1.1.3
--author: Kevin Vermaat
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
--! This module is the RTL description of the full VGA graphics card of the EPO3 chip - Super Smash Bros. 
--! 
--! This component consists of 3 subcomponents, screen_scan, mem_vid and coloring 
--! 
--! screen_scan to scan the screen, mem_vid as a frame buffer, coloring as logic to find the color at a pixel 
--! 
--! offset adder to coordinates from frame buffer to pixel bounds.
--!
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity graphics_card is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        sw0 : in std_logic;
        sw1 : in std_logic;
        sw2 : in std_logic;
        sw3 : in std_logic;
        -- inputs from memory -> relevant data to be displayed on screen
        -- char1_x : in std_logic_vector(7 downto 0); --! character 1 x-location
        -- char1_y : in std_logic_vector(7 downto 0); --! character 1 y-location
        -- char2_x : in std_logic_vector(7 downto 0); --! character 2 x-location
        -- char2_y : in std_logic_vector(7 downto 0); --! character 2 y-location
        -- outputs to screen (and other components)
        -- vcount : out std_logic_vector(9 downto 0);
        Vsync  : out std_logic; --! sync signals -> active low
        Hsync  : out std_logic; --! sync signals -> active low
        R_data : out std_logic_vector(3 downto 0); --! RGB data to screen
        G_data : out std_logic_vector(3 downto 0); --! RGB data to screen
        B_data : out std_logic_vector(3 downto 0) --! RGB data to screen
    );
end entity graphics_card;

architecture structural of graphics_card is

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
            percentage_p1 : in std_logic_vector(7 downto 0);
            percentage_p2 : in std_logic_vector(7 downto 0);
    
            --orientation from attackmodule
            orientation_p1      : in std_logic; 
            orientation_p2    : in std_logic;
    
            --controls from input
            controller_p1 : in std_logic_vector(7 downto 0); -- bit 0 = left, bit 1 = right, bit 2 = up, bit 3 = down
            controller_p2 : in std_logic_vector(7 downto 0); -- bit 0 = left, bit 1 = right, bit 2 = up, bit 3 = down
            
            --vsync from screen scan
            vsync      : in std_logic;
    
            -- RGB data outputs
            R_data : out std_logic_vector(3 downto 0); --! RGB data output
            G_data : out std_logic_vector(3 downto 0); --! RGB data output
            B_data : out std_logic_vector(3 downto 0)  --! RGB data output
    
        );
    end component;
    
    signal vcount_int, hcount_int             : std_logic_vector (9 downto 0);
    signal char1_x, char1_y, char2_x, char2_y : std_logic_vector(7 downto 0);
    signal percentagep1 : std_logic_vector(7 downto 0);
    signal percentagep2 : std_logic_vector(7 downto 0);
    signal sw_vec : std_logic_vector(3 downto 0);
    signal orientationp1 : std_logic;
    signal orientationp2 : std_logic;
    signal vsync_between : std_logic;
    signal controllerp1 : std_logic_vector(7 downto 0);
    signal controllerp2 : std_logic_vector(7 downto 0);

begin

    --keep count of what pixel the screen should be on and send the synchronisation signals
    SCNR1 : screen_scan port map(
        clk => clk, reset => reset, Hsync => Hsync, Vsync => Vsync, vcount_out => vcount_int, hcount_out => hcount_int
    );
    -- component coloring_new is
    --     port (
    --         --! global inputs
    --         clk   : in std_logic;
    --         reset : in std_logic;
    --         --! counter data
    --         hcount : in std_logic_vector(9 downto 0);
    --         vcount : in std_logic_vector(9 downto 0);
    --         -- relevant data for x-y locations
    --         char1x : in std_logic_vector(7 downto 0); --! character 1 coordinates
    --         char1y : in std_logic_vector(7 downto 0); --! character 1 coordinates
    --         char2x : in std_logic_vector(7 downto 0); --! character 2 coordinates
    --         char2y : in std_logic_vector(7 downto 0); --! character 2 coordinates
    
    --         -- percentage from attack module
    --         percentage_p1 : in std_logic_vector(7 downto 0);
    --         percentage_p2 : in std_logic_vector(7 downto 0);
    
    --         --orientation from attackmodule
    --         orientation_p1      : in std_logic; 
    --         orientation_p2    : in std_logic;
    
    --         --controls from input
    --         controller_p1 : in std_logic_vector(7 downto 0); -- bit 0 = left, bit 1 = right, bit 2 = up, bit 3 = down
    --         controller_p2 : in std_logic_vector(7 downto 0); -- bit 0 = left, bit 1 = right, bit 2 = up, bit 3 = down
            
    --         --vsync from screen scan
    --         vsync      : in std_logic;
    
    --         -- RGB data outputs
    --         R_data : out std_logic_vector(3 downto 0); --! RGB data output
    --         G_data : out std_logic_vector(3 downto 0); --! RGB data output
    --         B_data : out std_logic_vector(3 downto 0)  --! RGB data output
    
    --     );
    -- end component;

    --gib color to pixel
    CLR1 : coloring_new port map(
        clk => clk, reset => reset,
        hcount => hcount_int, vcount => vcount_int,
        char1x => char1_x, char1y => char1_y, char2x => char2_x, char2y => char2_y,
        percentage_p1 => percentagep1,
        percentage_p2 => percentagep2,
        orientation_p1 => orientationp1,
        orientation_p2 => orientationp2,
        controller_p1 => controllerp1,
        controller_p2 => controllerp2,
        vsync => vsync_between,

        R_data => R_data, G_data => G_data, B_data => B_data
    );

    char1_x <= std_logic_vector(to_unsigned(50, char1_x'length));
    char1_y <= std_logic_vector(to_unsigned(70, char1_x'length));
    char2_x <= std_logic_vector(to_unsigned(150, char1_x'length));
    char2_y <= std_logic_vector(to_unsigned(70, char1_x'length));
    sw_vec(0) <= sw0; --> controlling player 1 only & rightside orientation for now
    sw_vec(1) <= sw1; 
    sw_vec(2) <= sw2; 
    sw_vec(3) <= sw3; 
    percentagep1 <= "00000000";
    percentagep2 <= "00000000";
    orientationp1 <= '0';
    orientationp2 <= '0';

    process (sw_vec)
    begin
        case sw_vec is
            when "0001" => 
                controllerp1 <= "00000001";
                controllerp2 <= "00000000";
            when "0010" =>
                controllerp1 <= "00000010";
                controllerp2 <= "00000000";
            when "0011" =>
                controllerp1 <= "00000011";
                controllerp2 <= "00000000";
            when "0100" =>
                controllerp1 <= "00000100";
                controllerp2 <= "00000000";
            when "0101" =>
                controllerp1 <= "00000101";
                controllerp2 <= "00000000";
            when "0110" =>
                controllerp1 <= "00000110";
                controllerp2 <= "00000000";
            when "0111" =>
                controllerp1 <= "00000111";
                controllerp2 <= "00000000";
            when "1000" =>
                controllerp1 <= "00001000";
                controllerp2 <= "00000000";
            when "1001" =>
                controllerp1 <= "00001001";
                controllerp2 <= "00000000";
            when "1010" =>
                controllerp1 <= "00001010";
                controllerp2 <= "00000000";
            when "1011" =>
                controllerp1 <= "00001011";
                controllerp2 <= "00000000";
            when "1100" =>
                controllerp1 <= "00001100";
                controllerp2 <= "00000000";
            when "1101" =>
                controllerp1 <= "00001101";
                controllerp2 <= "00000000";
            when "1110" =>
                controllerp1 <= "00001110";
                controllerp2 <= "00000000";
            when "1111" =>
                controllerp1 <= "00001111";
                controllerp2 <= "00000000";
            when others =>
                controllerp1 <= "00000000";
                controllerp2 <= "00000000";
        end case;
        
    end process;

    -- process (sw_vec)
    -- begin
    --     case sw_vec is
    --         when "0001" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(1, percentagep2'length));
    --         when "0010" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16*2, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(2, percentagep2'length));
    --         when "0011" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16*3, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(3, percentagep2'length));
    --         when "0100" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16*4, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(4, percentagep2'length));
    --         when "0101" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16*5, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(5, percentagep2'length));
    --         when "0110" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16*6, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(6, percentagep2'length));
    --         when "0111" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16*7, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(7, percentagep2'length));
    --         when "1000" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16*8, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(8, percentagep2'length));
    --         when "1001" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16*9, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(9, percentagep2'length));
    --         when "1010" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16*10, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(10, percentagep2'length));
    --         when "1011" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16*11, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(123, percentagep2'length));
    --         when "1100" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16*12, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(321, percentagep2'length));
    --         when "1101" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16*13, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(511, percentagep2'length));
    --         when "1110" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16*14, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(369, percentagep2'length));
    --         when "1111" =>
    --             percentagep1 <= std_logic_vector(to_unsigned(16*15, percentagep1'length));
    --             percentagep2 <= std_logic_vector(to_unsigned(300, percentagep2'length));
    --         when others =>
    --             percentagep1 <= (others => '0');
    --             percentagep2 <= (others => '0');
    --     end case;
        
    -- end process;

    
end architecture;