library IEEE;
use IEEE.std_logic_1164.all;

entity deserializer_tb is
end entity deserializer_tb;

architecture behavioural of deserializer_tb is
  component deserializer is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      controller_p1     : in    std_logic;
      input_p1          : out   std_logic_vector(7 downto 0)
    );
  end component deserializer;

  signal clk, reset       : std_logic;

  signal controller_p1    : std_logic;
  signal input_p1         : std_logic_vector(7 downto 0);

begin
  test: deserializer
  port map(
    clk => clk,
    reset => reset,
    controller_p1 => controller_p1,
    input_p1 => input_p1
  );

  clk   <= '1' after 0 ns,
           '0' after 20 ns when clk /= '0' else '1' after 20 ns;

  reset <= '1' after 0 ns,
           '0' after 70 ns;

  controller_p1 <= '1' after 0 ns,
                   '0' after 84 ns,
                   '1' after 132 ns;

end architecture behavioural;
