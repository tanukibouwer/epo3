library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity deserializer is
  port (
    clk       : in    std_logic;
    reset     : in    std_logic;

    controller_p1     : in    std_logic;
    input_p1          : out   std_logic_vector(7 downto 0)
  );
end entity deserializer;

architecture behavioural of deserializer is
  signal input_signal_p1 : std_logic_vector(7 downto 0);
begin
  input_p1 <= input_signal_p1;

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (reset = '1') then
        input_signal_p1 <= "00000000";
      else
        input_signal_p1(0) <= not controller_p1;
        input_signal_p1(1) <= input_signal_p1(0);
        input_signal_p1(2) <= input_signal_p1(1);
        input_signal_p1(3) <= input_signal_p1(2);
        input_signal_p1(4) <= input_signal_p1(3);
        input_signal_p1(5) <= input_signal_p1(4);
        input_signal_p1(6) <= input_signal_p1(5);
        input_signal_p1(7) <= input_signal_p1(6);
      end if;
    end if;
  end process;

end architecture behavioural;
