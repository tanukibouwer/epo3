library IEEE;
use IEEE.std_logic_1164.all;

entity input_period_counter_tb is
end entity input_period_counter_tb;

architecture behavioural of input_period_counter_tb is
  component input_period_counter is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      count_out     : out   std_logic_vector(8 downto 0)
    );
  end component input_period_counter;

  signal clk, reset       : std_logic;

  signal count_out        : std_logic_vector(8 downto 0);

begin
  test: input_period_counter
  port map(
    clk => clk,
    reset => reset,
    count_out => count_out
  );

  clk   <= '1' after 0 ns,
           '0' after 20 ns when clk /= '0' else '1' after 20 ns;

  reset <= '1' after 0 ns,
           '0' after 70 ns,
           '1' after 12000 ns,
           '0' after 12040 ns;


end architecture behavioural;
