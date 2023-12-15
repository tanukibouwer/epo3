library IEEE;
use IEEE.std_logic_1164.all;

entity input_toplevel_tb is
end entity input_toplevel_tb;

architecture behavioural of input_toplevel_tb is
  component input_toplevel is
    port (
      clk   : in std_logic;
      reset : in std_logic;

      controller_latch    : out   std_logic;
      controller_clk      : out   std_logic;

      data_p1       : in    std_logic;                      -- serial in
      buttons_p1    : out   std_logic_vector(7 downto 0);   -- parallel out

      data_p2       : in    std_logic;                      -- serial in
      buttons_p2    : out   std_logic_vector(7 downto 0)    -- parallel out
    );
  end component input_toplevel;

  signal clk, reset       : std_logic;

  signal controller_latch : std_logic;
  signal controller_clk   : std_logic;

  signal data_p1      : std_logic;
  signal buttons_p1   : std_logic_vector(7 downto 0);
  signal data_p2      : std_logic;
  signal buttons_p2   : std_logic_vector(7 downto 0);

begin
  test: input_toplevel
  port map(
    clk => clk,
    reset => reset,
    controller_latch => controller_latch,
    controller_clk => controller_clk,
    data_p1 => data_p1,
    buttons_p1=> buttons_p1,
    data_p2 => data_p2,
    buttons_p2 => buttons_p2
  );

  clk   <= '1' after 0 ns,
           '0' after 20 ns when clk /= '0' else '1' after 20 ns;

  reset <= '1' after 0 ns,
           '0' after 70 ns,
           '0' after 200 us,
           '0' after 201 us;

  data_p1 <= '0' after 0 ns,
                   '1' after 30 us,
                   '0' after 55 us,
                   '1' after 185 us,
                   '0' after 290 us,
                   '1' after 330 us;

  data_p2 <= '1' after 0 ns,
                   '0' after 55 us,
                   '1' after 70 us;

end architecture behavioural;
