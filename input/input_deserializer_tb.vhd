library IEEE;
use IEEE.std_logic_1164.all;

entity input_deserializer_tb is
end entity input_deserializer_tb;

architecture behavioural of input_deserializer_tb is
  component input_deserializer is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      data_p1     : in    std_logic;
      buttons_p1  : out   std_logic_vector(7 downto 0);
      data_p2     : in    std_logic;
      buttons_p2  : out   std_logic_vector(7 downto 0)
    );
  end component input_deserializer;

  signal clk, reset   : std_logic;

  signal data_p1      : std_logic;
  signal buttons_p1   : std_logic_vector(7 downto 0);
  signal data_p2      : std_logic;
  signal buttons_p2   : std_logic_vector(7 downto 0);

begin
  test: input_deserializer
  port map(
    clk => clk,
    reset => reset,
    data_p1 => data_p1,
    buttons_p1 => buttons_p1,
    data_p2 => data_p2,
    buttons_p2 => buttons_p2
  );

  clk   <= '1' after 0 ns,
           '0' after 20 ns when clk /= '0' else '1' after 20 ns;

  reset <= '1' after 0 ns,
           '0' after 70 ns;

  data_p1 <= '1' after 0 ns,
             '0' after 84 ns,
             '1' after 132 ns;

  data_p2 <= '1' after 0 ns,
             '0' after 84 ns,
             '1' after 132 ns;
end architecture behavioural;
