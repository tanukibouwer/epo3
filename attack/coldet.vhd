library IEEE;
use IEEE.std_logic_1164.ALL;

entity coldet is
   port(clk          : in  std_logic;
        res          : in  std_logic;
	a1	     : in  std_logic;
	a2	     : in  std_logic;
	b1	     : in  std_logic;
	b2	     : in  std_logic;
	o1	     : in  std_logic;
	o2	     : in  std_logic;
        x1		     : in  std_logic_vector(8 downto 0);
        x2    		     : in  std_logic_vector(8 downto 0);
        y1     		    : in  std_logic_vector(8 downto 0);
        y2     		    : in  std_logic_vector(8 downto 0);
        direction_x1 : out std_logic_vector(7 downto 0);
        direction_x2 : out std_logic_vector(7 downto 0);
        direction_y1 : out std_logic_vector(7 downto 0);
        direction_y2 : out std_logic_vector(7 downto 0);
        collision1a2 : out std_logic;
	collision2a1 : out std_logic;
	collision1b2 : out std_logic;
	collision2b1 : out std_logic);
end coldet;

