library IEEE;
use IEEE.std_logic_1164.all;

entity input is
  port (
    clk   : in std_logic;
    reset : in std_logic;

    controller_latch    : out   std_logic;
    controller_clk      : out   std_logic;

    p1_controller : in    std_logic;                    -- player 1 controller serial data in
    p1_input      : out   std_logic_vector(7 downto 0)  -- player 1 parallel out
 );
end entity;

architecture structural of input is

  component input_driver is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      period_count  : in std_logic_vector(8 downto 0);
      period_count_reset  : out   std_logic;

      controller_latch    : out   std_logic;
      controller_clk      : out   std_logic;

      p1_controller : in    std_logic;                    -- player 1 controller serial data in
      p1_input      : out   std_logic_vector(7 downto 0)  -- player 1 parallel out
    );
  end component input_driver;

  component input_period_counter is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      count_out     : out   std_logic_vector(8 downto 0)
    );
  end component input_period_counter;

  signal count  : std_logic_vector(8 downto 0);
  signal count_reset : std_logic;

begin

  driver: input_driver port map (
    clk => clk,
    reset => reset,

    period_count => count,
    period_count_reset => count_reset,

    controller_latch => controller_latch,
    controller_clk => controller_clk,

    p1_controller => p1_controller,
    p1_input => p1_input
  );

  counter: input_period_counter port map (
    clk => clk,
    reset => count_reset,
    count_out => count
  );

end architecture;
