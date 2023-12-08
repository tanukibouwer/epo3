library ieee;
use ieee.std_logic_1164.all;

entity killzonedetector_tb is
end killzonedetector_tb;

architecture behaviour of killzonedetector_tb is
   component killzonedetector
      port(clk : in  std_logic;
           res : in  std_logic;
   	olddeathcount1  : in  std_logic_vector (3 downto 0);
   	olddeathcount2  : in  std_logic_vector (3 downto 0);
   	oldpercentage1  : in  std_logic_vector (7 downto 0);
   	oldpercentage2  : in  std_logic_vector (7 downto 0);
           oldvectorX1  : in  std_logic_vector (7 downto 0);
           oldvectorY1  : in  std_logic_vector (7 downto 0);
   	oldvectorX2  : in  std_logic_vector (7 downto 0);
           oldvectorY2  : in  std_logic_vector (7 downto 0);
           newdeathcount1  : out  std_logic_vector (3 downto 0);
   	newdeathcount2  : out  std_logic_vector (3 downto 0);
   	newpercentage1  : out  std_logic_vector (7 downto 0);
   	newpercentage2  : out  std_logic_vector (7 downto 0);
   	newvectorX1  : out  std_logic_vector (7 downto 0);
           newvectorY1  : out  std_logic_vector (7 downto 0);
   	newvectorX2  : out  std_logic_vector (7 downto 0);
           newvectorY2  : out  std_logic_vector (7 downto 0));
   end component;

   signal clk : std_logic;
   signal res : std_logic;
   signal olddeathcount1  : std_logic_vector (3 downto 0);
   signal olddeathcount2  : std_logic_vector (3 downto 0);
   signal oldpercentage1  : std_logic_vector (7 downto 0);
   signal oldpercentage2  : std_logic_vector (7 downto 0);
   signal oldvectorX1  : std_logic_vector (7 downto 0);
   signal oldvectorY1  : std_logic_vector (7 downto 0);
   signal oldvectorX2  : std_logic_vector (7 downto 0);
   signal oldvectorY2  : std_logic_vector (7 downto 0);
   signal newdeathcount1  : std_logic_vector (3 downto 0);
   signal newdeathcount2  : std_logic_vector (3 downto 0);
   signal newpercentage1  : std_logic_vector (7 downto 0);
   signal newpercentage2  : std_logic_vector (7 downto 0);
   signal newvectorX1  : std_logic_vector (7 downto 0);
   signal newvectorY1  : std_logic_vector (7 downto 0);
   signal newvectorX2  : std_logic_vector (7 downto 0);
   signal newvectorY2  : std_logic_vector (7 downto 0);
begin

	test: killzonedetector port map (clk, res, olddeathcount1, olddeathcount2, oldpercentage1, oldpercentage2, oldvectorX1, oldvectorY1, oldvectorX2, oldvectorY2, newdeathcount1, newdeathcount2, newpercentage1, newpercentage2, newvectorX1, newvectorY1, newvectorX2, newvectorY2);

	clk <= '0' after 0 ns,
          '1' after 10 ns when clk /= '1' else '0' after 10 ns;
   res <= '0' after 0 ns, '1' after 100 ms;

   olddeathcount1(0) <= '0' after 0 ns;
   olddeathcount1(1) <= '0' after 0 ns;
   olddeathcount1(2) <= '0' after 0 ns;
   olddeathcount1(3) <= '0' after 0 ns;

   olddeathcount2(0) <= '0' after 0 ns;
   olddeathcount2(1) <= '0' after 0 ns;
   olddeathcount2(2) <= '0' after 0 ns;
   olddeathcount2(3) <= '0' after 0 ns;

   oldpercentage1(0) <= '0' after 0 ns;
   oldpercentage1(1) <= '0' after 0 ns;
   oldpercentage1(2) <= '0' after 0 ns;
   oldpercentage1(3) <= '0' after 0 ns;
   oldpercentage1(4) <= '0' after 0 ns;
   oldpercentage1(5) <= '0' after 0 ns;
   oldpercentage1(6) <= '0' after 0 ns;
   oldpercentage1(7) <= '0' after 0 ns;

   oldpercentage2(0) <= '0' after 0 ns;
   oldpercentage2(1) <= '0' after 0 ns;
   oldpercentage2(2) <= '0' after 0 ns;
   oldpercentage2(3) <= '0' after 0 ns;
   oldpercentage2(4) <= '0' after 0 ns;
   oldpercentage2(5) <= '0' after 0 ns;
   oldpercentage2(6) <= '0' after 0 ns;
   oldpercentage2(7) <= '0' after 0 ns;

   oldvectorX1(0) <= '0' after 0 ns, '1' after 0 ns;
   oldvectorX1(1) <= '0' after 0 ns, '0' after 0 ns;
   oldvectorX1(2) <= '0' after 0 ns, '0' after 0 ns;
   oldvectorX1(3) <= '0' after 0 ns, '1' after 0 ns;
   oldvectorX1(4) <= '0' after 0 ns, '0' after 0 ns;
   oldvectorX1(5) <= '0' after 0 ns, '1' after 0 ns;
   oldvectorX1(6) <= '0' after 0 ns, '0' after 0 ns;
   oldvectorX1(7) <= '0' after 0 ns, '1' after 0 ns;

   oldvectorY1(0) <= '0' after 0 ns;
   oldvectorY1(1) <= '0' after 0 ns;
   oldvectorY1(2) <= '0' after 0 ns;
   oldvectorY1(3) <= '0' after 0 ns;
   oldvectorY1(4) <= '0' after 0 ns;
   oldvectorY1(5) <= '0' after 0 ns;
   oldvectorY1(6) <= '0' after 0 ns;
   oldvectorY1(7) <= '0' after 0 ns;

   oldvectorX2(0) <= '0' after 0 ns;
   oldvectorX2(1) <= '0' after 0 ns;
   oldvectorX2(2) <= '0' after 0 ns;
   oldvectorX2(3) <= '0' after 0 ns;
   oldvectorX2(4) <= '0' after 0 ns;
   oldvectorX2(5) <= '0' after 0 ns;
   oldvectorX2(6) <= '0' after 0 ns;
   oldvectorX2(7) <= '0' after 0 ns;

   oldvectorY2(0) <= '0' after 0 ns;
   oldvectorY2(1) <= '0' after 0 ns;
   oldvectorY2(2) <= '0' after 0 ns;
   oldvectorY2(3) <= '0' after 0 ns;
   oldvectorY2(4) <= '0' after 0 ns;
   oldvectorY2(5) <= '0' after 0 ns;
   oldvectorY2(6) <= '0' after 0 ns;
   oldvectorY2(7) <= '0' after 0 ns;
end behaviour;