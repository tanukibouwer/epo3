library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity input_register is
  port (
    clk       : in    std_logic;
    reset     : in    std_logic;
    write     : in    std_logic;

    buttons_in_p1    : in    std_logic_vector(7 downto 0);
    buttons_out_p1   : out   std_logic_vector(7 downto 0);

    buttons_in_p2    : in    std_logic_vector(7 downto 0);
    buttons_out_p2   : out   std_logic_vector(7 downto 0)
  );
end entity input_register;

architecture behavioural of input_register is
  signal buttons_p1 : std_logic_vector(7 downto 0);
  signal buttons_p2 : std_logic_vector(7 downto 0);
begin
  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (reset = '1') then
        buttons_p1 <= "00000000";
        buttons_p2 <= "00000000";
      elsif (write = '1') then
        buttons_p1(7) <= buttons_in_p1(5);
        buttons_p1(6) <= buttons_in_p1(4);
        buttons_p1(5) <= buttons_in_p1(6);
        buttons_p1(4) <= buttons_in_p1(7);
        buttons_p1(3) <= buttons_in_p1(2);
        buttons_p1(2) <= buttons_in_p1(3);
        buttons_p1(1) <= buttons_in_p1(0);
        buttons_p1(0) <= buttons_in_p1(1);

        buttons_p2(7) <= buttons_in_p2(5);
        buttons_p2(6) <= buttons_in_p2(4);
        buttons_p2(5) <= buttons_in_p2(6);
        buttons_p2(4) <= buttons_in_p2(7);
        buttons_p2(3) <= buttons_in_p2(2);
        buttons_p2(2) <= buttons_in_p2(3);
        buttons_p2(1) <= buttons_in_p2(0);
        buttons_p2(0) <= buttons_in_p2(1);
      end if;
    end if;
  end process;

  buttons_out_p1 <= buttons_p1;
  buttons_out_p2 <= buttons_p2;
end architecture behavioural;
