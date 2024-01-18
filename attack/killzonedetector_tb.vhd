library ieee;
use ieee.std_logic_1164.all;

entity killzonedetector_tb is
end killzonedetector_tb;

architecture behaviour of killzonedetector_tb is
component killzonedetector is
  port (clk      : in std_logic;
    res            : in std_logic;
    vsync  : in std_logic;
    olddeathcount1 : in std_logic_vector (3 downto 0);
    olddeathcount2 : in std_logic_vector (3 downto 0);
    --olddeathcount3  : in  std_logic_vector (3 downto 0);
    --olddeathcount4  : in  std_logic_vector (3 downto 0);
    oldpercentage1 : in std_logic_vector (7 downto 0);
    oldpercentage2 : in std_logic_vector (7 downto 0);
    --oldpercentage3  : in  std_logic_vector (7 downto 0);
    --oldpercentage4  : in  std_logic_vector (7 downto 0);
    oldvectorX1 : in std_logic_vector (8 downto 0);
    oldvectorY1 : in std_logic_vector (8 downto 0);
    oldvectorX2 : in std_logic_vector (8 downto 0);
    oldvectorY2 : in std_logic_vector (8 downto 0);
    --oldvectorX3  : in  std_logic_vector (7 downto 0);
    --oldvectorY3  : in  std_logic_vector (7 downto 0);
    --oldvectorX4  : in  std_logic_vector (7 downto 0);
    --oldvectorY4  : in  std_logic_vector (7 downto 0);
    restart1       : out std_logic;
    restart2       : out std_logic;
    newdeathcount1 : out std_logic_vector (3 downto 0);
    newdeathcount2 : out std_logic_vector (3 downto 0));
    --newdeathcount3  : out  std_logic_vector (3 downto 0);
    --newdeathcount4  : out  std_logic_vector (3 downto 0);
    -- -- newpercentage1  : out  std_logic_vector (7 downto 0);
    -- -- newpercentage2  : out  std_logic_vector (7 downto 0));
    ---- newpercentage3  : out  std_logic_vector (7 downto 0);
    ---- newpercentage4  : out  std_logic_vector (7 downto 0);
    --newvectorX3  : out  std_logic_vector (7 downto 0);
    --newvectorY3  : out  std_logic_vector (7 downto 0);
    --newvectorX4  : out  std_logic_vector (7 downto 0);
    --newvectorY4  : out  std_logic_vector (7 downto 0);
    --	newvectorX1  : out  std_logic_vector (7 downto 0);
    --        newvectorY1  : out  std_logic_vector (7 downto 0);
    --	newvectorX2  : out  std_logic_vector (7 downto 0);
    --        newvectorY2  : out  std_logic_vector (7 downto 0));
   end component;

   signal clk : std_logic;
   signal res : std_logic;
   signal olddeathcount1  : std_logic_vector (3 downto 0);
   signal olddeathcount2  : std_logic_vector (3 downto 0);
   signal oldpercentage1  : std_logic_vector (7 downto 0);
   signal oldpercentage2  : std_logic_vector (7 downto 0);
   signal oldvectorX1  : std_logic_vector (8 downto 0);
   signal oldvectorY1  : std_logic_vector (8 downto 0);
   signal oldvectorX2  : std_logic_vector (8 downto 0);
   signal oldvectorY2  : std_logic_vector (8 downto 0);
   signal newdeathcount1  : std_logic_vector (3 downto 0);
   signal newdeathcount2  : std_logic_vector (3 downto 0);
   signal restart1       :  std_logic;
   signal restart2       :  std_logic;
   signal vsync : std_logic;
begin

test: killzonedetector port map (clk, res, vsync, olddeathcount1, olddeathcount2, oldpercentage1, oldpercentage2, oldvectorX1, oldvectorY1, oldvectorX2, oldvectorY2, restart1, restart2, newdeathcount1, newdeathcount2);
   clk <= '0' after 0 ns,
        '1' after 10 ns when clk /= '1' else '0' after 10 ns;


   vsync <= '0' after 0 ns,
          '1' after 100 ns when clk /= '1' else '0' after 100 ns;
   res <= '0' after 0 ns, '1' after 100 ms;


   olddeathcount1 <= "0000" after 0 ns;
   olddeathcount2 <= "0000" after 0 ns;


   oldpercentage1 <= "00000000" after 0 ns;
   oldpercentage2 <= "00000000" after 0 ns;


   oldvectorX1 <= "000000000" after 0 ns, "101100001" after 50 ns;
   oldvectorY1 <= "000000000" after 0 ns;
   oldvectorX2 <= "000000000" after 0 ns;
   oldvectorY2 <= "000000000" after 0 ns;


end behaviour;