library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity input_driver is
  port (
    clk       : in    std_logic;
    reset     : in    std_logic;

    controller_latch    : out   std_logic;
    controller_clk      : out   std_logic;

    p1_controller : in    std_logic;                    -- player 1 controller serial data in
    p1_input      : out   std_logic_vector(7 downto 0)  -- player 1 parallel out
  );
end entity input_driver;

architecture behavioural of input_driver is
  type driver_state is (reset_state, latch_high, latch_low, clk_high, clk_low);
  signal state, new_state : driver_state;

  signal period_count, period_new_count : unsigned (8 downto 0);
  signal pulse_count, pulse_new_count : unsigned (2 downto 0);


begin
  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (reset = '1') then
        period_count <= (others => '0');
        pulse_count <= (others => '0');
        state <= reset_state;
      else
        period_count <= period_new_count;
        pulse_count <= pulse_new_count;
        state <= new_state;
      end if;
    end if;
  end process;

  process (state, p1_controller, period_count, pulse_count)
  begin
    case state is
      when reset_state =>
        period_new_count <= period_count;
        pulse_new_count <= pulse_count;

        controller_latch <= '0';
        controller_clk <= '0';
        p1_input <= "00000000";

        new_state <= latch_high;

      when latch_high =>
        period_new_count <= period_count + 1;
        pulse_new_count <= pulse_count;

        controller_latch <= '1';
        controller_clk <= '0';

        if (period_count = to_unsigned(300, 9)) then
          period_new_count <= (others => '0');
          new_state <= latch_low;
        end if;

      when latch_low =>
        period_new_count <= period_count + 1;
        pulse_new_count <= pulse_count;

        controller_latch <= '0';
        controller_clk <= '0';

        p1_input(to_integer(pulse_count)) <= p1_controller;

        if (period_count >= to_unsigned(300, 9)) then
          period_new_count <= (others => '0');
          new_state <= clk_high;
        end if;

      when clk_high =>
        period_new_count <= period_count + 1;
        pulse_new_count <= pulse_count;

        controller_latch <= '0';
        controller_clk <= '1';

        if (period_count >= to_unsigned(300, 9)) then
          period_new_count <= (others => '0');
          pulse_new_count <= pulse_count + 1;
          new_state <= clk_low;
        end if;
      when clk_low =>
        period_new_count <= period_count + 1;
        pulse_new_count <= pulse_count;

        controller_latch <= '0';
        controller_clk <= '0';

        p1_input(to_integer(pulse_count)) <= not p1_controller;

        if (period_count >= to_unsigned(300, 9)) then
          period_new_count <= (others => '0');
          if (pulse_count >= to_unsigned(7, 3)) then
            pulse_new_count <= (others => '0');
            new_state <= latch_high;
          else
            new_state <= clk_high;
          end if;
        end if;
    end case;
  end process;
end architecture behavioural;





