library IEEE;
use IEEE.std_logic_1164.all;

entity input_buffer_tb is
end entity input_buffer_tb;

architecture behavioural of input_buffer_tb is
  component input_buffer is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      input    : in    std_logic;
      output   : out   std_logic
    );
  end component input_buffer;

  signal clk, reset   : std_logic;

  signal input  : std_logic;
  signal output  : std_logic;

begin
  test: input_buffer
  port map(
    clk => clk,
    reset => reset,
    input => input,
    output => output
  );

  clk   <= '0' after 0 ns,
           '1' after 20 ns when clk /= '1' else '0' after 20 ns;

  reset <= '1' after 0 ns,
           '0' after 30 ns;

  input <= '1' after 0 ns,
                 '0' after 90 ns;

end architecture behavioural;
