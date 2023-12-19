library IEEE;
use IEEE.std_logic_1164.all;

entity input_jump is
  port (
    clk       : in    std_logic;
    reset     : in    std_logic;

    vsync     : in    std_logic;
    jump_in   : in    std_logic;
    jump_out  : out   std_logic
  );
end entity;

architecture behavioural of input_jump is
  type jump_state is (no_jump, yes_jump, still_pressed);
  signal state, new_state : jump_state;

  signal jump : std_logic;
begin
  jump_out <= jump;

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (reset = '1') then
        state <= no_jump;
      else
        state <= new_state;
      end if;
    end if;
  end process;

  process (state, jump_in, vsync)
  begin
    case state is
      when no_jump =>
        jump <= '0';

        if (jump_in = '1') then
          new_state <= yes_jump;
        else
          new_state <= no_jump;
        end if;

      when yes_jump =>
        jump <= '1';

        if (vsync = '0') then
          new_state <= still_pressed;
        else
          new_state <= yes_jump;
        end if;

      when still_pressed =>
        jump <= '0';

        if (jump_in = '0') then
          new_state <= no_jump;
        else
          new_state <= still_pressed;
        end if;
    end case;
  end process;
end architecture behavioural;
