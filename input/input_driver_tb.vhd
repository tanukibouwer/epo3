library IEEE;
use IEEE.std_logic_1164.all;

entity input_driver_tb is
end entity input_driver_tb;

architecture behavioural of input_driver_tb is
  component input_driver is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      period_count  : in std_logic_vector(8 downto 0);
      period_count_reset  : out   std_logic;

      controller_latch    : out   std_logic;
      controller_clk      : out   std_logic;
      deserializer_reset  : out   std_logic;
      deserializer_clk    : out   std_logic;

      reg_write         : out   std_logic
    );
  end component input_driver;

  component input_period_counter is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      count_out     : out   std_logic_vector(8 downto 0)
    );
  end component input_period_counter;

  signal clk, reset       : std_logic;

  signal period_count  : std_logic_vector(8 downto 0);
  signal period_count_reset  : std_logic;

  signal controller_latch    : std_logic;
  signal controller_clk      : std_logic;
  signal deserializer_reset  : std_logic;
  signal deserializer_clk    : std_logic;

  signal reg_write         : std_logic;

begin
  test: input_driver
  port map(
    clk => clk,
    reset => reset,
    period_count => period_count,
    period_count_reset => period_count_reset,
    controller_latch => controller_latch,
    controller_clk => controller_clk,
    deserializer_reset => deserializer_reset,
    deserializer_clk => deserializer_clk,
    reg_write => reg_write
  );

  counter: input_period_counter port map (
    clk => clk,
    reset => period_count_reset,
    count_out => period_count
  );

  clk   <= '1' after 0 ns,
           '0' after 20 ns when clk /= '0' else '1' after 20 ns;

  reset <= '1' after 0 ns,
           '0' after 70 ns;

end architecture behavioural;
