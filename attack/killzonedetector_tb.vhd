library ieee;
use ieee.std_logic_1164.all;

entity killzonedetector_tb is
end killzonedetector_tb;

architecture behaviour of killzonedetector_tb is
component killzonedetector is
  port (clk      : in std_logic;
    res            : in std_logic;
    oldvectorX1 : in std_logic_vector (8 downto 0);
    oldvectorY1 : in std_logic_vector (8 downto 0);
    oldvectorX2 : in std_logic_vector (8 downto 0);
    oldvectorY2 : in std_logic_vector (8 downto 0);
    restart1       : out std_logic;
    restart2       : out std_logic;
    newdeathcount1 : out std_logic_vector (3 downto 0);
    newdeathcount2 : out std_logic_vector (3 downto 0));
   end component;

   signal clk : std_logic;
   signal res : std_logic;
   signal oldvectorX1  : std_logic_vector (8 downto 0);
   signal oldvectorY1  : std_logic_vector (8 downto 0);
   signal oldvectorX2  : std_logic_vector (8 downto 0);
   signal oldvectorY2  : std_logic_vector (8 downto 0);
   signal newdeathcount1  : std_logic_vector (3 downto 0);
   signal newdeathcount2  : std_logic_vector (3 downto 0);
   signal restart1       :  std_logic;
   signal restart2       :  std_logic;
begin

test: killzonedetector port map (clk, res, oldvectorX1, oldvectorY1, oldvectorX2, oldvectorY2, restart1, restart2, newdeathcount1, newdeathcount2);
   clk <= '0' after 0 ns,
        '1' after 10 ns when clk /= '1' else '0' after 10 ns;

   res <= '1' after 0 ns, '0' after 15 ns, '1' after 150 ns;

   oldvectorX1 <= "000000000" after 0 ns, "101100010" after 50 ns, "000000000" after 100 ns;
   oldvectorY1 <= "000000000" after 0 ns;
   oldvectorX2 <= "000000000" after 0 ns;
   oldvectorY2 <= "000000000" after 0 ns, "100100010" after 50 ns, "000000000" after 100 ns;


end behaviour;