library IEEE;
use IEEE.std_logic_1164.all;

entity input_register_tb is
end entity input_register_tb;

architecture behavioural of input_register_tb is
  component input_register is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;
      write     : in    std_logic;

      buttons_in_p1    : in    std_logic_vector(7 downto 0);
      buttons_out_p1   : out   std_logic_vector(7 downto 0);

      buttons_in_p2    : in    std_logic_vector(7 downto 0);
      buttons_out_p2   : out   std_logic_vector(7 downto 0)
    );
  end component input_register;

  signal clk, reset   : std_logic;
  signal write        : std_logic;

  signal buttons_in_p1         : std_logic_vector(7 downto 0);
  signal buttons_out_p1        : std_logic_vector(7 downto 0);
  signal buttons_in_p2         : std_logic_vector(7 downto 0);
  signal buttons_out_p2        : std_logic_vector(7 downto 0);

begin
  test: input_register
  port map(
    clk => clk,
    reset => reset,
    write => write,
    buttons_in_p1 => buttons_in_p1,
    buttons_out_p1 => buttons_out_p1,
    buttons_in_p2 => buttons_in_p2,
    buttons_out_p2 => buttons_out_p2
  );

  clk   <= '1' after 0 ns,
           '0' after 20 ns when clk /= '0' else '1' after 20 ns;

  reset <= '1' after 0 ns,
           '0' after 70 ns;

  write <= '0' after 0 ns,
          '1' after 80 ns,
          '0' after 120 ns,
          '1' after 200 ns,
          '0' after 240 ns;

  buttons_in_p1 <= "00000000" after 0 ns,
                 "10110100" after 180 ns;

  buttons_in_p2 <= "00000000" after 0 ns,
                 "10110100" after 180 ns;

end architecture behavioural;
