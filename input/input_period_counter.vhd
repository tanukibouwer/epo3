library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity input_period_counter is
  port (
    clk       : in    std_logic;
    reset     : in    std_logic;

    count_out     : out   std_logic_vector(8 downto 0)
  );
end entity input_period_counter;

architecture behavioural of input_period_counter is
  signal count, new_count : unsigned(8 downto 0);
begin
  process (clk)
  begin
    if (clk'event and clk = '1') then
      if (reset = '1') then
        count <= (others => '0');
      else
        count <= new_count;
      end if;
    end if;
  end process;

  process (count)
  begin
    new_count <= count + 1;
  end process;

  count_out <= std_logic_vector(count);

end architecture;
