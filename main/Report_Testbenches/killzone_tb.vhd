library ieee;
use ieee.std_logic_1164.all;

entity killzone_tb is
end killzone_tb;

architecture structural of killzone_tb is

    component orientation is
        port (
            clk     : in std_logic;
            res     : in std_logic;
            input1  : in std_logic_vector (7 downto 0);
            input2  : in std_logic_vector (7 downto 0);
            output1 : out std_logic;
            output2 : out std_logic);
    end component orientation;

    signal or1,
    or2 : std_logic;

    component attackp is
        port (
            clk      : in std_logic;
            res      : in std_logic;
            input1   : in std_logic_vector (7 downto 0);
            input2   : in std_logic_vector (7 downto 0);
            vsync    : in std_logic;
            output1A : out std_logic;
            output1B : out std_logic;
            output2A : out std_logic;
            output2B : out std_logic);
    end component attackp;

    signal at1a,
    at1b,
    at2a,
    at2b : std_logic;

    component damagecalculator is
        port (
            clk            : in std_logic;
            res            : in std_logic;
            collision1A2   : in std_logic;
            collision1B2   : in std_logic;
            collision2A1   : in std_logic;
            collision2B1   : in std_logic;
            oldpercentage1 : in std_logic_vector (7 downto 0);
            oldpercentage2 : in std_logic_vector (7 downto 0);
            percentage1    : out std_logic_vector (7 downto 0);
            percentage2    : out std_logic_vector (7 downto 0);
            newpercentage1 : out std_logic_vector (7 downto 0);
            newpercentage2 : out std_logic_vector (7 downto 0));
    end component damagecalculator;

    component killzonedetector is
        port (
            clk            : in std_logic;
            res            : in std_logic;
            olddeathcount1 : in std_logic_vector (3 downto 0);
            olddeathcount2 : in std_logic_vector (3 downto 0);
            oldpercentage1 : in std_logic_vector (7 downto 0);
            oldpercentage2 : in std_logic_vector (7 downto 0);
            oldvectorX1    : in std_logic_vector (8 downto 0);
            oldvectorY1    : in std_logic_vector (8 downto 0);
            oldvectorX2    : in std_logic_vector (8 downto 0);
            oldvectorY2    : in std_logic_vector (8 downto 0);
            restart1       : out std_logic;
            restart2       : out std_logic;
            vsync          : in std_logic;
            newdeathcount1 : out std_logic_vector (3 downto 0);
            newdeathcount2 : out std_logic_vector (3 downto 0));
    end component killzonedetector;

    component coldet is
        port (
            clk          : in std_logic;
            res          : in std_logic;
            a1           : in std_logic;
            a2           : in std_logic;
            b1           : in std_logic;
            b2           : in std_logic;
            o1           : in std_logic;
            o2           : in std_logic;
            x1           : in std_logic_vector (8 downto 0);
            x2           : in std_logic_vector (8 downto 0);
            y1           : in std_logic_vector (8 downto 0);
            y2           : in std_logic_vector (8 downto 0);
            direction_x1 : out std_logic_vector (7 downto 0);
            direction_x2 : out std_logic_vector (7 downto 0);
            direction_y1 : out std_logic_vector(7 downto 0);
            direction_y2 : out std_logic_vector(7 downto 0);
            collision1a2 : out std_logic;
            collision2a1 : out std_logic;
            collision1b2 : out std_logic;
            collision2b1 : out std_logic);
    end component coldet;

    signal co1a2,
    co1b2,
    co2a1,
    co2b1 : std_logic;

	component m_resethandler is
		port(
			reset      : in  std_logic;
			resetp1    : in  std_logic;
			resetp2    : in  std_logic;
			resetp1out : out std_logic;
			resetp2out : out std_logic);
	 end component m_resethandler;
 
	 signal resetp1int : std_logic;
	 signal resetp2int : std_logic;
 
	 component writelogic is 
	 port(
		 clk			: in std_logic;
		 reset		: in std_logic;
		 vsync		: in std_logic;
		 write 		: out std_logic);
	 end component writelogic;
	 
	 signal writeint : std_logic;
	 
	 component ram_4b is
	 port(
		 clk			: in std_logic;
		 reset		: in std_logic;
		 data_in 	: in std_logic_vector(3 downto 0);
		 data_out 	: out std_logic_vector(3 downto 0);
		 write 		: in std_logic);
	 end component ram_4b;
	 
	 component ram_8b is
	 port(
		 clk			: in std_logic;
		 reset		: in std_logic;
		 initial		: in std_logic_vector(7 downto 0);
		 data_in 	: in std_logic_vector(7 downto 0);
		 data_out 	: out std_logic_vector(7 downto 0);
		 write 		: in std_logic);
	 end component ram_8b;
	 
	 component ram_9b is
	 port(
		 clk			: in std_logic;
		 reset		: in std_logic;
		 initial		: in std_logic_vector(8 downto 0);
		 data_in 	: in std_logic_vector(8 downto 0);
		 data_out 	: out std_logic_vector(8 downto 0);
		 write 		: in std_logic);
	 end component ram_9b;
	 
	 component ram_10b is
	 port(
		 clk			: in std_logic;
		 reset		: in std_logic;
		 data_in 	: in std_logic_vector(9 downto 0);
		 data_out 	: out std_logic_vector(9 downto 0);
		 write 		: in std_logic);
	 end component ram_10b;

	 begin 
		