library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity input_buffer is
  port (
    clk       : in    std_logic;
    reset     : in    std_logic;

    read      : in    std_logic;
    input_in_p1    : in    std_logic_vector(7 downto 0);
    input_out_p1   : out   std_logic_vector(7 downto 0)
  );
end entity input_buffer;

architecture behavioural of input_buffer is
  signal input_p1 : std_logic_vector(7 downto 0);
begin
  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (reset = '1') then
        input_p1 <= "00000000";
      elsif (read = '1') then
        input_p1 <= input_in_p1;
      end if;
    end if;
  end process;

  input_out_p1 <= input_p1;
end architecture behavioural;
