library ieee;
use ieee.std_logic_1164.all;

entity fpga_mux is
  port (
    inputs : in std_logic_vector(11 downto 0);
	 switches : in std_logic_vector(5 downto 0);
    
    R_data : out std_logic_vector(3 downto 0); -- RGB data to screen
    G_data : out std_logic_vector(3 downto 0); -- RGB data to screen
    B_data : out std_logic_vector(3 downto 0); -- RGB data to screen
    test_out : out std_logic_vector(9 downto 0)
  );
end entity;

architecture behavioural of fpga_mux is
begin
  process(switches, inputs)
  begin
    if (switches(5) = '1') then
      test_out <= inputs(9 downto 0);
      R_data <= "0000";
      G_data <= "0000";
      B_data <= "0000";
    else
      test_out <= "0000000000";
      R_data <= inputs(11 downto 8);
      G_data <= inputs(7 downto 4);
      B_data <= inputs(3 downto 0);
    end if;
  end process;

end architecture;

