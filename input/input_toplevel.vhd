library IEEE;
use IEEE.std_logic_1164.all;

entity input_toplevel is
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
end entity input_toplevel;

architecture structural of input_toplevel is

  component input_driver is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      period_count  : in std_logic_vector(3 downto 0);
      period_count_reset  : out   std_logic;

      controller_latch    : out   std_logic;
      controller_clk      : out   std_logic;
      deserializer_clk    : out   std_logic;
      deserializer_reset  : out   std_logic;

      reg_write         : out   std_logic
    );
  end component input_driver;

  component input_period_counter is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      count_out     : out   std_logic_vector(3 downto 0)
    );
  end component input_period_counter;

  component input_buffer is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      input    : in    std_logic;
      output   : out   std_logic
    );
  end component;

  component input_deserializer is
    port (
      clk       : in    std_logic;
      reset     : in    std_logic;

      data_p1     : in    std_logic;
      buttons_p1          : out   std_logic_vector(7 downto 0);

      data_p2     : in    std_logic;
      buttons_p2          : out   std_logic_vector(7 downto 0)
    );
  end component input_deserializer;

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

  signal count  : std_logic_vector(3 downto 0);
  signal count_reset  : std_logic;

  signal deserializer_reset   : std_logic;
  signal deserializer_clk     : std_logic;
  signal des_clk_buffered     : std_logic;
  signal deserializer_out_p1  : std_logic_vector(7 downto 0);
  signal deserializer_out_p2  : std_logic_vector(7 downto 0);

  signal reg_write  : std_logic;

begin
  driver: input_driver port map (
    clk => clk,
    reset => reset,

    period_count => count,
    period_count_reset => count_reset,

    controller_latch => controller_latch,
    controller_clk => controller_clk,
    deserializer_clk => deserializer_clk,
    deserializer_reset => deserializer_reset,

    reg_write => reg_write
  );

  -- does not work without this buffer
  des_buffer: input_buffer port map (
    clk => clk,
    reset => reset,
    input => deserializer_clk,
    output => des_clk_buffered
  );

  counter: input_period_counter port map (
    clk => clk,
    reset => count_reset,
    count_out => count
  );

  desrlzr: input_deserializer port map (
    clk => des_clk_buffered,
    reset => deserializer_reset,

    data_p1 => data_p1,
    data_p2 => data_p2,

    buttons_p1 => deserializer_out_p1,
    buttons_p2 => deserializer_out_p2
  );

  reg: input_register port map (
    clk => clk,
    reset => reset,
    write => reg_write,

    buttons_in_p1 => deserializer_out_p1,
    buttons_out_p1 => buttons_p1,

    buttons_in_p2 => deserializer_out_p2,
	  buttons_out_p2 => buttons_p2
  );

end architecture;
