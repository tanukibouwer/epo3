library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity offset_adder_tb is
end entity offset_adder_tb;

architecture tb of offset_adder_tb is
    component char_offset_adder is
        port (
            xpos      : in std_logic_vector(7 downto 0);
            ypos      : in std_logic_vector(7 downto 0);
            xpos_scl1 : out std_logic_vector(9 downto 0);
            xpos_scl2 : out std_logic_vector(9 downto 0);
            ypos_scl1 : out std_logic_vector(9 downto 0);
            ypos_scl2 : out std_logic_vector(9 downto 0)
        );
    end component;
    signal xpos_uns, ypos_uns                         : unsigned(7 downto 0);
    signal xpos, ypos                                 : std_logic_vector(7 downto 0);
    signal xpos_scl1, xpos_scl2, ypos_scl1, ypos_scl2 : std_logic_vector(9 downto 0);

begin
    xpos     <= std_logic_vector(xpos_uns);
    ypos     <= std_logic_vector(ypos_uns);
    xpos_uns <= to_unsigned(4, xpos_uns'length) after 0 ns, to_unsigned(176, xpos_uns'length) after 10 ms, to_unsigned(50, xpos_uns'length) after 20 ms;
    ypos_uns <= to_unsigned(4, xpos_uns'length) after 0 ns, to_unsigned(125, xpos_uns'length) after 10 ms,to_unsigned(50, xpos_uns'length) after 20 ms;
    test : char_offset_adder port map(
        xpos => xpos, ypos => ypos, xpos_scl1 => xpos_scl1, xpos_scl2 => xpos_scl2, ypos_scl2 => ypos_scl2, ypos_scl1 => ypos_scl1
    );

end architecture;