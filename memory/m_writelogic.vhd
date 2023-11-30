entity writelogic is 
port(
	clk		: in std_logic;
	reset	: in std_logic;
	vsync	: in std_logic;
	write	: out std_logic);
end writelogic;

architecture behaviour of writelogic is
	type writestate is	(	off,
							on1,
							on2);
	signal state, new_state :	writestate;
begin
	process(clk) is
	begin
		if (reset = '1') then
			state <= off;
		else
			state <= new_state;
		end if;
	end process;
	process(vsync, state) is
	begin
		case state is
			when off =>
				write <= '0';
				if (vsync = '0') then	
					new_state <= on1;
				else
					new_state <= off;
				end if;
			when on1 =>
				write <= '1';
				if (vsync = '0') then
					new_state <= on2;
				else
					new_state <= off;
				end if;
			when on2 =>
				write <= '0';
				if (vsync = '0') then
					new_state <= on2;	
				else
					new_state <= off;
				end if;
		end case;
	end process;
end behaviour;

configuration writelogic_behaviour_cfg of writelogic is
   for behaviour
   end for;
end writelogic_behaviour_cfg;