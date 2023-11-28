library IEEE;
use IEEE.std_logic_1164.ALL;

entity physics_fsm is
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
end physics_fsm;

architecture behaviour of physics_fsm is
   component velocity_interpolator is
      port(vin_x : in std_logic_vector(8 downto 0);
        vout_x : out std_logic_vector(8 downto 0);
        movement_target : in std_logic_vector(5 downto 0));
   end component;
   
   component h_player_movement is
      port(left_right_pressed : in std_logic_vector(1 downto 0); -- left_pressed & right_pressed
           out_h_target : out std_logic_vector(5 downto 0));
   end component;

   type state_type is (IDLE, H_MOVEMENT, V_INTERPOLATE, V_ADDITION);
   signal state, new_state : state_type;
   signal v_x : std_logic_vector(8 downto 0);
   signal v_y : std_logic_vector(8 downto 0);
   signal p_x : std_logic_vector(7 downto 0);
   signal p_y : std_logic_vector(7 downto 0);

-- signal h_movement_left_right_pressed : std_logic_vector(1 downto 0);
-- signal h_movement_out_h_target : std_logic_vector(5 downto 0);

   signal interpolator_vout_x : std_logic_vector(8 downto 0);
   signal movement_target : std_logic_vector(5 downto 0);

begin
   h_movement_calculator : h_player_movement port map (left_right_pressed => player_input(7 downto 6), out_h_target => movement_target);
   interpolator : velocity_interpolator port map (vin_x => vin_x, vout_x => interpolator_vout_x, movement_target => movement_target);

   statereg : process (clk)
   begin
      if (clk'event and clk = '1') then
         if reset = '1' then
            state <= IDLE;
         else
            state <= new_state;
         end if;
      end if;
   end process;
   
   combinatorial : process (state, ready_in, vin_x, vin_y, pin_x, pin_y)
   begin
      case state is
         when IDLE =>
         ready_out <= '1';
         if ready_in = '1' then
            new_state <= H_MOVEMENT;
         else
            new_state <= IDLE;
         end if;
         v_x <= vin_x;
         v_y <= vin_y;
         p_x <= pin_x;
         p_y <= pin_y;
      when H_MOVEMENT =>
         new_state <= V_INTERPOLATE;
         ready_out <= '0';
         v_x <= vin_x;
         v_y <= vin_y;
         p_x <= pin_x;
         p_y <= pin_y;
      when V_INTERPOLATE => 
         new_state <= V_ADDITION;
         ready_out <= '0';
         v_x <= interpolator_vout_x;
         v_y <= vin_y;
         p_x <= pin_x;
         p_y <= pin_y;
      when V_ADDITION =>
         new_state <= IDLE;
         ready_out <= '0';
         v_x <= v_x;
         v_y <= vin_y;
         p_x <= pin_x;
         p_y <= pin_y;
      end case;
   end process;
   
   vout_x <= v_x;
   vout_y <= v_y;
   pout_x <= p_x;
   pout_y <= p_y;
end behaviour;

configuration physics_fsm_behaviour_cfg of physics_fsm is
   for behaviour
      for all: h_player_movement use configuration work.h_player_movement_cfg;
      end for;
      for all: velocity_interpolator use configuration work.velocity_interpolator_cfg;
      end for;
   end for;
end physics_fsm_behaviour_cfg;
