library IEEE;
use IEEE.std_logic_1164.all;

entity input_buffer is
  port (
    clk       : in    std_logic;
    reset     : in    std_logic;

    input    : in    std_logic;
    output   : out   std_logic
  );
end entity;

architecture behavioural of input_buffer is
  signal tmp : std_logic;
begin
  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (reset = '1') then
        tmp <= '0';
      else
        tmp <= input;
      end if;
    end if;
  end process;

  output <= tmp;
end architecture behavioural;
