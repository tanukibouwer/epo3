library IEEE;
use IEEE.std_logic_1164.all;

entity input_toplevel is
  port (
    clk   : in std_logic;
    reset : in std_logic;

    controller_latch    : out   std_logic;
    controller_clk      : out   std_logic;

    p1_controller : in    std_logic;                    -- player 1 controller serial data in
    p1_input      : out   std_logic_vector(7 downto 0); -- player 1 parallel out
    p2_controller : in    std_logic;                    -- player 2 controller serial data in
    p2_input      : out   std_logic_vector(7 downto 0)  -- player 2 parallel out
 );
end entity input_toplevel;

architecture structural of input_toplevel is

  component input_driver is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      period_count  : in std_logic_vector(8 downto 0);
      period_count_reset  : out   std_logic;

      controller_latch    : out   std_logic;
      controller_clk      : out   std_logic;
      deserializer_clk    : out   std_logic;
      deserializer_reset  : out   std_logic;

      buffer_read         : out   std_logic
    );
  end component input_driver;

  component input_period_counter is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      count_out     : out   std_logic_vector(8 downto 0)
    );
  end component input_period_counter;

  component deserializer is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      controller_p1     : in    std_logic;
      input_p1          : out   std_logic_vector(7 downto 0);

      controller_p2     : in    std_logic;
      input_p2          : out   std_logic_vector(7 downto 0)
    );
  end component deserializer;

  component input_buffer is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      read      : in    std_logic;
      input_in_p1    : in    std_logic_vector(7 downto 0);
      input_out_p1   : out   std_logic_vector(7 downto 0);
      input_in_p2    : in    std_logic_vector(7 downto 0);
      input_out_p2   : out   std_logic_vector(7 downto 0)
    );
  end component input_buffer;

  signal count  : std_logic_vector(8 downto 0);
  signal count_reset  : std_logic;

  signal deserializer_reset   : std_logic;
  signal deserializer_clk     : std_logic;
  signal deserializer_out_p1  : std_logic_vector(7 downto 0);
  signal deserializer_out_p2  : std_logic_vector(7 downto 0);

  signal buffer_read  : std_logic;

begin
  drvr: input_driver port map (
    clk => clk,
    reset => reset,

    period_count => count,
    period_count_reset => count_reset,

    controller_latch => controller_latch,
    controller_clk => controller_clk,
    deserializer_clk => deserializer_clk,
    deserializer_reset => deserializer_reset,

    buffer_read => buffer_read
  );

  cntr: input_period_counter port map (
    clk => clk,
    reset => count_reset,
    count_out => count
  );

  desrlzr: deserializer port map (
    clk => deserializer_clk,
    reset => deserializer_reset,

    controller_p1 => p1_controller,
    controller_p2 => p2_controller,

    input_p1 => deserializer_out_p1,
    input_p2 => deserializer_out_p2
  );

  bffr: input_buffer port map (
    clk => clk,
    reset => reset,
    read => buffer_read,

    input_in_p1 => deserializer_out_p1,
    input_out_p1 => p1_input,

    input_in_p2 => deserializer_out_p2,
    input_out_p2 => p2_input
  );

end architecture;
