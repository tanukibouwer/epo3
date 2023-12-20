--module: animation_counter
--version: 1
--author: Parama Fawwaz 
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--MODULE DESCRIPTION
--! The fsm that controls the animation of character movement
--! 
--! 
--! 
--! 
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------






library IEEE;
use IEEE.std_logic_1164.ALL;

entity char_animation_fsm is
    port(vsync  :in    std_logic;
         reset  :in    std_logic;
         clk   : in std_logic;

         controller_in : in std_logic_vector(7 downto 0); -- bit 0 = left, bit 1 = right, bit 2 = up, bit 3 = down
         orientation   : in std_logic; --1 is right, 0 is left
         sprite   :out   std_logic);
 end char_animation_fsm;
 

architecture behaviour of char_animation_fsm is
   type sprite_state is (Idle1, Idle2, Run1, Run2, Jump_Crouch);
   signal state, new_state: sprite_state;
begin
   lbl1:
   process (vsync) -- 1 vsync is roughly 0.16 seconds, so if the animation framerate, or "sprite rate" is to fast, the addition of more run and Idle states are possible
   begin
      if (vsync'event and vsync = '1') then
         if (res = '1') then
            state <= Idle1;
         else
            state <= new_state;
         end if;
      end if;
   end process;
   lbl2:
   process(state, vsync, controller_in, orientation)
   begin
      case state is
         when Idle1 =>
            if(orientation = '1') then
               sprite <= "001";
            else
               sprite <= "010";
            end if;

            if (controller_in(0 downto 0) = '1' or controller_in(1 downto 1) = '1') and (controller_in(2 downto 2) = '0' and controller_in(3 downto 3) = '0') then
               new_state <= Run1;
            elsif(controller_in(0 downto 0) = '0' or controller_in(1 downto 1) = '0') and (controller_in(2 downto 2) = '0' and controller_in(3 downto 3) = '0') then
               new_state <= Idle1;  --redundant elsif statement but easier for me to process
            elsif(controller_in(2 downto 2) = '1' or controller_in(3 downto 3) = '1') then
               new_state <= Jump_Crouch;
            else
               new_state <= Idle1; --example: if left AND right is pressed 
            end if;
         when Run1 =>
            if(orientation = '1') then
               sprite <= "010";
            else
               sprite <= "101";
            end if;

            if (controller_in(0 downto 0) = '1' or controller_in(1 downto 1) = '1') and (controller_in(2 downto 2) = '0' and controller_in(3 downto 3) = '0') then
               new_state <= Run2;
            elsif(controller_in(0 downto 0) = '0' or controller_in(1 downto 1) = '0') and (controller_in(2 downto 2) = '0' and controller_in(3 downto 3) = '0') then
               new_state <= Idle1; 
            elsif(controller_in(2 downto 2) = '1' or controller_in(3 downto 3) = '1') then
               new_state <= Jump_Crouch;
            else
               new_state <= Run1; --example: if left AND right is pressed 
            end if;

         when Run2 =>
            if(orientation = '1') then
               sprite <= "010";
            else
               sprite <= "101";
            end if;

            if (controller_in(0 downto 0) = '0' or controller_in(1 downto 1) = '0') and (controller_in(2 downto 2) = '0' and controller_in(3 downto 3) = '0') then
               new_state <= Idle2;
            elsif(controller_in(2 downto 2) = '1' or controller_in(3 downto 3) = '1') then
               new_state <= Jump_Crouch;
            else
               new_state <= Idle2; --example: if left AND right is pressed 
            end if;

         when Idle2 =>
            if(orientation = '1') then
               sprite <= "001";
            else
               sprite <= "010";
            end if;

            if (controller_in(0 downto 0) = '0' or controller_in(1 downto 1) = '0') and (controller_in(2 downto 2) = '0' and controller_in(3 downto 3) = '0') then
               new_state <= Idle1;
            elsif(controller_in(2 downto 2) = '1' or controller_in(3 downto 3) = '1') then
               new_state <= Jump_Crouch;
            else
               new_state <= Idle1; --example: if left AND right is pressed 
            end if; 

         when Jump_Crouch =>
            if(orientation = '1') then
               sprite <= "000";
            else
               sprite <= "110";
            end if;

            if (controller_in(2 downto 2) = '0' and controller_in(3 downto 3) = '0') then
               new_state <= Idle1;
            else
               new_state <= Jump_Crouch; 
            end if;         
                   

      end case;
   end process;
end behaviour;
