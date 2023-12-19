library ieee;
use IEEE.std_logic_1164.ALL;

entity damagecalculator_tb is
end damagecalculator_tb;

architecture behaviour of damagecalculator_tb is
   component damagecalculator
      port(clk : in  std_logic;
           res : in  std_logic;
   	collision1A2 : in std_logic;
   	collision2A1 : in std_logic;
   	oldpercentage1  : in  std_logic_vector (7 downto 0);
   	oldpercentage2  : in  std_logic_vector (7 downto 0);
   	percentage1  : out  std_logic_vector (7 downto 0);
   	percentage2  : out  std_logic_vector (7 downto 0);
   	newpercentage1  : out  std_logic_vector (7 downto 0);
   	newpercentage2  : out  std_logic_vector (7 downto 0));
   end component;
   signal clk : std_logic;
   signal res : std_logic;
   signal collision1A2 : std_logic;
   signal collision2A1 : std_logic;
   signal oldpercentage1  : std_logic_vector (7 downto 0);
   signal oldpercentage2  : std_logic_vector (7 downto 0);
   signal percentage1  : std_logic_vector (7 downto 0);
   signal percentage2  : std_logic_vector (7 downto 0);
   signal newpercentage1  : std_logic_vector (7 downto 0);
   signal newpercentage2  : std_logic_vector (7 downto 0);
begin
   test: damagecalculator port map (clk, res, collision1A2, collision2A1, oldpercentage1, oldpercentage2, percentage1, percentage2, newpercentage1, newpercentage2);
   clk <= '0' after 0 ns,
          '1' after 10 ns when clk /= '1' else '0' after 10 ns;
   res <= '0' after 0 ns, '1' after 200 ns;

   collision1A2 <= '0' after 0 ns, '1' after 50 ns;

   collision2A1 <= '0' after 0 ns, '1' after 50 ns;

   oldpercentage1(0) <= '0' after 0 ns, '0' after 100 ns;
   oldpercentage1(1) <= '0' after 0 ns, '0' after 100 ns;
   oldpercentage1(2) <= '0' after 0 ns, '0' after 100 ns;
   oldpercentage1(3) <= '0' after 0 ns, '0' after 100 ns;
   oldpercentage1(4) <= '0' after 0 ns, '0' after 100 ns;
   oldpercentage1(5) <= '0' after 0 ns, '0' after 100 ns;
   oldpercentage1(6) <= '0' after 0 ns, '0' after 100 ns;
   oldpercentage1(7) <= '0' after 0 ns, '1' after 100 ns; -- 128

   oldpercentage2(0) <= '0' after 0 ns, '0' after 150 ns;
   oldpercentage2(1) <= '0' after 0 ns, '0' after 150 ns;
   oldpercentage2(2) <= '0' after 0 ns, '0' after 150 ns;
   oldpercentage2(3) <= '0' after 0 ns, '0' after 150 ns;
   oldpercentage2(4) <= '0' after 0 ns, '0' after 150 ns;
   oldpercentage2(5) <= '0' after 0 ns, '0' after 150 ns;
   oldpercentage2(6) <= '0' after 0 ns, '1' after 150 ns;
   oldpercentage2(7) <= '0' after 0 ns, '0' after 150 ns; --64
end behaviour;