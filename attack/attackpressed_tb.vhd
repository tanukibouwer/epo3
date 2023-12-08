library IEEE;
use IEEE.std_logic_1164.ALL;

entity attackp_tb is
end attackp_tb;

architecture behaviour of attackp_tb is

	component attackp is
		port(	clk : in  std_logic;
        		res : in  std_logic;
        		input1  : in  std_logic_vector (7 downto 0);
        		input2  : in  std_logic_vector (7 downto 0);
        		output1A  : out std_logic;
			output1B  : out std_logic;
			output2A  : out std_logic;
        		output2B  : out std_logic);
	end component;

   signal clk : std_logic;
   signal res : std_logic;
   signal input1  : std_logic_vector (7 downto 0);
   signal input2  : std_logic_vector (7 downto 0);
   signal output1A  : std_logic;
   signal output1B  : std_logic;
   signal output2A  : std_logic;
   signal output2B  : std_logic;
begin
   test: attackp port map (clk, res, input1, input2, output1A, output1B, output2A, output2B);
   clk <= '0' after 0 ns,
          '1' after 10 ns when clk /= '1' else '0' after 10 ns;
   res <= '0' after 0 ns, '1' after 500 ns;

   input1(0) <= '0' after 0 ns;
   input1(1) <= '0' after 0 ns;
   input1(2) <= '0' after 0 ns;
   input1(3) <= '0' after 0 ns;
   input1(4) <= '0' after 0 ns, '1' after 100 ns, '0' after 200 ns;
   input1(5) <= '0' after 0 ns, '1' after 150 ns, '0' after 300 ns;
   input1(6) <= '0' after 0 ns;
   input1(7) <= '0' after 0 ns;

   input2(0) <= '0' after 0 ns;
   input2(1) <= '0' after 0 ns;
   input2(2) <= '0' after 0 ns;
   input2(3) <= '0' after 0 ns;
   input2(4) <= '0' after 0 ns, '1' after 100 ns, '0' after 200 ns;
   input2(5) <= '0' after 0 ns, '1' after 300 ns, '0' after 400 ns;
   input2(6) <= '0' after 0 ns;
   input2(7) <= '0' after 0 ns;
end behaviour;