library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity dig3_num_splitter_tb is
end entity dig3_num_splitter_tb;

architecture tb of dig3_num_splitter_tb is
    component dig3_num_splitter is
        port (
        -- clk       : in std_logic;
        -- reset     : in std_logic;
        num3dig : in std_logic_vector(9 downto 0);
        num1    : out std_logic_vector(3 downto 0);
        num2    : out std_logic_vector(3 downto 0);
        num3    : out std_logic_vector(3 downto 0)

    );
    end component;
    signal num3dig          : std_logic_vector(9 downto 0);
    signal num1, num2, num3 : std_logic_vector(3 downto 0);

begin

    D3N: dig3_num_splitter port map (
        num3dig => num3dig, num1 => num1, num2 => num2, num3 => num3
    );

    num3dig     <= 
    "0000000000" after 0 ns,
    "0000000001" after 10 ns,
    "0000000010" after 20 ns,
    "0000000011" after 30 ns;




end architecture;