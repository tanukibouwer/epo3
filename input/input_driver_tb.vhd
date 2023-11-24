library IEEE;
use IEEE.std_logic_1164.all;

entity input_driver_tb is
end entity input_driver_tb;

architecture structural of input_driver_tb is
  component input_driver is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      controller_latch    : out   std_logic;
      controller_clk      : out   std_logic;

      p1_controller : in    std_logic;                    -- player 1 controller serial data in
      p1_input      : out   std_logic_vector(7 downto 0)  -- player 1 parallel out
    );
  end component input_driver;

  signal clk, reset      : std_logic;
  signal p1_controller   : std_logic;

begin
  clk   <= '1' after 0 ns,
           '0' after 20 ns when clk /= '0' else '1' after 20 ns;

  reset <= '1' after 0 ns,
           '0' after 70 ns;

  p1_controller <= '1' after 0 ns,
                   '0' after 185 us;




  driver: input_driver
  port map(
    clk => clk,
    reset => reset,
    p1_controller => p1_controller
  );

end architecture structural;
