library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity input_driver is
  port (
    clk       : in    std_logic;
    reset     : in    std_logic;

    period_count  : in std_logic_vector(3 downto 0);
    period_count_reset  : out   std_logic;

    controller_latch    : out   std_logic;
    controller_clk      : out   std_logic;
    deserializer_reset  : out   std_logic;
    deserializer_clk    : out   std_logic;

    reg_write         : out   std_logic
  );
end entity input_driver;

architecture behavioural of input_driver is
  type driver_state is (reset_state, latch_high, latch_low, clk_high, clk_low, pause);
  signal state, new_state : driver_state;

  signal per_count : unsigned (3 downto 0);

  -- counts the amount of controller clock pulses
  signal pulse_count, pulse_new_count : unsigned (2 downto 0);

begin
  per_count <= unsigned(period_count);

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (reset = '1') then
        pulse_count <= (others => '0');
        state <= reset_state;
      else
        pulse_count <= pulse_new_count;
        state <= new_state;
      end if;
    end if;
  end process;

  process (state, per_count, pulse_count)
  begin
    case state is
      when reset_state =>
        -- reset count
        period_count_reset <= '1';
        pulse_new_count <= pulse_count;

        controller_latch <= '0';
        controller_clk <= '0';

        -- reset the deserializer
        deserializer_clk <= '1';
        deserializer_reset <= '1';

        reg_write <= '0';

        new_state <= latch_high;

      when latch_high =>
        period_count_reset <= '0';
        pulse_new_count <= pulse_count;

        controller_latch <= '1';
        controller_clk <= '0';
        deserializer_clk <= '0';
        deserializer_reset <= '0';

        reg_write <= '0';

        if (per_count = to_unsigned(15, 4)) then
          period_count_reset <= '1';
          new_state <= latch_low;
        else
          new_state <= latch_high;
        end if;

      when latch_low =>
        period_count_reset <= '0';
        pulse_new_count <= pulse_count;

        controller_latch <= '0';
        controller_clk <= '0';
        deserializer_clk <= '1';
        deserializer_reset <= '0';

        reg_write <= '0';

        if (per_count = to_unsigned(15, 4)) then
          period_count_reset <= '1';
          new_state <= clk_high;
        else
          new_state <= latch_low;
        end if;

      when clk_high =>
        period_count_reset <= '0';
        pulse_new_count <= pulse_count;

        controller_latch <= '0';
        controller_clk <= '1';
        deserializer_clk <= '0';
        deserializer_reset <= '0';

        reg_write <= '0';

        if (per_count = to_unsigned(15, 4)) then
          period_count_reset <= '1';
          pulse_new_count <= pulse_count + 1;
          new_state <= clk_low;
        else
          new_state <= clk_high;
        end if;

      when clk_low =>
        period_count_reset <= '0';
        pulse_new_count <= pulse_count;

        controller_latch <= '0';
        controller_clk <= '0';
        deserializer_clk <= '1';
        deserializer_reset <= '0';
        reg_write <= '0';


        if (per_count = to_unsigned(15, 4)) then
          period_count_reset <= '1';
          -- if seven clock pulses have been given it should go to pause
          if (pulse_count >= to_unsigned(7, 3)) then
            pulse_new_count <= (others => '0');
            new_state <= pause;
          else
            new_state <= clk_high;
          end if;
        else
          new_state <= clk_low;
        end if;

      when pause =>
        period_count_reset <= '0';
        pulse_new_count <= pulse_count;

        controller_latch <= '0';
        controller_clk <= '0';
        deserializer_clk <= '0';
        deserializer_reset <= '0';

        -- write the new button values to the output register
        reg_write <= '1';

        if (per_count = to_unsigned(15, 4)) then
          -- loop back to latch_high
          period_count_reset <= '1';
          new_state <= latch_high;
        else
          new_state <= pause;
        end if;

    end case;
  end process;
end architecture behavioural;
