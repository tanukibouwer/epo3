library IEEE;
use IEEE.std_logic_1164.ALL;

entity physics_adder_tb is
end physics_adder_tb;

architecture structural of physics_adder_tb is
   component physics_adder
      generic(width : INTEGER := 10);
      port(a      : in  std_logic_vector(width-1 downto 0);
           b      : in  std_logic_vector(width-1 downto 0);
           result : out std_logic_vector(width-1 downto 0));
   end component;
   signal a   : std_logic_vector(9 downto 0);
   signal b   : std_logic_vector(9 downto 0);
   signal result  : std_logic_vector(9 downto 0);
begin
    adder: physics_adder port map (a, b, result);
    a <= "0000000000" after 0 ns,
"0000000001" after 10 ns,
"0000000010" after 20 ns,
"0000000100" after 30 ns,
"0000001101" after 40 ns;
    b <= "0000000000" after 5 ns,
"0000000001" after 15 ns,
"0000000010" after 25 ns,
"0000000100" after 35 ns,
"0000001101" after 45 ns;
	
end structural;

configuration physics_adder_tb_structural_cfg of physics_adder_tb is
   for structural
      for all: physics_adder use configuration work.physics_adder_behaviour_cfg;
      end for;
   end for;
end physics_adder_tb_structural_cfg;

