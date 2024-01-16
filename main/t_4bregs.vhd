library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity t_4bregs is
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        vec_in  : in std_logic_vector(3 downto 0);
        vec_out : out std_logic_vector(3 downto 0)
    );
end entity t_4bregs;

architecture rtl of t_4bregs is

    subtype stored_type is std_logic_vector(3 downto 0);
    signal stored : stored_type;

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                stored <= (others => '0');
            else
                stored <= vec_in;
            end if;
        end if;
    end process;
    vec_out <= stored;
end architecture;