library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity deserializer is
  port (
    clk       : in    std_logic;
    reset     : in    std_logic;

    controller_latch  : in    std_logic;
    controller_clk    : in    std_logic;

    controller_p1     : in    std_logic;
    input_p1          : out   std_logic_vector(7 downto 0)

  );
end entity deserializer;

architecture behavioural of deserializer is
begin

end architecture behavioural;
