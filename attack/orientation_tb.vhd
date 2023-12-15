library IEEE;
use IEEE.std_logic_1164.ALL;

entity orientation_tb is
end entity orientation_tb;

architecture behaviour of orientation_tb is

	component orientation is
		port(	clk : in  std_logic;
        		res : in  std_logic;
        		input1  : in  std_logic_vector (7 downto 0);
        		input2  : in  std_logic_vector (7 downto 0);
			--input3  : in  std_logic_vector (7 downto 0);
			--input4  : in  std_logic_vector (7 downto 0);
        		output1  : out std_logic;
			--output3  : out std_logic;
			--output4  : out std_logic;
        		output2  : out std_logic);
	end component;

   signal clk : std_logic;
   signal res : std_logic;
   signal input1  : std_logic_vector (7 downto 0);
   signal input2  : std_logic_vector (7 downto 0);
   signal output1  : std_logic;
   signal output2  : std_logic;
begin
   test: orientation port map (clk, res, input1, input2, output1, output2);
   clk <= '0' after 0 ns,
          '1' after 10 ns when clk /= '1' else '0' after 10 ns;
   res <= '0' after 0 ns, '1' after 75 ms;
   input1(0) <= '0' after 0 ns, '1' after 15 ms, '0' after 45 ms, '1' after 65 ms;
   input1(1) <= '0' after 0 ns, '1' after 35 ms, '0' after 55 ms;
   input1(2) <= '0' after 0 ns;
   input1(3) <= '0' after 0 ns;
   input1(4) <= '0' after 0 ns;
   input1(5) <= '0' after 0 ns;
   input1(6) <= '0' after 0 ns;
   input1(7) <= '0' after 0 ns;

   input2(0) <= '0' after 0 ns, '1' after 45 ms, '0' after 55 ms;
   input2(1) <= '0' after 0 ns, '1' after 15 ms, '0' after 35 ms, '1' after 65 ms;
   input2(2) <= '0' after 0 ns;
   input2(3) <= '0' after 0 ns;
   input2(4) <= '0' after 0 ns;
   input2(5) <= '0' after 0 ns;
   input2(6) <= '0' after 0 ns;
   input2(7) <= '0' after 0 ns;
end behaviour;
