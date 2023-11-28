library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity input_driver is
  port (
    clk       : in    std_logic;
    reset     : in    std_logic;

    period_count  : in std_logic_vector(8 downto 0);
    period_count_reset  : out   std_logic;

    controller_latch    : out   std_logic;
    controller_clk      : out   std_logic;
    deserializer_reset  : out   std_logic;
    deserializer_clk    : out   std_logic;

    buffer_read         : out   std_logic
  );
end entity input_driver;

architecture behavioural of input_driver is
  type driver_state is (reset_state, latch_high, latch_low, clk_high, clk_low, pause);
  signal state, new_state : driver_state;

  signal per_count : unsigned (8 downto 0);
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
        period_count_reset <= '1';
        pulse_new_count <= pulse_count;

        controller_latch <= '0';
        controller_clk <= '0';
        deserializer_clk <= '1';
        deserializer_reset <= '1';

        buffer_read <= '0';

        new_state <= latch_high;

      when latch_high =>
        period_count_reset <= '0';
        pulse_new_count <= pulse_count;

        controller_latch <= '1';
        controller_clk <= '0';
        deserializer_clk <= '0';
        deserializer_reset <= '0';

        buffer_read <= '0';

        if (per_count = to_unsigned(300, 9)) then
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

        buffer_read <= '0';

        if (per_count = to_unsigned(300, 9)) then
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

        buffer_read <= '0';

        if (per_count = to_unsigned(300, 9)) then
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
        buffer_read <= '0';


        if (per_count = to_unsigned(300, 9)) then
          period_count_reset <= '1';
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

        buffer_read <= '1';

        if (per_count = to_unsigned(300, 9)) then
          period_count_reset <= '1';
          new_state <= latch_high;
        else
          new_state <= pause;
        end if;

    end case;
  end process;
end architecture behavioural;





