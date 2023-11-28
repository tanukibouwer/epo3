library IEEE;
use IEEE.std_logic_1164.ALL;

entity physics_fsm_tb is
end physics_fsm_tb;


library IEEE;
use IEEE.std_logic_1164.ALL;

architecture behaviour of physics_fsm_tb is
   component physics_fsm
      port(clk : in std_logic;
           reset : in std_logic;
           ready_in : in std_logic;
           vin_x : in std_logic_vector(8 downto 0);
           vin_y : in std_logic_vector(8 downto 0);
           pin_x : in std_logic_vector(7 downto 0);
           pin_y : in std_logic_vector(7 downto 0);
           player_input : in std_logic_Vector(7 downto 0);
           vout_x : out std_logic_vector(8 downto 0);
           vout_y : out std_logic_vector(8 downto 0);
           pout_x : out std_logic_vector(7 downto 0);
           pout_y : out std_logic_vector(7 downto 0);
           ready_out : out std_logic);
   end component;
   signal clk : std_logic;
   signal reset : std_logic;
   signal ready_in : std_logic;
   signal vin_x : std_logic_vector(8 downto 0);
   signal vin_y : std_logic_vector(8 downto 0);
   signal pin_x : std_logic_vector(7 downto 0);
   signal pin_y : std_logic_vector(7 downto 0);
   signal player_input : std_logic_Vector(7 downto 0);
   signal vout_x : std_logic_vector(8 downto 0);
   signal vout_y : std_logic_vector(8 downto 0);
   signal pout_x : std_logic_vector(7 downto 0);
   signal pout_y : std_logic_vector(7 downto 0);
   signal ready_out : std_logic;
begin
   test: physics_fsm port map (clk, reset, ready_in, vin_x, vin_y, pin_x, pin_y, player_input, vout_x, vout_y, pout_x, pout_y, ready_out);
   clk <= '0' after 0 ns,
          '1' after 20 ns when clk /= '1' else '0' after 20 ns;
   reset <= '1' after 0 ns,
            '0' after 40 ns;
   ready_in <= '1' after 0 ns;
   player_input <= "00000000" after 0 ns,
                   "10000000" after 180 ns,
                   "01000000" after 240 ns,
                   "11000000" after 300 ns;
   vin_x <= "000000000" after 0 ns,
            "010101011" after 180 ns,
            "111101110" after 240 ns,
            "000000001" after 300 ns,
            "111111111" after 360 ns;
   vin_y <= (others => '0');
   pin_x <= (others => '0');
   pin_y <= (others => '0');
end behaviour;

configuration physics_fsm_tb_behaviour_cfg of physics_fsm_tb is
   for behaviour
      for all: physics_fsm use configuration work.physics_fsm_behaviour_cfg;
      end for;
   end for;
end physics_fsm_tb_behaviour_cfg;
