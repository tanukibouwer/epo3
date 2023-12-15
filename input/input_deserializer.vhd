library IEEE;
use IEEE.std_logic_1164.all;

entity input_deserializer is
  port (
    clk       : in    std_logic;
    reset     : in    std_logic;

    data_p1     : in    std_logic;
    buttons_p1  : out   std_logic_vector(7 downto 0);

    data_p2     : in    std_logic;
    buttons_p2  : out   std_logic_vector(7 downto 0)
  );
end entity input_deserializer;

architecture behavioural of input_deserializer is
  signal buttons_signal_p1 : std_logic_vector(7 downto 0);
  signal buttons_signal_p2 : std_logic_vector(7 downto 0);
begin
  buttons_p1 <= buttons_signal_p1;
  buttons_p2 <= buttons_signal_p2;

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (reset = '1') then
        buttons_signal_p1 <= "00000000";
        buttons_signal_p2 <= "00000000";
      else
        -- read !data to bit 0 and shift all other bits to the left
        buttons_signal_p1(0) <= not data_p1;
        buttons_signal_p1(1) <= buttons_signal_p1(0);
        buttons_signal_p1(2) <= buttons_signal_p1(1);
        buttons_signal_p1(3) <= buttons_signal_p1(2);
        buttons_signal_p1(4) <= buttons_signal_p1(3);
        buttons_signal_p1(5) <= buttons_signal_p1(4);
        buttons_signal_p1(6) <= buttons_signal_p1(5);
        buttons_signal_p1(7) <= buttons_signal_p1(6);

        buttons_signal_p2(0) <= not data_p2;
        buttons_signal_p2(1) <= buttons_signal_p2(0);
        buttons_signal_p2(2) <= buttons_signal_p2(1);
        buttons_signal_p2(3) <= buttons_signal_p2(2);
        buttons_signal_p2(4) <= buttons_signal_p2(3);
        buttons_signal_p2(5) <= buttons_signal_p2(4);
        buttons_signal_p2(6) <= buttons_signal_p2(5);
        buttons_signal_p2(7) <= buttons_signal_p2(6);
      end if;
    end if;
  end process;

end architecture behavioural;
