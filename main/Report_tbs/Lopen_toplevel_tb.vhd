library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Lopen_toplevel_tb is
end Lopen_toplevel_tb;

architecture behaviour of Lopen_toplevel_tb is

    component Lopen_toplevel
        port (

        clk   : in std_logic;
        reset : in std_logic;

        -- controller data inputs
        p1_controller : in std_logic;
        p2_controller : in std_logic;

        p1posx_out  : out std_logic_vector(8 downto 0); 
        p1posy_out   : out std_logic_vector(8 downto 0);
        p2posx_out   : out std_logic_vector(8 downto 0); 
        p2posy_out  : out std_logic_vector(8 downto 0); 


        -- controller drive signals
        controller_latch : out std_logic;
        controller_clk   : out std_logic
    );
    end component;


    signal clk   : std_logic;
    signal reset : std_logic;
    signal p1_controller : std_logic;
    signal p2_controller : std_logic;

    signal p1posx_out  : std_logic_vector(8 downto 0); 
    signal p1posy_out   : std_logic_vector(8 downto 0);
    signal p2posx_out   : std_logic_vector(8 downto 0); 
    signal p2posy_out  : std_logic_vector(8 downto 0); 

    signal controller_latch : std_logic;
    signal controller_clk   : std_logic;
    begin
    test: Lopen_toplevel port map (clk, reset, p1_controller, p2_controller, p1posx_out, p1posy_out, p2posx_out, p2posy_out, controller_latch, controller_clk);
    clk <= '0' after 0 ns,
           '1' after 20 ns when clk /= '1' else '0' after 20 ns;
    reset <= '1' after 0 ns,
             '0' after 80 ns;
    p1_controller <= '1' after 0 ns, '0' after 9424 ns, '1' after 10311 ns, '0' after 20290 ns, '1' after 21066 ns, '0' after 31200 ns, '1' after 31666 ns, '0' after 42061 ns, '1' after 42615 ns, '0' after 52860 ns, '1' after 53483 ns;
    p2_controller <= '1' after 0 ns;


 end behaviour;

