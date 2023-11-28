library IEEE;
use IEEE.std_logic_1164.all;

entity input_buffer_tb is
end entity input_buffer_tb;

architecture behavioural of input_buffer_tb is
  component input_buffer is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      read      : in    std_logic;
      input_in_p1    : in    std_logic_vector(7 downto 0);
      input_out_p1   : out   std_logic_vector(7 downto 0)
    );
  end component input_buffer;

  signal clk, reset       : std_logic;

  signal read : std_logic;

  signal input_in_p1         : std_logic_vector(7 downto 0);
  signal input_out_p1        : std_logic_vector(7 downto 0);

begin
  test: input_buffer
  port map(
    clk => clk,
    reset => reset,
    read => read,
    input_in_p1 => input_in_p1,
    input_out_p1 => input_out_p1
  );

  clk   <= '1' after 0 ns,
           '0' after 20 ns when clk /= '0' else '1' after 20 ns;

  reset <= '1' after 0 ns,
           '0' after 70 ns;

  read <= '0' after 0 ns,
          '1' after 80 ns,
          '0' after 120 ns,
          '1' after 200 ns,
          '0' after 240 ns;

  input_in_p1 <= "00000000" after 0 ns,
                 "10110100" after 180 ns;

end architecture behavioural;
