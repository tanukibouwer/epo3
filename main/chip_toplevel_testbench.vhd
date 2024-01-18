library IEEE;
use IEEE.std_logic_1164.ALL;

entity chip_toplevel_tb is
end chip_toplevel_tb;

library IEEE;
use IEEE.std_logic_1164.ALL;

architecture behaviour of chip_toplevel_tb is
   component chip_toplevel
       port (
           clk   : in std_logic;
           reset : in std_logic;
   
           p1_controller : in std_logic;
           p2_controller : in std_logic;
   
           switches : in std_logic_vector(5 downto 0);
   
           Vsync  : out std_logic; -- sync signals -> active low
           Hsync  : out std_logic; -- sync signals -> active low
   
           gp_outputs : out std_logic_vector(11 downto 0);
   
           controller_latch : out std_logic;
           controller_clk   : out std_logic
       );
   end component;
   signal clk   : std_logic;
   signal reset : std_logic;
   signal p1_controller : std_logic;
   signal p2_controller : std_logic;
   signal switches : std_logic_vector(5 downto 0);
   signal Vsync  : std_logic;
   signal Hsync  : std_logic;
   signal gp_outputs : std_logic_vector(11 downto 0);
   signal controller_latch : std_logic;
   signal controller_clk   : std_logic;
begin
   test: chip_toplevel port map (clk, reset, p1_controller, p2_controller, switches, Vsync, Hsync, gp_outputs, controller_latch, controller_clk);
   clk <= '0' after 0 ns,
          '1' after 20 ns when clk /= '1' else '0' after 20 ns;
   reset <= '1' after 0 ns,
            '0' after 80 ns;
   p1_controller <= '0' after 0 ns;
   p2_controller <= '0' after 0 ns;
   switches(0) <= '0' after 0 ns;
   switches(1) <= '0' after 0 ns;
   switches(2) <= '0' after 0 ns;
   switches(3) <= '0' after 0 ns;
   switches(4) <= '0' after 0 ns;
   switches(5) <= '0' after 0 ns;
end behaviour;

